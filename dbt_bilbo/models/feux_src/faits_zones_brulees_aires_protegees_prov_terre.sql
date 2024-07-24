{% set schema = 'oeil_traitement-feux' %}
{% set table_name = 'faits_zones_brulees_aires_protegees_prov_terre' %}

{% set granu_tempo = 'annee' %}

{{ agreg_annee_type_spatial(schema, table_name, granu_tempo) }}

