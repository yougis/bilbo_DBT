{% macro generate_select(list_ordered) %}
    {% for column in list_ordered %}
        {{ column }}
        {% if not loop.last %},{% endif %}
    {% endfor %}
{% endmacro %}
