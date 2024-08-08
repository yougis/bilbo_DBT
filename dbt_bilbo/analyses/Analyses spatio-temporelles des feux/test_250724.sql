-- Créer un index spatial sur la colonne geometry de la table feux.faits_zones_brulees_mos_veg_2008_test
CREATE INDEX IF NOT EXISTS idx_geometry_spatia ON feux.faits_zones_brulees_microendemisme_index USING GIST (geometry);

-- Requête optimisée avec utilisation de l'index spatial
WITH union_2017_2018 AS (
    SELECT
        ST_Union(geometry) AS union_geom
    FROM
        feux.faits_zones_brulees_microendemisme_index
    WHERE
        (annee = 2017 AND type_spatial = 'province')
        OR (annee = 2018 AND type_spatial = 'province')
),

intersect_2019 AS (
    SELECT
        ST_Intersection(u.union_geom, f.geometry) AS intersection_geometry
    FROM
        union_2017_2018 u
    JOIN
        feux.faits_zones_brulees_microendemisme_index f
    ON
        f.annee = 2019
        AND f.type_spatial = 'province'
        AND ST_Intersects(u.union_geom, f.geometry) -- Utilisation de l'index spatial
)
SELECT
    ROUND(CAST(SUM(ST_Area(intersection_geometry)) / 10000.0 AS numeric), 2) AS superficie_ha
FROM
    intersect_2019
WHERE
    ST_GeometryType(intersection_geometry) IN ('ST_Polygon', 'ST_MultiPolygon');
