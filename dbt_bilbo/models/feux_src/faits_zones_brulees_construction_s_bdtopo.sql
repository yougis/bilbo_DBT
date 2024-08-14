{% set schema = 'oeil_traitement-feux' %}
{% set table_name = 'faits_zones_brulees_construction_s_bdtopo' %}

{{ surface_deja_brulee(schema, table_name)}}
