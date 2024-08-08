{% macro indicateur(theme, champ_theme) %}

    SELECT
        dtm.annee,
        dtm.id_spatial,
        dtm.upper_libelle,
        ROUND(CAST(ds.superficie_ha AS NUMERIC), 2) AS sup_total_id_spatial,
        dtm.level,
        dtm.{{ champ_theme }},
        COALESCE(af.sup_total_theme, 0) AS sup_total_theme,
        dtm.superficie_ha,
        ROUND(CAST(dtm.superficie_ha AS NUMERIC) * 100.0 / NULLIF(CAST(ds.superficie_ha AS NUMERIC), 0), 2) AS indicateur_1,
        SUM(CAST(dtm.superficie_ha AS NUMERIC)) OVER (PARTITION BY dtm.annee, dtm.level, dtm.{{ champ_theme }}) AS sum_level_theme,
        ROUND(CAST(dtm.superficie_ha AS NUMERIC) * 100.0 / NULLIF(SUM(CAST(dtm.superficie_ha AS NUMERIC)) OVER (PARTITION BY dtm.annee, dtm.level, dtm.{{ champ_theme }}), 0), 2) AS indicateur_2,
        ROUND(CAST(dtm.superficie_ha AS NUMERIC) * 100.0 / NULLIF(CAST(COALESCE(af.sup_total_theme, 0) AS NUMERIC), 0), 2) AS indicateur_3,
        SUM(CAST(COALESCE(af.sup_total_theme, 0) AS NUMERIC)) OVER (PARTITION BY dtm.annee, dtm.level, dtm.{{ champ_theme }}) AS sum_theme_theme,
        ROUND(CAST(dtm.superficie_ha AS NUMERIC) * 100.0 / NULLIF(SUM(CAST(COALESCE(af.sup_total_theme, 0) AS NUMERIC)) OVER (PARTITION BY dtm.annee, dtm.level, dtm.{{ champ_theme }}), 0), 2) AS indicateur_4

    FROM
        {{ source("oeil_traitement_processing", "dtm_zones_brulees_" ~ theme ~ "_annee_level") }} AS dtm

    LEFT JOIN
        {{ source("oeil_traitement_processing","dim_spatial_superficie") }} AS ds
    ON
        dtm.id_spatial = ds.id_spatial

    LEFT JOIN
        (SELECT
            id_spatial,
            dimension_spatiale,
            type_spatial,
            {{ champ_theme }},
            ROUND(CAST(SUM(values) AS NUMERIC), 2) AS sup_total_theme
        FROM
        {{ source("oeil_traitement_contexte", "admin_" ~ theme) }}


        GROUP BY
            id_spatial,
            dimension_spatiale,
            type_spatial,
            {{ champ_theme }}) AS af
    ON
        dtm.id_spatial = af.id_spatial AND
        dtm.{{ champ_theme }} = af.{{ champ_theme }}

    ORDER BY
        dtm.annee,
        dtm.id_spatial,
        dtm.upper_libelle,
        dtm.level,
        dtm.{{champ_theme }}

{% endmacro %}
    

