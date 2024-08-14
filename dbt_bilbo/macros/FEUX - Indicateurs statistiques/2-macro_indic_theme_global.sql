{% macro indic_theme_global(theme) %}

    SELECT
        dtm.annee,
        dtm.id_spatial,
        dtm.upper_libelle,
        CAST(ds.superficie_ha AS NUMERIC) AS sup_total_id_spatial,
        dtm.level,
        COALESCE(af.sup_total_theme, 0) AS sup_total_theme,
        SUM(dtm.superficie_ha) AS superficie_ha,
        SUM(af.nb_theme) AS nb_theme,
        SUM(dtm.nb_indic) AS nb_indic,
        SUM(dtm.nb_theme_indic) AS nb_theme_indic,
        ROUND(
            CASE 
                WHEN CAST(ds.superficie_ha AS NUMERIC) != 0 
                THEN (SUM(dtm.superficie_ha) * 100.0 / CAST(ds.superficie_ha AS NUMERIC)) 
                ELSE NULL 
            END, 
            2
        ) AS indicateur_1,
        SUM(SUM(dtm.superficie_ha)) OVER (PARTITION BY dtm.annee, dtm.level) AS sum_level,
        ROUND(
            CASE 
                WHEN SUM(SUM(dtm.superficie_ha)) OVER (PARTITION BY dtm.annee, dtm.level) != 0 
                THEN (SUM(dtm.superficie_ha) * 100.0 / SUM(SUM(dtm.superficie_ha)) OVER (PARTITION BY dtm.annee, dtm.level)) 
                ELSE NULL 
            END, 
            2
        ) AS indicateur_2,
        ROUND(
            CASE 
                WHEN COALESCE(af.sup_total_theme, 0) != 0 
                THEN (SUM(dtm.superficie_ha) * 100.0 / COALESCE(af.sup_total_theme, 0)) 
                ELSE NULL 
            END, 
            2
        ) AS indicateur_3,
        SUM(COALESCE(af.sup_total_theme, 0)) OVER (PARTITION BY dtm.annee, dtm.level) AS sum_theme_theme,
        ROUND(
            CASE 
                WHEN SUM(COALESCE(af.sup_total_theme, 0)) OVER (PARTITION BY dtm.annee, dtm.level) != 0 
                THEN (SUM(dtm.superficie_ha) * 100.0 / SUM(COALESCE(af.sup_total_theme, 0)) OVER (PARTITION BY dtm.annee, dtm.level)) 
                ELSE NULL 
            END, 
            2
        ) AS indicateur_4,
        ROUND(
            CASE 
                WHEN SUM(af.nb_theme) != 0 
                THEN (SUM(dtm.nb_theme_indic) * 100.0 / SUM(af.nb_theme)) 
                ELSE NULL 
            END, 
            2
        ) AS indicateur_5
    FROM
        {{ source("oeil_traitement-processing", "dtm_zones_brulees_" ~ theme ~ "_annee_level") }} AS dtm

    LEFT JOIN
        {{ source("oeil_traitement_processing", "dim_spatial_superficie") }} AS ds
    ON
        dtm.id_spatial = ds.id_spatial

    LEFT JOIN (
        SELECT
            id_spatial,
            dimension_spatiale,
            type_spatial,
            ROUND(CAST(SUM(values) AS NUMERIC), 2) AS sup_total_theme,
            COUNT(DISTINCT id_thematique) AS nb_theme
        FROM
            {{ source("oeil_traitement-contexte", "admin_" ~ theme) }}
        GROUP BY
            id_spatial,
            dimension_spatiale,
            type_spatial
    ) af
    ON
        dtm.id_spatial = af.id_spatial

    GROUP BY
        dtm.annee,
        dtm.id_spatial,
        dtm.upper_libelle,
        dtm.level,
        ds.superficie_ha,
        af.sup_total_theme

    ORDER BY
        dtm.annee,
        dtm.id_spatial,
        dtm.upper_libelle,
        dtm.level

{% endmacro %}
