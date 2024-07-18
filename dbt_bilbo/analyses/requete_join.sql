-- Requête pour joindre une table possédant un champs "id_spatial" avec la table "dim_spatial" 
-- afin d'obtenir la géométrie du polygone

CREATE TABLE dtm_alldim_tmf_v2022_degradation_h3_nc_6_geom AS
SELECT 
    d.geometry,
    t."Annee", 
    t.id_spatial,
    t.upper_libelle,
    t.level,
    t.ha

FROM 
    carto.dim_spatial d

JOIN (
    SELECT 
        "Annee", 
        id_spatial,
        upper_libelle,
        level, 
        ha
    FROM 
        processing."dtm_alldim_tmf_v2022_degradation_h3_nc_6"
    GROUP BY 
        "Annee", 
        id_spatial,
        upper_libelle,
        level, 
        ha
) t
ON 
    d.id_spatial = t.id_spatial

ORDER BY
    t."Annee", 
    t.id_spatial;
