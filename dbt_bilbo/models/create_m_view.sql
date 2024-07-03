{% macro create_m_view(view_name) %}

{% set sql %}
SELECT 
  annee, 
  id_spatial, 
  SUM(values) AS sum_values 
FROM 
  {{ view_name }}
GROUP BY 
  annee, id_spatial
{% endset %}

{{ log(sql, info=True) }}  -- Ajoute cette ligne pour loguer la requête SQL générée

{{ return(sql) }}

{% endmacro %}
