SELECT
    dtm.annee,
    dtm.id_spatial,
    dtm.upper_libelle,
    ROUND(CAST(ds.superficie_ha AS NUMERIC), 2) AS sup_total_id_spatial,
    dtm.level,
    dtm.proprio_ty,
    COALESCE(af.sup_total_theme, 0) AS sup_total_theme,
    dtm.superficie_ha,
    ROUND(CAST(dtm.superficie_ha AS NUMERIC) * 100.0 / NULLIF(CAST(ds.superficie_ha AS NUMERIC), 0), 2) AS indicateur_1,
    SUM(CAST(dtm.superficie_ha AS NUMERIC)) OVER (PARTITION BY dtm.annee, dtm.level, dtm.proprio_ty) AS sum_level_theme,
    ROUND(CAST(dtm.superficie_ha AS NUMERIC) * 100.0 / NULLIF(SUM(CAST(dtm.superficie_ha AS NUMERIC)) OVER (PARTITION BY dtm.annee, dtm.level, dtm.proprio_ty), 0), 2) AS indicateur_2,
    ROUND(CAST(dtm.superficie_ha AS NUMERIC) * 100.0 / NULLIF(CAST(COALESCE(af.sup_total_theme, 0) AS NUMERIC), 0), 2) AS indicateur_3,
    SUM(CAST(COALESCE(af.sup_total_theme, 0) AS NUMERIC)) OVER (PARTITION BY dtm.annee, dtm.level, dtm.proprio_ty) AS sum_theme_theme,
    ROUND(CAST(dtm.superficie_ha AS NUMERIC) * 100.0 / NULLIF(SUM(CAST(COALESCE(af.sup_total_theme, 0) AS NUMERIC)) OVER (PARTITION BY dtm.annee, dtm.level, dtm.proprio_ty), 0), 2) AS indicateur_4

FROM
    processing."dtm_zones_brulees_foncier_annee_level" AS dtm

LEFT JOIN
    processing."dim_spatial_superficie" AS ds
ON
    dtm.id_spatial = ds.id_spatial

LEFT JOIN
    (SELECT
        id_spatial,
        dimension_spatiale,
        type_spatial,
        proprio_ty,
        ROUND(CAST(SUM(values) AS NUMERIC), 2) AS sup_total_theme
    FROM
        contexte."admin_foncier"
    GROUP BY
        id_spatial,
        dimension_spatiale,
        type_spatial,
        proprio_ty) AS af
ON
    dtm.id_spatial = af.id_spatial AND
    dtm.proprio_ty = af.proprio_ty

ORDER BY
    dtm.annee,
    dtm.id_spatial,
    dtm.upper_libelle,
    dtm.level,
    dtm.proprio_ty;
    

