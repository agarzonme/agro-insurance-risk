ELECT DISTINCT period
FROM yields
ORDER BY period;

SELECT region,
       ROUND(AVG(yield_t_ha), 2) AS avg_yield
FROM yields
WHERE period >= '2008-I'
GROUP BY region
ORDER BY avg_yield DESC;

SELECT period,
       ROUND(yield_t_ha, 2) AS yield_t_ha
FROM yields
WHERE region = 'Casanare'
  AND period >= '2008-I'
ORDER BY period;

select period, round(yield_t_ha, 2) as yield_t_ha from yields where region = 'Casanare' and period >= '2008-I' order by yield_t_ha desc;

SELECT * from yields;