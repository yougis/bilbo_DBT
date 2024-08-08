WITH tb_agg as ( 
    SELECT
        annee,
        id_spatial,
        upper_libelle,
        level,

    FROM
         processing.
    ),

all_years AS (
    SELECT DISTINCT year
    FROM  {{ source("oeil_traitement_carto","dim_date") }}
    WHERE year BETWEEN (
        SELECT MIN(annee) FROM tb_agg
    ) AND (
        SELECT MAX(annee) FROM tb_agg
    )
),

distinct_levels AS (
    SELECT DISTINCT level
    FROM tb_agg
),

all_combinations AS (
    SELECT DISTINCT 
        s.level, 
        s.upper_libelle, 
        s.id_spatial
    FROM 
            {{ source("oeil_traitement_carto","dim_spatial") }} s
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

SELECT
    c.annee,
    c.id_spatial,
    c.upper_libelle,
    c.level,
    c.

FROM
    all_year_level_combinations c
    
LEFT JOIN
    tb_agg t

ON
    t.annee = c.annee AND 
    t.id_spatial = c.id_spatial

ORDER BY
    c.annee,
    c.id_spatial;