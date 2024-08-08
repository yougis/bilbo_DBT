{% set schema = 'oeil_traitement-feux' %}
{% set table_name = 'faits_zones_brulees_corridor_moyenne_distance_fs' %}

{{ surface_deja_brulee(schema, table_name) }}
