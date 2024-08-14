{% macro surface_deja_brulee(schema, table_name) %}

    {{ rename_deja_brulee(schema, table_name) }}

    {% set granu_spatiale = 'ZEE' %} -- Choix de la granularité spatiale
    {% set years = [2017, 2018, 2019, 2020, 2021] %} -- Liste des années
    {% set initial_year = years[0] %} -- Première année considérée

    WITH distinct_upper_libelle AS (
        SELECT DISTINCT upper_libelle AS dimension_spatiale
        FROM {{ source("oeil_traitement_carto", "dim_spatial") }}
        WHERE level = '{{ granu_spatiale }}'
    )

    , initial_union AS (
        SELECT
            d.dimension_spatiale,
            f.type_spatial,
            ST_Union(f.geometry) AS union_geom
        FROM
            {{ source(schema, table_name) }} f
        RIGHT JOIN
            distinct_upper_libelle d
        ON
            f.dimension_spatiale = d.dimension_spatiale
            AND f.type_spatial = '{{ granu_spatiale }}'
            AND f.annee = {{ years[0] }}
        GROUP BY
            d.dimension_spatiale, f.type_spatial
    )

    {% for year in years[1:] %}
    , union_up_to_{{ year }} AS (
        SELECT
            d.dimension_spatiale,
            f.type_spatial,
            ST_Union(f.geometry) AS union_geom
        FROM
            {{ source(schema, table_name) }} f
        RIGHT JOIN
            distinct_upper_libelle d
        ON
            f.dimension_spatiale = d.dimension_spatiale
            AND f.type_spatial = '{{ granu_spatiale }}'
            AND f.annee < {{ year }}
        GROUP BY
            d.dimension_spatiale, f.type_spatial
    )

    , intersect_{{ year }} AS (
        SELECT
            d.dimension_spatiale,
            '{{ granu_spatiale }}' AS type_spatial,
            {{ year }} AS annee,
            ST_Intersection(u.union_geom, f.geometry) AS intersection_geometry
        FROM
            union_up_to_{{ year }} u
        JOIN
            {{ source(schema, table_name) }} f
        ON
            f.dimension_spatiale = u.dimension_spatiale
            AND f.type_spatial = '{{ granu_spatiale }}'
            AND f.annee = {{ year }}
            AND ST_Intersects(u.union_geom, f.geometry)
        RIGHT JOIN
            distinct_upper_libelle d
        ON
            f.dimension_spatiale = d.dimension_spatiale
    )
    {% endfor %}

    , all_combinations AS (
        SELECT
            d.dimension_spatiale,
            y.annee
        FROM
            distinct_upper_libelle d
        CROSS JOIN
            (SELECT DISTINCT annee FROM {{ source(schema, table_name) }} WHERE annee IN ({{ years | join(', ') }})) y
    )

    , total_surface_per_year AS (
        SELECT
            annee,
            ROUND(CAST(SUM(ST_Area(geometry)) / 10000.0 AS numeric), 2) AS sup_total_ha
        FROM
            {{ source(schema, table_name) }}
        WHERE
            annee IN ({{ years | join(', ') }})
            AND type_spatial = '{{ granu_spatiale }}'
        GROUP BY
            annee
    )

    SELECT
        CAST({{ initial_year }} AS INTEGER) AS annee_1,
        CAST(c.annee AS INTEGER) AS annee_2,
        '{{ granu_spatiale }}' AS type_spatial,
        c.dimension_spatiale,
        CASE
            WHEN SUM(ST_Area(i.intersection_geometry)) IS NOT NULL
            THEN ROUND(CAST(SUM(ST_Area(i.intersection_geometry)) / 10000.0 AS numeric), 2)
            ELSE NULL
        END AS sup_deja_impact,
        CASE
            WHEN SUM(ST_Area(i.intersection_geometry)) IS NOT NULL AND t.sup_total_ha IS NOT NULL
            THEN ROUND(CAST(t.sup_total_ha - SUM(ST_Area(i.intersection_geometry)) / 10000.0 AS numeric), 2)
            ELSE NULL
        END AS sup_nouvel_impact,
        t.sup_total_ha,
        CASE
            WHEN SUM(ST_Area(i.intersection_geometry)) IS NOT NULL AND t.sup_total_ha IS NOT NULL
            THEN ROUND(CAST((SUM(ST_Area(i.intersection_geometry)) / 10000.0) * 100 / t.sup_total_ha AS numeric), 2)
            ELSE NULL
        END AS ratio_deja_impact,
        CASE
            WHEN SUM(ST_Area(i.intersection_geometry)) IS NOT NULL AND t.sup_total_ha IS NOT NULL
            THEN ROUND(CAST(((t.sup_total_ha - SUM(ST_Area(i.intersection_geometry)) / 10000.0)) * 100 / t.sup_total_ha AS numeric), 2)
            ELSE NULL
        END AS ratio_nouvel_impact
    FROM
        all_combinations c
    LEFT JOIN (
        {% for year in years[1:] %}
        SELECT * FROM intersect_{{ year }}
        {% if not loop.last %} UNION ALL {% endif %}
        {% endfor %}
    ) i
    ON
        c.dimension_spatiale = i.dimension_spatiale
        AND c.annee = i.annee
    LEFT JOIN
        total_surface_per_year t
    ON
        c.annee = t.annee
    WHERE
        c.annee <> {{ initial_year }}  -- Exclure les lignes où annee_1 = annee_2
    GROUP BY
        c.annee, c.dimension_spatiale, t.sup_total_ha
    ORDER BY
        c.annee, c.dimension_spatiale

{% endmacro %}
