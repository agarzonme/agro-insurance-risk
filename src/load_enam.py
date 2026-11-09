"""Load DANE-Fedearroz ENAM semiannual yields into the standard `yields` table in DuckDB.

Source: sheet "Históricos" of the ENAM annex, tables
"Rendimientos de arroz mecanizado según departamento. I Semestre" and "... II Semestre".
Run from the repository root:  python src/load_enam.py
"""
import re
from pathlib import Path

import duckdb
import pandas as pd

RAW_FILE = Path("data/raw/ENAM-2026.xlsx")   # <- nombre real del archivo
DB_PATH = Path("data/processed/agro.duckdb")
CROP = "arroz"
SOURCE = "DANE-ENAM (Históricos)"

# Reconoce encabezados como "2000 - I" o "2025 - II"
PERIOD = re.compile(r"^\s*(\d{4})\s*-\s*(I{1,2})\s*$")


def _period(value) -> str | None:
    """'2000 - I' -> '2000-I'; cualquier otra cosa -> None."""
    match = PERIOD.match(str(value))
    return f"{match.group(1)}-{match.group(2)}" if match else None


def _is_end_of_table(first_cell) -> bool:
    """La tabla termina en la fuente, las notas o la nota al pie ('1 Resto...')."""
    text = str(first_cell).strip()
    return text.lower().startswith(("fuente", "nota")) or text[:1].isdigit()


def read_historicos(path: Path) -> pd.DataFrame:
    """Origen: lee la hoja de históricos tal cual, sin adivinar encabezados."""
    sheet = next(s for s in pd.ExcelFile(path).sheet_names if "hist" in s.lower())
    return pd.read_excel(path, sheet_name=sheet, header=None)


def find_yield_tables(raw: pd.DataFrame) -> list[pd.DataFrame]:
    """Encuentra cada tabla semestral de rendimiento y la devuelve con sus encabezados."""
    tables = []
    for i in range(len(raw)):
        periods = [_period(v) for v in raw.iloc[i, 1:]]
        if not any(periods):
            continue  # esta fila no es un encabezado de semestres
        context = " ".join(str(v) for v in raw.iloc[max(i - 2, 0) : i].to_numpy().ravel())
        if "rendimiento" not in context.lower():
            continue  # es una tabla de otra variable (área, producción...)

        rows, blanks = [], 0
        for j in range(i + 1, len(raw)):
            first = raw.iloc[j, 0]
            if pd.isna(first) or str(first).strip() == "":
                blanks += 1
                if blanks == 2:
                    break
                continue
            if _is_end_of_table(first):
                break
            blanks = 0
            rows.append(raw.iloc[j])

        table = pd.DataFrame(rows)
        table.columns = ["region"] + periods
        tables.append(table.loc[:, [c is not None for c in table.columns]])
    return tables


def to_standard(tables: list[pd.DataFrame]) -> pd.DataFrame:
    """Anula la dinamización y limpia: una fila por departamento y semestre."""
    long = pd.concat(
        [t.melt(id_vars="region", var_name="period", value_name="yield_t_ha") for t in tables],
        ignore_index=True,
    )
    long["region"] = (
        long["region"].astype(str).str.replace(r"\d+$", "", regex=True).str.strip()
    )  # "Resto Departamentos1" -> "Resto Departamentos"
    long["yield_t_ha"] = pd.to_numeric(
        long["yield_t_ha"].astype(str).str.replace(",", ".", regex=False),
        errors="coerce",
    )  # acepta 5.82 o "5,82"
    long = long.dropna(subset=["yield_t_ha"])  # quita celdas vacías

    long["crop"] = CROP
    long["source"] = SOURCE
    long = long.sort_values(["region", "period"])
    return long[["crop", "region", "period", "yield_t_ha", "source"]].reset_index(drop=True)


def save(df: pd.DataFrame, db_path: Path) -> None:
    """Carga: guarda la tabla en DuckDB, reemplazándola si ya existía."""
    db_path.parent.mkdir(parents=True, exist_ok=True)
    con = duckdb.connect(str(db_path))
    con.register("staging", df)
    con.execute("CREATE OR REPLACE TABLE yields AS SELECT * FROM staging")
    con.close()


if __name__ == "__main__":
    tables = find_yield_tables(read_historicos(RAW_FILE))
    yields = to_standard(tables)
    save(yields, DB_PATH)
    print(f"Tablas semestrales encontradas: {len(tables)} (deben ser 2: I y II)")
    print(yields[yields["region"] == "Casanare"].tail(6).to_string(index=False))
    print(f"\n{len(yields)} filas guardadas en {DB_PATH}")
    print("Regiones:", ", ".join(yields["region"].unique()))