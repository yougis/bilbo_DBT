{% macro agreg_annee_level(schema, table_name, granu_tempo) %}

-- Nomme la table d'agrégation en sortie selon le nom de la source (utilisation de la macro "rename_dtm")
    {{ rename_dtm_annee_level(schema, table_name) }}

-- Récupération des champs de la table (utilisation de la macro "get_columns")
    {% set columns = get_columns(schema, table_name) %}

-- Récupération des listes par dimension depuis les variables définies dans "dbt_project"
    {% set dim_temporelle = [] %}
    {% set dim_spatiale = [] %}
    {% set dim_theme = [] %}
    {% set dim_mesure = [] %}
    {% set dim_technique = [] %}

    {% for column in columns %}
        {% if column.name.lower() in var('list_temporelle') %}
            {%- do dim_temporelle.append(column.name) -%}
        {% endif %}
    {% endfor %}

    {% for column in columns %}
        {% if column.name.lower() in var('list_spatiale') %}
            {%- do dim_spatiale.append(column.name) -%}
        {% endif %}
    {% endfor %}

    {% for column in columns %}
        {% if column.name.lower() in var('list_mesure') %}
            {%- do dim_mesure.append(column.name) -%}
        {% endif %}
    {% endfor %}

    {% for column in columns %}
        {% if column.name.lower() in var('list_technique') %}
            {%- do dim_technique.append(column.name) -%}
        {% endif %}
    {% endfor %}

    {% for column in columns %}
        {%- if column.name.lower() not in var('list_temporelle') and column.name.lower() not in var('list_spatiale') and column.name.lower() not in var('list_mesure') and column.name.lower() not in var('list_technique') -%}
            {%- do dim_theme.append(column.name) -%}
        {%- endif -%}
    {% endfor %}

    {%- set list_select = dim_spatiale + dim_theme -%}
    {%- set list_ordered = dim_temporelle + dim_spatiale + dim_theme + dim_mesure -%}
    {%- set list_ordered_avec_technique = dim_temporelle + dim_spatiale + dim_theme + dim_mesure + dim_technique -%}

    {%- set mcolumn = [] %}

    WITH tb_agg as ( 
        SELECT
            {{ transfo_temporelle(dim_temporelle) }}
            {{ generate_select(list_select)}}
            {{ transfo_mesure(list_ordered_avec_technique, dim_mesure, mcolumn) }}

        FROM
            {{ source(schema, table_name) }}

        GROUP BY
            {{ generate_group_by(list_ordered) }}

        ORDER BY
            {{ generate_order_by(list_ordered) }}
    ),
    all_years AS (
        SELECT DISTINCT year
        FROM  {{ source("oeil_traitement_carto","dim_date") }}
        WHERE year BETWEEN (
            SELECT MIN({{ granu_tempo }}) FROM tb_agg
        ) AND (
            SELECT MAX({{ granu_tempo }}) FROM tb_agg
        )
    ),
    distinct_levels AS (
        SELECT DISTINCT level
        FROM tb_agg
    ),
    all_combinations AS (
        SELECT DISTINCT 
            s.level, 
            s.upper_libelle, 
            s.id_spatial
        FROM 
            {{ source("oeil_traitement_carto","dim_spatial") }} s
        RIGHT JOIN 
            distinct_levels l ON s.level = l.level
    ),
    all_year_level_combinations AS (
        SELECT 
            y.year AS {{ granu_tempo }},
            c.level,
            c.upper_libelle,
            c.id_spatial
        FROM 
            all_years y,
            all_combinations c
    )

    SELECT
        c.{{ granu_tempo }},
        c.id_spatial,
        c.upper_libelle,
        c.level,

        {% for attribut in dim_theme %}
            t.{{attribut}}
        {% if not loop.last %},{% endif %}
        {% endfor %}
        
        {% for column in mcolumn %}
        ,
            t.{{ column }}
        {% endfor %}

    FROM
        all_year_level_combinations c
    LEFT JOIN
        tb_agg t
    ON
        t.{{ granu_tempo }} = c.{{ granu_tempo }} AND 
        t.id_spatial = c.id_spatial
    ORDER BY
        c.{{ granu_tempo }},
        c.id_spatial
    
{% endmacro %}
