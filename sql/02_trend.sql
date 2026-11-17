---Compartion con el semestre anterior

SELECT period,
       ROUND(yield_t_ha, 2) AS yield_t_ha,
       ROUND(yield_t_ha - LAG(yield_t_ha) OVER (ORDER BY period), 2) AS change_vs_prev
FROM yields
WHERE region = 'Casanare'
  AND period >= '2008-I'
ORDER BY period;

---Comparacion con cinco años años atrás
SELECT period,
       ROUND(yield_t_ha, 2) AS yield_t_ha,
       ROUND(AVG(yield_t_ha) OVER (ORDER BY period ROWS BETWEEN 5 PRECEDING AND CURRENT ROW), 2) AS moving_avg_5_years
FROM yields
WHERE region = 'Casanare'
  AND period >= '2008-I'
ORDER BY period;

---Se le saco la media, varianza el min y maz a produccion de t_ha por semestre, para ver la tendencia de la produccion de t_ha por semestre
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
       ROUND(min(yield_t_ha), 2) AS min_yield,
       ROUND(max(yield_t_ha), 2) AS max_yield
FROM casanare
GROUP BY semester
ORDER BY semester;

---la variacion respecto al semestre y al añpo anterior, para ver la tendencia de la produccion de t_ha por semestre
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

