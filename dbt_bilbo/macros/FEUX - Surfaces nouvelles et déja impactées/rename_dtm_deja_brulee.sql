{% macro rename_deja_brulee(schema, table_name) %}

    {% set source_table_name = table_name.split('_')[1:] | join('_') %}
    {% set alias_prefix = 'dtm_deja_' %}
    {% set alias = alias_prefix + source_table_name %}
    {{ config(materialized='table', alias=alias) }}
    
{% endmacro %}
