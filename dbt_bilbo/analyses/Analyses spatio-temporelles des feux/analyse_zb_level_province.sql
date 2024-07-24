WITH all_provinces AS (
    SELECT DISTINCT upper_libelle AS province
    FROM carto.dim_spatial
    WHERE level = 'province'
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
province_year_combinations AS (
    SELECT
        c.province,
        yc.annee_A,
        yc.annee_B
    FROM
        all_provinces c
    CROSS JOIN
        year_combinations yc
),
intersected_areas AS (
    SELECT
        a1.annee AS annee_A,
        a2.annee AS annee_B,
        a1.dimension_spatiale AS province,
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
        a1.type_spatial = 'province'
        AND a2.type_spatial = 'province'
)
SELECT
    c.province AS level,
    c.annee_A,
    c.annee_B,
    COALESCE(ROUND(CAST(SUM(ia.intersection_area) / 10000.0 AS numeric), 2), 0.00) AS superficie_ha
FROM
    province_year_combinations c
LEFT JOIN
    intersected_areas ia
ON
    c.province = ia.province
    AND c.annee_A = ia.annee_A
    AND c.annee_B = ia.annee_B
GROUP BY
    c.province, c.annee_A, c.annee_B
ORDER BY
    c.province, c.annee_A, c.annee_B;
