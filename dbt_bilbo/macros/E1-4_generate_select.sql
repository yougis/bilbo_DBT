{% macro generate_select(list_select) %}

    {% for column in list_select %}
        {{ column }}
        {% if not loop.last %},{% endif %}
    {% endfor %}
    
{% endmacro %}
