
{% import "macros/macro_dtm_alldim_avec_classe.sql" as macros %}

{% set schema = 'processing' %}
{% set table_name = 'faits_TMF_acc_v12022_h3_nc_6' %}

{{ macros.macro_dtm_alldim_avec_classe(schema, table_name) }}
