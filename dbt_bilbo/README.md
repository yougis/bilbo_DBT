Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices




Python - Génération des fichiers models DTM FEUX

{% set schema = 'oeil_traitement-feux' %}
{% set table_name = 'faits_zones_brulees_aires_protegees_prov_terre' %}

{% set granu_tempo = 'annee' %}

{{ agreg_annee_type_spatial(schema, table_name, granu_tempo) }}


Python - Génération des fichiers models DTM SURFOR

{% set schema = 'oeil_traitement-processing' %}
{% set table_name = 'faits_GFC_gain_foncier' %}

{% set granu_tempo = 'annee' %}

{{ agreg_annee_level(schema, table_name, granu_tempo) }}