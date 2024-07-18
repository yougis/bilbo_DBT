{% macro e4_jointure(schema, table_name) %}

SELECT
    COALESCE(t.annee, c.annee) AS annee,
    c.id_spatial,
    c.upper_libelle,
    c.level,
    t.nature,
    t.milieu,
    t.libelle,
    t.superficie
FROM
    all_year_level_combinations c
LEFT JOIN
    processing."dtm_alldim_GFC_lossyear_h3_nc_6_APP" t
ON
    t.annee = c.annee AND 
    t.level = c.level AND
    t.upper_libelle = c.upper_libelle AND
    t.id_spatial = c.id_spatial
ORDER BY
    annee,
    id_spatial,
    upper_libelle,
    level,
    nature,
    milieu,
    libelle

{% endmacro %}