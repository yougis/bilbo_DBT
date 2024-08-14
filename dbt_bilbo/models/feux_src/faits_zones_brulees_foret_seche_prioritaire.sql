{% set schema = 'oeil_traitement-feux' %}
{% set table_name = 'faits_zones_brulees_foret_seche_prioritaire' %}

{{ surface_deja_brulee(schema, table_name)}}
