-- Requête pour joindre une table possédant un champs "id_spatial" avec la table "dim_spatial" 
-- afin d'obtenir la géométrie du polygone

SELECT 
    d.geometry,
    t."Annee", 
    t.id_spatial, 
    t.sum_values

FROM 
    carto.dim_spatial d

JOIN (
    SELECT 
        "Annee", 
        id_spatial, 
        SUM(values) AS sum_values
    FROM 
        processing."faits_GFC_lossyear_h3_nc_6"
    GROUP BY 
        "Annee", 
        id_spatial
) t
ON 
    d.id_spatial = t.id_spatial

WHERE
    t.id_spatial = '1'

ORDER BY
    t."Annee", 
    t.id_spatial;
