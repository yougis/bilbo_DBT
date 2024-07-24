{% set schema = 'oeil_traitement-processing' %}
{% set table_name = 'faits_TMF_acc_rch_miniere' %}

{% set granu_tempo = 'annee' %}

{{ agreg_annee_level(schema, table_name, granu_tempo) }}

