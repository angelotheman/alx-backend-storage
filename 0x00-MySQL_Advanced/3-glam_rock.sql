-- List all bands with Glam rock

SELECT 
    band_name,
    IFNULL(2022 - formed, 0) AS lifespan
FROM metal_bands
WHERE style LIKE '%Glam rock%'
ORDER BY lifespan DESC;
