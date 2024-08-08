{% macro transfo_temporelle(dim_temporelle) %}

    {% for column in dim_temporelle %}

        CASE 
            WHEN CAST({{ column }} AS FLOAT) < 100 THEN CAST((CAST({{ column }} AS FLOAT) + 2000) AS INT)
            ELSE CAST(CAST({{ column }} AS FLOAT) AS INT)
        END AS annee ,
        
    {% endfor %}

{% endmacro %}
