{% macro rename_dtm_indic_theme_spe(theme) %}

    {% set alias = 'dtm_indic_zb_' ~ theme ~ '_spe' %}
    
    {{ config(materialized='table', alias=alias) }}
    
{% endmacro %}