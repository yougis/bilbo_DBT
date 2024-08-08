CREATE TABLE processing.agreg_TMF_acc_v12022_h3_nc_6 AS

SELECT
    CAST(annee AS INTEGER) AS annee,
    id_spatial,
    upper_libelle,
    level,
    SUM(ROUND(CAST(ST_Area(geometry) / 10000 AS numeric), 2)) AS superficie_ha

FROM
    processing."faits_TMF_acc_v12022_h3_nc_6"

GROUP BY
    annee,
    id_spatial,
    upper_libelle,
    level

ORDER BY
    annee,
    id_spatial,
    upper_libelle,
    level;
