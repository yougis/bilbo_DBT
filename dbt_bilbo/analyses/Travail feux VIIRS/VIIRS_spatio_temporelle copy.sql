WITH union_polygons AS (
    SELECT
        id_spatial,
        DATE_TRUNC('day', debut) AS date_jour,
        ST_Union(geometry) AS geom_union,
        COUNT(DISTINCT idsurface) AS distinct_idsurface_count
    FROM processing."vue_viirs_snpp_noaa_h3_nc_6_combined"
    WHERE EXTRACT(YEAR FROM debut) = 2020
    GROUP BY
        id_spatial,
        DATE_TRUNC('day', debut)
),
calculated_areas AS (
    SELECT
        id_spatial,
        date_jour,
        ST_Area(geom_union) / 10000 AS superficie_ha,  -- Calcul de la superficie en hectares
        distinct_idsurface_count
    FROM union_polygons
)
SELECT
    id_spatial,
    date_jour,
    SUM(distinct_idsurface_count) AS total_surface_count,
    SUM(superficie_ha) AS total_superficie_ha
FROM calculated_areas
GROUP BY
    id_spatial,
    date_jour
ORDER BY
    id_spatial,
    date_jour;
