{% set schema = 'oeil_traitement-feux' %}
{% set table_name = 'faits_zones_brulees_perimetres_protection_eau' %}

{{ surface_deja_brulee(schema, table_name) }}
