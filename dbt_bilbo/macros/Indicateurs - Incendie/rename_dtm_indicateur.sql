{% macro rename_dtm_indicateur(theme) %}

    {% set alias = 'dtm_indicateur_zones_brulees_' ~ theme %}
    
    {{ config(materialized='table', alias=alias) }}
    
{% endmacro %}