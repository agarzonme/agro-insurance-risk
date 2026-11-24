-- Semana 3: calidad de la lluvia del IDEAM y clima de cada cosecha.
-- La ventana de cada cosecha se arma sumándole 3 meses a cada fecha: de abril a septiembre
-- quedan en el periodo II del mismo año, y de octubre a marzo en el periodo I del año siguiente.

-- Calidad de los datos de lluvia: días con dato y lluvia total por estación y año
SELECT station,
       EXTRACT(year FROM date) AS year,
       COUNT(*)                AS days,
       ROUND(SUM(rain_mm))     AS total_mm
FROM rain
GROUP BY station, year
ORDER BY station, year;

-- ONI promedio de cada cosecha (6 meses por ventana)
WITH monthly AS (
    SELECT year,
           month,
           make_date(year, month, 1) + INTERVAL 3 MONTH AS shifted,
           oni
    FROM oni
),
by_period AS (
    SELECT year,
           month,
           CAST(EXTRACT(year FROM shifted) AS INTEGER) || '-' ||
           CASE WHEN EXTRACT(month FROM shifted) <= 6 THEN 'I' ELSE 'II' END AS period,
           oni
    FROM monthly
)
SELECT period,
       COUNT(*)           AS months,
       ROUND(AVG(oni), 2) AS oni_avg
FROM by_period
WHERE period >= '2008-I'
GROUP BY period
ORDER BY period;

-- Lluvia de cada cosecha por estación, con los días que tienen dato
WITH daily AS (
    SELECT station,
           date + INTERVAL 3 MONTH AS shifted,
           rain_mm
    FROM rain
),
by_period AS (
    SELECT station,
           CAST(EXTRACT(year FROM shifted) AS INTEGER) || '-' ||
           CASE WHEN EXTRACT(month FROM shifted) <= 6 THEN 'I' ELSE 'II' END AS period,
           rain_mm
    FROM daily
)
SELECT station,
       period,
       COUNT(*)            AS days,
       ROUND(SUM(rain_mm)) AS rain_mm
FROM by_period
WHERE period >= '2008-I'
GROUP BY station, period
ORDER BY station, period;

-- Huecos de Paz de Ariporo en la ventana 2020-II (abril a septiembre de 2020)
SELECT EXTRACT(month FROM date) AS month,
       COUNT(*)                 AS days,
       ROUND(SUM(rain_mm))      AS rain_mm
FROM rain
WHERE station LIKE 'PAZ%'
  AND date BETWEEN '2020-04-01' AND '2020-09-30'
GROUP BY month
ORDER BY month;
