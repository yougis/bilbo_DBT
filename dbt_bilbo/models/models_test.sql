{% set schema = 'surfor' %}
{% set table_name = 'faits_TMF_annualChangeCollection_h3_nc_6' %}

{{ macros_test(schema, table_name) }}

SELECT
    annee,
    id_spatial,
    upper_libelle,
    level,
    classe,
    SUM(values) AS sum_values
FROM
    {{ source(schema, table_name) }}
GROUP BY
    annee,
    id_spatial,
    upper_libelle,
    level,
    classe
ORDER BY
    annee,
    id_spatial,
    upper_libelle,
    level,
    classe