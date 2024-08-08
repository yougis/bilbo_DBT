--CREATE TABLE processing.dtm_indicateur_zones_brulees_foncier AS

SELECT
    dtm.annee,
    dtm.id_spatial,
    dtm.upper_libelle,
    ds.superficie_ha AS sup_total_id_spatial, -- superficie totale de l'id_spatial
    dtm.level,
    dtm.superficie_ha AS superficie_ha, -- superficie_ha
    ROUND((dtm.superficie_ha * 1.0 / ds.superficie_ha) * 100.0, 2) AS indicateur_1,
    SUM(dtm.superficie_ha) OVER (PARTITION BY dtm.annee, dtm.level) AS sum_level,
    ROUND((dtm.superficie_ha * 1.0 / SUM(dtm.superficie_ha) OVER (PARTITION BY dtm.annee, dtm.level)) * 100.0, 2) AS indicateur_2,
    ROUND((dtm.superficie_ha * 1.0 / SUM(ds.superficie_ha) OVER (PARTITION BY dtm.annee, dtm.level)) * 100.0, 2) AS indicateur_2bis
    
FROM
    processing."dtm_zones_brulees_foncier_annee_level" AS dtm

LEFT JOIN
    processing."dim_spatial_superficie" AS ds
ON
    dtm.id_spatial = ds.id_spatial

GROUP BY
    dtm.annee,
    dtm.id_spatial,
    dtm.upper_libelle,
    dtm.level

ORDER BY
    dtm.annee,
    dtm.id_spatial,
    dtm.upper_libelle,
    dtm.level;