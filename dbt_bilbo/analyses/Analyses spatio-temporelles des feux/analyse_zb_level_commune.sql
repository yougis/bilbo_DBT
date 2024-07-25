WITH all_communes AS (
    SELECT DISTINCT upper_libelle AS commune
    FROM carto.dim_spatial
    WHERE level = 'commune'
),
all_years AS (
    SELECT DISTINCT annee
    FROM feux.faits_zones_brulees_mos_formation_vegetale_2008
),
year_combinations AS (
    SELECT
        y1.annee AS annee_A,
        y2.annee AS annee_B
    FROM
        all_years y1
    CROSS JOIN
        all_years y2
    WHERE
        y1.annee < y2.annee
),
commune_year_combinations AS (
    SELECT
        c.commune,
        yc.annee_A,
        yc.annee_B
    FROM
        all_communes c
    CROSS JOIN
        year_combinations yc
),
intersected_areas AS (
    SELECT
        a1.annee AS annee_A,
        a2.annee AS annee_B,
        a1.dimension_spatiale AS commune,
        ST_Area(ST_Intersection(a1.geometry, a2.geometry)) AS intersection_area
    FROM
        feux.faits_zones_brulees_mos_formation_vegetale_2008 a1
    JOIN
        feux.faits_zones_brulees_mos_formation_vegetale_2008 a2
    ON
        a1.annee < a2.annee
        AND ST_Intersects(a1.geometry, a2.geometry)
        AND a1.dimension_spatiale = a2.dimension_spatiale
    WHERE
        a1.type_spatial = 'commune'
        AND a2.type_spatial = 'commune'
)
SELECT
    c.annee_A,
    c.annee_B,
    c.commune AS upper_libelle,
    COALESCE(ROUND(CAST(SUM(ia.intersection_area) / 10000.0 AS numeric), 2), 0.00) AS superficie_ha
FROM
    commune_year_combinations c
LEFT JOIN
    intersected_areas ia
ON
    c.commune = ia.commune
    AND c.annee_A = ia.annee_A
    AND c.annee_B = ia.annee_B
GROUP BY
    c.commune, c.annee_A, c.annee_B
ORDER BY
    c.annee_A, c.annee_B, c.commune;
