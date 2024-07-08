-- Fichier: macros/macro_dtm_alldim_avec_classe.sql

{% macro macro_dtm_alldim_avec_classe(schema, table_name) %}

{% set schema = 'processing' %}
{% set table_name = 'faits_TMF_acc_v12022_h3_nc_6' %}

{% set source_table_name = table_name.split('_')[1:] | join('_') %}
{% set alias_prefix = 'dtm_alldim_' %}
{% set alias = alias_prefix + source_table_name %}
{{ config(materialized='table', alias=alias) }}


SELECT
    annee,
    id_spatial,
    upper_libelle,
    level,
    classe,
    SUM(values) AS sum_values
FROM
    {{ source(schema, table_name) }}
GROUP BY
    annee,
    id_spatial,
    upper_libelle,
    level,
    classe
ORDER BY
    annee,
    id_spatial,
    upper_libelle,
    level,
    classe

{% endmacro %}