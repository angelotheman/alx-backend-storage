-- Ranks country by origin and unique fans


USE metal_bands;

SELECT
    origin,
    SUM(fans) AS nb_fans,
FROM metal_bands
GROUP BY nb_fans
ORDER BY nb_fans DESC;
