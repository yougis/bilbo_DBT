{% set schema = 'oeil_traitement-processing' %}
{% set table_name = 'faits_GFC_gain_ppe_statut_v3' %}

{% set granu_tempo = 'annee' %}

{{ agreg_annee_level(schema, table_name, granu_tempo) }}

