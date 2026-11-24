"""Carga la lluvia diaria del IDEAM (DHIME) en la tabla rain de DuckDB.

Fuente: DHIME del IDEAM, parámetro "Día pluviométrico (convencional)", estaciones de Casanare.
Correr desde la raíz del repositorio:  python src/load_ideam.py
"""
from pathlib import Path

import duckdb
import pandas as pd

RAW_FILE = Path("data/raw/ideam_precipitacion_casanare.csv")
DB_PATH = Path("data/processed/agro.duckdb")
SOURCE = "IDEAM-DHIME"


def read_ideam(path: Path) -> pd.DataFrame:
    """Origen: lee el CSV tal cual lo entrega el DHIME."""
    return pd.read_csv(path)


def to_standard(raw: pd.DataFrame) -> pd.DataFrame:
    """Transforma: una fila por estación y día, con las columnas estándar."""
    df = raw.rename(columns={
        "CodigoEstacion": "station_code",
        "NombreEstacion": "station",
        "Fecha": "date",
        "Valor": "rain_mm",
        "NivelAprobacion": "approval",
    })
    df["date"] = pd.to_datetime(df["date"]).dt.date
    df["source"] = SOURCE
    return df[["station_code", "station", "date", "rain_mm", "approval", "source"]]


def save(df: pd.DataFrame, db_path: Path) -> None:
    """Carga: guarda la tabla en DuckDB, reemplazándola si ya existía."""
    db_path.parent.mkdir(parents=True, exist_ok=True)
    con = duckdb.connect(str(db_path))
    con.register("staging", df)
    con.execute("CREATE OR REPLACE TABLE rain AS SELECT * FROM staging")
    con.close()


def summary(df: pd.DataFrame) -> pd.DataFrame:
    """Filas, primera y última fecha por estación, para ver series incompletas."""
    return df.groupby("station")["date"].agg(rows="size", first="min", last="max")


if __name__ == "__main__":
    rain = to_standard(read_ideam(RAW_FILE))
    save(rain, DB_PATH)
    print(f"{len(rain)} filas guardadas en {DB_PATH}")
    print(summary(rain).to_string())
