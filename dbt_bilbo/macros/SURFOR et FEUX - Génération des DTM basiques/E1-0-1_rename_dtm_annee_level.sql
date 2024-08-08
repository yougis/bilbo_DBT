{% macro rename_dtm_annee_level(schema, table_name) %}

    {% set source_table_name = table_name.split('_')[1:] | join('_') %}
    {% set alias_prefix = 'dtm_' %}
    {% set alias_sufix = '_annee_level' %}
    {% set alias = alias_prefix + source_table_name + alias_sufix %}
    {{ config(materialized='table', alias=alias) }}
    
{% endmacro %}

