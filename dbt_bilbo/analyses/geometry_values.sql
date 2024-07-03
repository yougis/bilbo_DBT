-- Obtenir la valeur de superficie (ha) à partir du champs "geometry"
-- Vérifier si ce sont des m2 ou ha ?

--CREATE EXTENSION IF NOT EXISTS postgis;

--CREATE TABLE processing."faits_GFC_gain_APP_superficie" AS
SELECT 
    id_spatial,
    upper_libelle,
    ROUND(CAST(ST_Area(geometry) / 10000 AS numeric), 2) AS superficie,
    geometry
FROM 
    carto."dim_spatial";
