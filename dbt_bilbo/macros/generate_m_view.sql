{{ config(materialized='table') }}

{% for table_name in var('table_list') %}

  {% set full_table_name = 'surfor.' ~ table_name %}
  {% set sql = create_m_view(full_table_name) %}
  {{ run_query(sql) }}

{% endfor %}
