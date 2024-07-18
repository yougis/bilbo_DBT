-- Source de données en entrée
{% set schema = 'oeil_traitement_processing' %}
{% set table_name = 'faits_GFC_lossyear_h3_nc_6_APP' %}

{% set annee = 'annee' %}



-- Nomme la table d'agrégation en sortie selon le nom de la source (utilisation de la macro "name_dtm_agreg")
{{ name_dtm(schema, table_name) }}

-- Récupération des champs de la table (utilisation de la macro "get_columns")
{% set columns = get_columns(schema, table_name) %}

-- Récupération des listes par dimension depuis les variables définies dans "dbt_project"
{% set dim_temporelle = [] %}
{% set dim_spatiale = [] %}
{% set dim_theme = [] %}
{% set dim_mesure = [] %}
{% set dim_technique = [] %}

{% for column in var('list_temporelle') if column in columns %}
    {%- do dim_temporelle.append(column) -%}
{% endfor %}
{% for column in var('list_spatiale') if column in columns %}
    {%- do dim_spatiale.append(column) -%}
{% endfor %}
{% for column in var('list_mesure') if column in columns %}
    {%- do dim_mesure.append(column) -%}
{% endfor %}
{% for column in var('list_technique') if column in columns %}
    {%- do dim_technique.append(column) -%}
{% endfor %}
{% for column in columns %}
    {%- if column not in var('list_temporelle') and column not in var('list_spatiale') and column not in var('list_mesure') and column not in var('list_technique') -%}
        {%- do dim_theme.append(column) -%}
    {%- endif -%}
{% endfor %}

-- Réorganisation de l'ordre des colonnes 
{%- set list_ordered = dim_temporelle + dim_spatiale + dim_theme + dim_mesure -%} 
{%- set list_ordered_avec_technique = dim_temporelle + dim_spatiale + dim_theme + dim_mesure + dim_technique -%}

-- la dimension technique nest pas prises en compte

WITH tb_agg as ( 
    SELECT
        {{ transfo_temporelle(dim_temporelle) }}
        {{ generate_select(dim_spatiale + dim_theme)}} 
        {{ transfo_mesure(columns, dim_mesure) }}

    FROM {{ source(schema, table_name) }}

    GROUP BY
        {{ generate_group_by(list_ordered) }}
    ORDER BY
        {{ generate_order_by(list_ordered) }}

),

all_years AS (
    SELECT DISTINCT year
    FROM  {{ source("oeil_traitement_carto","dim_date") }}
    WHERE year BETWEEN (
        SELECT MIN({{ annee }}) FROM tb_agg
    ) AND (
        SELECT MAX({{ annee }}) FROM tb_agg
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
    JOIN 
        distinct_levels l ON s.level = l.level
),
all_year_level_combinations AS (
    SELECT 
        y.year AS {{ annee }},
        c.level,
        c.upper_libelle,
        c.id_spatial
    FROM 
        all_years y,
        all_combinations c
)

SELECT
    c.{{ annee }},
    c.id_spatial,
    c.upper_libelle,
    c.level,

    {% for attribut in dim_theme + dim_mesure %}
        t.{{attribut}}
    {% if not loop.last %},{% endif %}
    {% endfor %}

    

FROM
    all_year_level_combinations c
LEFT JOIN
    tb_agg t
ON
    t.{{ annee }} = c.{{ annee }} AND 
    t.id_spatial = c.id_spatial
ORDER BY
    c.{{ annee }},
    c.id_spatial
