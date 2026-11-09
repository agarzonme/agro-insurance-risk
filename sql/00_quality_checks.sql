-- Data quality checks for the `yields` table (ENAM, semiannual)

-- 1. Coverage: how many semesters per region, and from when to when
SELECT region,
       COUNT(*)    AS semesters,
       MIN(period) AS first_period,
       MAX(period) AS last_period
FROM yields
GROUP BY region
ORDER BY region;

-- 2. Suspicious duplicates, summary by region: a semester II value equal
--    (to 2 decimals) to the semester I value of the following year
SELECT a.region,
       COUNT(*)      AS duplicates,
       MIN(a.period) AS first_dup,
       MAX(a.period) AS last_dup
FROM yields a
JOIN yields b
  ON a.region = b.region
 AND b.period = CAST(CAST(left(a.period, 4) AS INTEGER) + 1 AS VARCHAR) || '-I'
WHERE a.period LIKE '%-II'
  AND ROUND(a.yield_t_ha, 2) = ROUND(b.yield_t_ha, 2)
GROUP BY a.region
ORDER BY a.region;

-- 3. Same check, detail for Casanare only
SELECT a.period                AS semester_ii,
       ROUND(a.yield_t_ha, 2)  AS yield_ii,
       b.period                AS next_semester_i,
       ROUND(b.yield_t_ha, 2)  AS yield_i
FROM yields a
JOIN yields b
  ON a.region = b.region
 AND b.period = CAST(CAST(left(a.period, 4) AS INTEGER) + 1 AS VARCHAR) || '-I'
WHERE a.period LIKE '%-II'
  AND a.region = 'Casanare'
  AND ROUND(a.yield_t_ha, 2) = ROUND(b.yield_t_ha, 2)
ORDER BY a.period;

--Periodos
SELECT DISTINCT period
FROM yields
ORDER BY period;

--Rendimientos promedio por region
SELECT region,
       ROUND(AVG(yield_t_ha), 2) AS avg_yield
FROM yields
WHERE period >= '2008-I'
GROUP BY region
ORDER BY avg_yield DESC;

--La serie de casanare
SELECT period,
       ROUND(yield_t_ha, 2) AS yield_t_ha
FROM yields
WHERE region = 'Casanare'
  AND period >= '2008-I'
ORDER BY period;

--los peores y mejores rendimientos de casanare
select period, 
       round(yield_t_ha, 2) as yield_t_ha 
from yields 
where region = 'Casanare' 
  and period >= '2008-I' 
order by yield_t_ha desc;