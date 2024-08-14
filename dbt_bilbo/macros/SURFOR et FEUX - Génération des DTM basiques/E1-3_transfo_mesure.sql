{% macro transfo_mesure(list_ordered_avec_technique, dim_mesure, mcolumn) %}

    {%- for column in list_ordered_avec_technique -%}

        {%- if column in dim_mesure -%}

            SUM(ROUND(CAST({{ column }} AS numeric), 2)) AS {{ column }}_sum,
            AVG(ROUND(CAST({{ column }} AS numeric), 2)) AS {{ column }}_avg,

           {% do mcolumn.append( column + '_sum' ) %}
           {% do mcolumn.append( column + '_avg' ) %}

        {%- endif %}

        {%- if 'geometry' in column -%}
            SUM(
                CASE
                    WHEN ST_GeometryType({{ column }}) = 'ST_Polygon' OR ST_GeometryType({{ column }}) = 'ST_MultiPolygon' THEN
                        ROUND(CAST(ST_Area({{ column }}) / 10000 AS numeric), 2)
                    ELSE NULL
                END
            ) AS superficie_ha
            {% do mcolumn.append( 'superficie_ha' ) %}

        {%- endif %}
    
    {%- endfor %}

{% endmacro %}
