{% macro indic_theme_spe(theme, champ_theme) %}

    WITH dtm_agg AS (
        SELECT
            dtm.annee,
            dtm.id_spatial,
            dtm.upper_libelle,
            dtm.level,
            dtm.{{ champ_theme }},
            ROUND(CAST(SUM(dtm.superficie_ha) AS NUMERIC), 2) AS superficie_ha,
            SUM(dtm.nb_indic) AS nb_indic,
            SUM(dtm.nb_theme_indic) AS nb_theme_indic
        FROM
            {{ source("oeil_traitement-processing", "dtm_zones_brulees_" ~ theme ~ "_annee_level") }} AS dtm
        GROUP BY
            dtm.annee,
            dtm.id_spatial,
            dtm.upper_libelle,
            dtm.level,
            dtm.{{ champ_theme }}
    )

    SELECT
        dtm_agg.annee,
        dtm_agg.id_spatial,
        dtm_agg.upper_libelle,
        ROUND(CAST(ds.superficie_ha AS NUMERIC), 2) AS sup_total_id_spatial,
        dtm_agg.level,
        dtm_agg.{{ champ_theme }},
        COALESCE(af.sup_total_theme, 0) AS sup_total_theme,
        dtm_agg.superficie_ha,
        ROUND(CAST(dtm_agg.superficie_ha AS NUMERIC) * 100.0 / NULLIF(CAST(ds.superficie_ha AS NUMERIC), 0), 2) AS indicateur_1,
        SUM(CAST(dtm_agg.superficie_ha AS NUMERIC)) OVER (PARTITION BY dtm_agg.annee, dtm_agg.level, dtm_agg.{{ champ_theme }}) AS sum_level_theme,
        ROUND(CAST(dtm_agg.superficie_ha AS NUMERIC) * 100.0 / NULLIF(SUM(CAST(dtm_agg.superficie_ha AS NUMERIC)) OVER (PARTITION BY dtm_agg.annee, dtm_agg.level, dtm_agg.{{ champ_theme }}), 0), 2) AS indicateur_2,
        ROUND(CAST(dtm_agg.superficie_ha AS NUMERIC) * 100.0 / NULLIF(CAST(COALESCE(af.sup_total_theme, 0) AS NUMERIC), 0), 2) AS indicateur_3,
        SUM(CAST(COALESCE(af.sup_total_theme, 0) AS NUMERIC)) OVER (PARTITION BY dtm_agg.annee, dtm_agg.level, dtm_agg.{{ champ_theme }}) AS sum_theme_theme,
        ROUND(CAST(dtm_agg.superficie_ha AS NUMERIC) * 100.0 / NULLIF(SUM(CAST(COALESCE(af.sup_total_theme, 0) AS NUMERIC)) OVER (PARTITION BY dtm_agg.annee, dtm_agg.level, dtm_agg.{{ champ_theme }}), 0), 2) AS indicateur_4,
        af.nb_theme,
        dtm_agg.nb_indic,
        dtm_agg.nb_theme_indic,
        ROUND(CAST(dtm_agg.nb_theme_indic AS NUMERIC) * 100.0 / NULLIF(SUM(CAST(af.nb_theme AS NUMERIC)) OVER (PARTITION BY dtm_agg.annee, dtm_agg.level, dtm_agg.{{ champ_theme }}), 0), 2) AS indicateur_5

    FROM
        dtm_agg

    LEFT JOIN
        {{ source("oeil_traitement_processing","dim_spatial_superficie") }} AS ds
    ON
        dtm_agg.id_spatial = ds.id_spatial

    LEFT JOIN
        (SELECT
            id_spatial,
            dimension_spatiale,
            type_spatial,
            {{ champ_theme }},
            ROUND(CAST(SUM(values) AS NUMERIC), 2) AS sup_total_theme,
            COUNT(DISTINCT id_thematique) AS nb_theme
        FROM
        {{ source("oeil_traitement-processing", "admin_" ~ theme) }}

        GROUP BY
            id_spatial,
            dimension_spatiale,
            type_spatial,
            {{ champ_theme }}) AS af
    ON
        dtm_agg.id_spatial = af.id_spatial AND
        dtm_agg.{{ champ_theme }} = af.{{ champ_theme }}

    ORDER BY
        dtm_agg.annee,
        dtm_agg.id_spatial,
        dtm_agg.upper_libelle,
        dtm_agg.level,
        dtm_agg.{{ champ_theme }}

{% endmacro %}
