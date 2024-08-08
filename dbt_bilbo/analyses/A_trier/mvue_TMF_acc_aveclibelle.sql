CREATE TABLE processing.agreg_TMF_acc_foncier AS

SELECT
    annee,
    id_spatial,
    upper_libelle,
    level,
    proprio_na,
    SUM(ROUND(CAST(ST_Area(geometry) / 10000 AS numeric), 2)) AS superficie_ha

FROM
    processing."faits_TMF_acc_foncier"

GROUP BY
    annee,
    id_spatial,
    upper_libelle,
    level,
    proprio_na

ORDER BY
    annee,
    id_spatial,
    upper_libelle,
    level,
    proprio_na;
