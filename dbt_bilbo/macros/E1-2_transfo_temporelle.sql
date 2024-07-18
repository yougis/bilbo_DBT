{% macro transfo_temporelle(dim_temporelle) %}

    {% for column in dim_temporelle %}
        CASE 
            WHEN {{ column }}::FLOAT < 100 THEN ({{ column }}::FLOAT + 2000)::INTEGER
            ELSE {{ column }}::INTEGER
        END AS {{ column }},
    {% endfor %}

{% endmacro %}
