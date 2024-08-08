CREATE TABLE processing."dim_spatial_superficie" AS
SELECT 
    *,
    CAST(ST_Area(geometry) / 10000 AS numeric) AS superficie_ha
FROM 
    carto."dim_spatial";
