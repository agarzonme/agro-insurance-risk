"""Carga el índice ONI de la NOAA (El Niño y La Niña) en la tabla oni de DuckDB.

Fuente: https://www.cpc.ncep.noaa.gov/data/indices/oni.ascii.txt
Correr desde la raíz del repositorio:  python src/load_oni.py
"""
from pathlib import Path

import duckdb
import pandas as pd

RAW_FILE = Path("data/raw/oni.ascii.txt")
DB_PATH = Path("data/processed/agro.duckdb")
SOURCE = "NOAA-CPC ONI"

# Cada ventana de 3 meses se asigna a su mes del centro: DJF (dic-ene-feb) -> 1 (enero)
SEASON_MONTH =  {
    "DJF": 1, "JFM": 2, "FMA": 3, "MAM": 4, "AMJ": 5, "MJJ": 6,
    "JJA": 7, "JAS": 8, "ASO": 9, "SON": 10, "OND": 11, "NDJ": 12,
}

def read_oni(path: Path) -> pd.DataFrame:
    """Origen: lee el archivo tal cual."""
    return pd.read_csv(path, sep=r"\s+")

def to_standard(raw: pd.DataFrame) -> pd.DataFrame:
    """Transforma: una fila por mes, con las columnas estándar."""
    df = raw.rename(columns={"YR": "year", "ANOM": "oni"})
    df["month"] = df["SEAS"].map(SEASON_MONTH)
    df["source"] = SOURCE
    return df[["year", "month", "oni", "source"]]

def save(df: pd.DataFrame, db_path: Path) -> None:
    """Carga: guarda la tabla en DuckDB, reemplazándola si ya existía."""
    db_path.parent.mkdir(parents=True, exist_ok=True)
    con = duckdb.connect(str(db_path))
    con.register("staging", df)
    con.execute("CREATE OR REPLACE TABLE oni AS SELECT * FROM staging")
    con.close()

if __name__ == "__main__":
    oni = to_standard(read_oni(RAW_FILE))
    save(oni, DB_PATH)
    print(f"{len(oni)} filas guardadas en {DB_PATH}")
    print(oni.head(1).to_string(index=False))
    print(oni.tail(1).to_string(index=False))
    print("Meses sin asignar:", oni["month"].isna().sum())