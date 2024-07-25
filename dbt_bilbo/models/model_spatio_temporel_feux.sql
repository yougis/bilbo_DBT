-- CREATE TABLE public.test_zb_geometry AS

WITH intersected_areas AS (
    SELECT
        a1.annee AS annee_A,
        a2.annee AS annee_B,
        ST_CollectionExtract(ST_Intersection(a1.geometry, a2.geometry), 3) AS intersection_geometry,
        ST_Area(ST_CollectionExtract(ST_Intersection(a1.geometry, a2.geometry), 3)) AS intersection_area
    FROM
        feux.faits_zones_brulees_mos_formation_vegetale_2008 a1
    JOIN
        feux.faits_zones_brulees_mos_formation_vegetale_2008 a2
    ON
        a1.annee < a2.annee
        AND ST_Intersects(a1.geometry, a2.geometry)
    WHERE
        a1.type_spatial = 'province'
        AND a2.type_spatial = 'province'
)
SELECT
    annee_A,
    annee_B,
    'NOUVELLE-CALEDONIE' AS upper_libelle,
    ROUND(CAST(SUM(intersection_area) / 10000.0 AS numeric), 2) AS superficie_ha,
    ST_Union(intersection_geometry) AS intersection_geometry
FROM
    intersected_areas
WHERE
    ST_GeometryType(intersection_geometry) IN ('ST_Polygon', 'ST_MultiPolygon')
GROUP BY
    annee_A, annee_B
ORDER BY
    annee_A, annee_B;