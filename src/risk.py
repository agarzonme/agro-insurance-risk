"""Funciones de riesgo reutilizables para cualquier cultivo y región.

En este módulo no se escribe ningún cultivo ni región: siempre entran como
parámetros o desde config/crops.csv.
"""
import numpy as np
import pandas as pd


def detrend(df: pd.DataFrame, degree: int = 1, by: str | None = "semester") -> pd.DataFrame:
    """Ajusta una tendencia al rendimiento en el tiempo y mide cuánto se aleja cada periodo.

    df debe tener las columnas `year` y `yield_t_ha` (y la columna `by`, si se usa).
    Se ajusta una tendencia distinta para cada valor de `by` (por ejemplo, el
    semestre I y el semestre II). Para datos anuales, usa by=None.

    Devuelve una copia de df con dos columnas nuevas:
      trend      rendimiento esperado para ese año (t/ha)
      deviation  yield_t_ha / trend - 1  (-0.15 = 15% por debajo de la tendencia)
    """
    out = df.copy()
    out["trend"] = np.nan

    if by is None:
        groups = pd.Series("all", index=out.index)
    else:
        groups = out[by]

    for value in groups.unique():
        rows = groups == value
        coefs = np.polyfit(out.loc[rows, "year"], out.loc[rows, "yield_t_ha"], deg=degree)
        out.loc[rows, "trend"] = np.polyval(coefs, out.loc[rows, "year"])

    out["deviation"] = out["yield_t_ha"] / out["trend"] - 1
    return out
