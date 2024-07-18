{% macro get_columns(schema, table_name) %}

    {%- set columns = adapter.get_columns_in_relation(source(schema, table_name)) -%}
    {%- set columns = columns | map(attribute='name') | map('lower') | list -%}
    {{ return(columns) }}
    
{% endmacro %}
