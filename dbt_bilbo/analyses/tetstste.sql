SELECT
    dtm.annee,
    dtm.id_spatial,
    dtm.upper_libelle,
    dtm.level,
    dtm.type_ppe,
    ROUND(CAST(SUM(dtm.superficie_ha) AS NUMERIC), 2) AS superficie_ha,
    SUM(dtm.nb_indic) AS nb_indic,
    SUM(dtm.nb_theme_indic) AS nb_theme_indic
FROM
    processing.dtm_zones_brulees_perimetres_protection_eau_annee_level AS dtm

GROUP BY
    dtm.annee,
    dtm.id_spatial,
    dtm.upper_libelle,
    dtm.level,
    dtm.type_ppe

ORDER BY
    dtm.annee,
    dtm.id_spatial,
    dtm.upper_libelle,
    dtm.level,
    dtm.type_ppe;