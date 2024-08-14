{% macro indic_sanstheme(theme) %}

    SELECT
        dtm.annee,
        dtm.id_spatial,
        dtm.upper_libelle,
        ROUND(CAST(ds.superficie_ha AS NUMERIC), 2) AS sup_total_id_spatial,
        dtm.level,
        dtm.superficie_ha,
        ROUND(CAST(dtm.superficie_ha AS NUMERIC) * 100.0 / NULLIF(CAST(ds.superficie_ha AS NUMERIC), 0), 2) AS indicateur_1,
        SUM(CAST(dtm.superficie_ha AS NUMERIC)) OVER (PARTITION BY dtm.annee, dtm.level) AS sum_level,
        ROUND(CAST(dtm.superficie_ha AS NUMERIC) * 100.0 / NULLIF(SUM(CAST(dtm.superficie_ha AS NUMERIC)) OVER (PARTITION BY dtm.annee, dtm.level), 0), 2) AS indicateur_2,
        dtm.nb_indic,
        ROUND(CAST(dtm.nb_indic AS NUMERIC) * 100.0 / NULLIF(SUM(CAST(dtm.nb_indic AS NUMERIC)) OVER (PARTITION BY dtm.annee, dtm.level), 0), 2) AS indicateur_5

    FROM
        {{ source("oeil_traitement_processing", "dtm_zones_brulees_" ~ theme ~ "_annee_level") }} AS dtm

    LEFT JOIN
        {{ source("oeil_traitement_processing","dim_spatial_superficie") }} AS ds
    ON
        dtm.id_spatial = ds.id_spatial

    ORDER BY
        dtm.annee,
        dtm.id_spatial,
        dtm.upper_libelle,
        dtm.level

{% endmacro %}
    

