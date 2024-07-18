{% macro transfo_mesure(columns, dim_mesure) %}

    {% for column in dim_mesure %}

        ,SUM(ROUND({{ column }}, 2)) AS {{ column }}_sum
        ,AVG(ROUND({{ column }}, 2)) AS {{ column }}_avg

    {% endfor %}
    
    {% if 'geometry' in columns %}

        ,SUM(
            CASE
                WHEN ST_GeometryType(geometry) = 'ST_Polygon' OR ST_GeometryType(geometry) = 'ST_MultiPolygon' THEN
                    ROUND(CAST(ST_Area(geometry) / 10000 AS numeric), 2)
                ELSE NULL
            END
        ) AS superficie_ha
    
        {%- do dim_mesure.append("superficie_ha") -%}

    {% endif %}
    
{% endmacro %}

