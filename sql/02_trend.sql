-- Semana 2: comparación entre semestres y medias móviles con funciones de ventana.
-- Serie de Casanare desde 2008-I (los datos anteriores de la ENAM se excluyen, ver README).

-- Variación frente al semestre anterior
SELECT period,
       ROUND(yield_t_ha, 2) AS yield_t_ha,
       ROUND(yield_t_ha - LAG(yield_t_ha) OVER (ORDER BY period), 2) AS change_vs_prev
FROM yields
WHERE region = 'Casanare'
  AND period >= '2008-I'
ORDER BY period;

-- Media móvil de 6 semestres (3 años): las 5 filas anteriores más la actual
SELECT period,
       ROUND(yield_t_ha, 2) AS yield_t_ha,
       ROUND(AVG(yield_t_ha) OVER (ORDER BY period ROWS BETWEEN 5 PRECEDING AND CURRENT ROW), 2) AS moving_avg_6
FROM yields
WHERE region = 'Casanare'
  AND period >= '2008-I'
ORDER BY period;

-- Estadísticas del rendimiento por semestre (I contra II)
WITH casanare AS (
    SELECT period,
           split_part(period, '-', 2) AS semester,
           yield_t_ha
    FROM yields
    WHERE region = 'Casanare'
      AND period >= '2008-I'
)
SELECT semester,
       COUNT(*)                     AS semesters,
       ROUND(AVG(yield_t_ha), 2)    AS avg_yield,
       ROUND(STDDEV(yield_t_ha), 2) AS std_yield,
       ROUND(MIN(yield_t_ha), 2)    AS min_yield,
       ROUND(MAX(yield_t_ha), 2)    AS max_yield
FROM casanare
GROUP BY semester
ORDER BY semester;

-- Variación frente al semestre anterior y frente al mismo semestre del año anterior
WITH casanare AS (
    SELECT period,
           split_part(period, '-', 2) AS semester,
           yield_t_ha
    FROM yields
    WHERE region = 'Casanare'
      AND period >= '2008-I'
)
SELECT period,
       semester,
       ROUND(yield_t_ha, 2) AS yield_t_ha,
       ROUND(yield_t_ha - LAG(yield_t_ha) OVER (ORDER BY period), 2) AS change_vs_prev,
       ROUND(yield_t_ha - LAG(yield_t_ha) OVER (PARTITION BY semester ORDER BY period), 2) AS change_vs_last_year
FROM casanare
ORDER BY period;

-- Rendimiento relativo al promedio general y al promedio de su propio semestre
WITH casanare AS (
    SELECT period,
           split_part(period, '-', 2) AS semester,
           yield_t_ha
    FROM yields
    WHERE region = 'Casanare'
      AND period >= '2008-I'
)
SELECT period,
       semester,
       ROUND(yield_t_ha, 2) AS yield_t_ha,
       ROUND(yield_t_ha / AVG(yield_t_ha) OVER (), 3)                      AS ratio_all,
       ROUND(yield_t_ha / AVG(yield_t_ha) OVER (PARTITION BY semester), 3) AS ratio_own_semester
FROM casanare
ORDER BY ratio_all;
