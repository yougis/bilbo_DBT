WITH union_geometries AS (
  SELECT
    MIN(annee) OVER () AS annee_A,
    annee AS annee_B,
    ST_Union(geometry) OVER (ORDER BY annee ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS union_geom
  FROM feux.faits_zones_brulees_mos_formation_vegetale_2008
),
intersected_geometries AS (
  SELECT
    ug.annee_A,
    ug.annee_B,
    ST_Area(ST_Intersection(t.geometry, ug.union_geom)) AS intersection_area
  FROM feux.faits_zones_brulees_mos_formation_vegetale_2008 t
  JOIN union_geometries ug
  ON t.annee = ug.annee_B
  WHERE ug.union_geom IS NOT NULL
)
SELECT
  annee_A,
  annee_B,
  SUM(intersection_area) AS superficie
FROM intersected_geometries
GROUP BY annee_A, annee_B
ORDER BY annee_B;

