{% macro rename_dtm_indic_theme_global(theme) %}

    {% set alias = 'dtm_indic_zb_' ~ theme ~ '_global' %}
    
    {{ config(materialized='table', alias=alias) }}
    
{% endmacro %}