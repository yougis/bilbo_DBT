{% macro name_dtm(schema, table_name) %}
    {% set source_table_name = table_name.split('_')[1:] | join('_') %}
    {% set alias_prefix = 'dtm_alljoin_' %}
    {% set alias_sufix = '_level_annee' %}
    {% set alias = alias_prefix + source_table_name + alias_sufix %}
    {{ config(materialized='table', alias=alias) }}
{% endmacro %}
