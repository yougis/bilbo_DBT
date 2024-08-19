SELECT
    2020 AS annee,
    id_spatial,
    upper_libelle,
    level,
    SUM(surface_count) AS total_surface_count,
    SUM(values) AS superficie_ha

FROM (
    SELECT
        id_spatial,
        upper_libelle,
        level,
        COUNT(DISTINCT idsurface) AS surface_count,
        values
    FROM processing."vue_viirs_snpp_noaa_h3_nc_6_combined"
    WHERE EXTRACT(YEAR FROM debut) = 2020
    GROUP BY
        id_spatial,
        upper_libelle,
        level,
        values
) AS subquery

GROUP BY
    id_spatial,
    upper_libelle,
    level

ORDER BY
    id_spatial,
    upper_libelle,
    level;
