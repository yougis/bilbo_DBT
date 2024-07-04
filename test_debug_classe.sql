{{config(materialized='table')}}

{% set columns_to_select = ['nature', 'proprio_na'] %}
{% set selected_column = null %}

{% for column_name in columns_to_select %}
    {% set columns_in_table = adapter.get_columns_in_table(ref('faits_GFC_lossyear_h3_nc_6_APP')) %}
    {% if column_name in columns_in_table %}
        {% set selected_column = column_name %}
        {% break %}
    {% endif %}
{% endfor %}

SELECT
    id_spatial,
    {% if selected_column == 'nature' %}
        nature AS classe
    {% elif selected_column == 'proprio_na' %}
        proprio_na AS classe
    {% else %}
        NULL AS classe
    {% endif %}
FROM
    {{ source('faits_GFC_lossyear_h3_nc_6_APP') }}
