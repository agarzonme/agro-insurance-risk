# agro-insurance-risk
- Proyecto de aprendizaje: explícame cada cambio en español, en pocas palabras.
- Idioma: los nombres dentro del código (variables, funciones, columnas, archivos) van en inglés; todo lo demás va en español: comentarios, docstrings, README, notebooks, gráficos y mensajes de commit. El público es colombiano (LinkedIn).
- Cada fuente tiene su propio cargador (load_enam.py, load_eva.py...). Todos producen la tabla yields con columnas crop, region, period, yield_t_ha, source.
- Las fuentes de clima tienen su propio cargador y su propia tabla: load_oni.py -> oni (year, month, oni, source); load_ideam.py -> rain.
- Ni los cargadores ni src/risk.py filtran por región escrita a mano. Cultivo y región entran como parámetros o desde config/crops.csv.
- Usa el entorno .venv y corre los scripts desde la raíz del repo.
- No hagas commit ni push sin que yo lo pida.
- Los ejercicios los hago yo para aprender. Ayúdame con Git, errores y revisión; no escribas el código de los ejercicios salvo que te lo pida.

## Estado actual
- Plan de 6 semanas. Semana 2 (tendencia y semestres malos): sql/02_trend.sql, notebooks/02_trend.ipynb y detrend() en src/risk.py.
- Hallazgos: el semestre I rinde ~9% más que el II, así que se analizan por separado; la tendencia es casi plana; con umbral de 85% el único semestre malo es 2011-II.
