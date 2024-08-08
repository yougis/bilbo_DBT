-- Requête pour générer une table possédant l'ensemble des dimensions ("alldim") à partir d'une table de faits

DROP TABLE IF EXISTS processing.dtm_alldim_TMF_v2022_degradation_h3_nc_6;

CREATE TABLE processing.dtm_alldim_TMF_v2022_degradation_h3_nc_6 AS

SELECT 
    "Annee",
    id_spatial,
    upper_libelle,
    level,
    ROUND(CAST(SUM(values) AS numeric), 2) AS ha

FROM 
    processing."faits_TMF_v2022_degradation_h3_nc_6"

GROUP BY 
    "Annee",
    id_spatial,
    upper_libelle,
    level

ORDER BY
    "Annee",
    id_spatial,
    upper_libelle,
    level;