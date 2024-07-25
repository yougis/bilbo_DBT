WITH union_2017_2018 AS (
    SELECT
        ST_Union(geometry) AS union_geom
    FROM
        feux.faits_zones_brulees_mos_formation_vegetale_2008
    WHERE
        annee IN (2017, 2018) AND type_spatial = 'province'
),
intersect_2019 AS (
    SELECT
        ST_Intersection(u.union_geom, f.geometry) AS intersection_geometry
    FROM
        union_2017_2018 u
    JOIN
        feux.faits_zones_brulees_mos_formation_vegetale_2008 f
    ON
        f.annee = 2019 AND f.type_spatial = 'province'
)
SELECT
    ROUND(CAST(SUM(ST_Area(intersection_geometry)) / 10000.0 AS numeric), 2) AS superficie_ha
FROM
    intersect_2019
WHERE
    ST_GeometryType(intersection_geometry) IN ('ST_Polygon', 'ST_MultiPolygon');

