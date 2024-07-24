{% set schema = 'oeil_traitement-processing' %}
{% set table_name = 'faits_TMF_v2022_deg_h3_nc_6_unesco_terre' %}

{% set granu_tempo = 'annee' %}

{{ agreg_annee_level(schema, table_name, granu_tempo) }}

