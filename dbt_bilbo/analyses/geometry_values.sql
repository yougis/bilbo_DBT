-- Obtenir la valeur de superficie (ha) à partir du champs "geometry"
-- Vérifier si ce sont des m2 ou ha ?

--CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE processing."faits_GFC_gain_APP_superficie" AS
SELECT 
    annee,
    id_spatial,
    upper_libelle,
    level,
    libelle,
    nature,
    milieu,
    classe, 
    ST_Area(geometry) AS superficie,
    geometry

FROM 
    processing."faits_GFC_gain_APP";

