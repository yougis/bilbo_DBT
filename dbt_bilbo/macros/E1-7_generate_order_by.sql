{% macro generate_order_by(list_ordered, dim_mesure) %}

    {% for column in list_ordered %}
        {% if column not in dim_mesure %}
            {{ column }}
            {% if not loop.last %},{% endif %}
        {% endif %}
    {% endfor %}
    
{% endmacro %}
