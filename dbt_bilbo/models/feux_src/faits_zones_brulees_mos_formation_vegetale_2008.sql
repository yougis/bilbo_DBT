{% set schema = 'oeil_traitement-feux' %}
{% set table_name = 'faits_zones_brulees_mos_formation_vegetale_2008' %}

{% set granu_tempo = 'annee' %}

{{ agreg_annee_type_spatial(schema, table_name, granu_tempo) }}

