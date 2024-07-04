--CREATE EXTENSION IF NOT EXISTS postgis;

--CREATE TABLE processing."faits_GFC_lossyear_h3_nc_6_APP" AS

SELECT 
    CASE
        WHEN ROUND(CAST(f.annee AS numeric)) < 100 THEN ROUND(CAST(f.annee AS numeric)) + 2000
        ELSE ROUND(CAST(f.annee AS numeric))
    END AS annee,
    f.id_spatial,
    f.upper_libelle,
    f.level,
    f.libelle,
    f.nature,
    f.milieu,
    SUM(ROUND(CAST(ST_Area(geometry) / 10000 AS numeric), 2)) AS sum_values

FROM 
    processing."faits_GFC_lossyear_h3_nc_6_APP" f

GROUP BY 
    annee, 
    f.id_spatial,
    f.upper_libelle,
    f.level,
    f.libelle,
    f.nature,
    f.milieu

ORDER BY
    annee, 
    f.id_spatial,
    f.upper_libelle,
    f.level,
    f.libelle,
    f.nature,
    f.milieu;
