

SELECT
    annee,
    id_spatial,
    upper_libelle,
    level,
    classe,
    SUM(values) AS sum_values
FROM
    surfor."faits_TMF_annualChangeCollection_h3_nc_6"
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
    classe;