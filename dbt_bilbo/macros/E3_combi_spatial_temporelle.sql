{% macro e3_combi_spatial_temporelle(schema, table_name) %}

    WITH 
    all_years AS (
        SELECT DISTINCT year
        FROM carto."dim_date"
        WHERE year BETWEEN (
            SELECT MIN(annee) FROM processing."dtm_alldim_GFC_lossyear_h3_nc_6_APP"
        ) AND (
            SELECT MAX(annee) FROM processing."dtm_alldim_GFC_lossyear_h3_nc_6_APP"
        )
    ),
    distinct_levels AS (
        SELECT DISTINCT level
        FROM processing."dtm_alldim_GFC_lossyear_h3_nc_6_APP"
    ),
    all_combinations AS (
        SELECT DISTINCT 
            s.level, 
            s.upper_libelle, 
            s.id_spatial
        FROM 
            carto."dim_spatial" s
        JOIN 
            distinct_levels l ON s.level = l.level
    ),
    all_year_level_combinations AS (
        SELECT 
            y.year AS annee,
            c.level,
            c.upper_libelle,
            c.id_spatial
        FROM 
            all_years y,
            all_combinations c
    )

{% endmacro %}