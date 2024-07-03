-- Création d'une vue matérialisée qui groupe les valeurs selon l'année, l'id_spatial, 
-- le libellé et la classe.

CREATE MATERIALIZED VIEW surfor.mvue_TMF_acc_aveclibelle AS

SELECT 
    annee, 
    id_spatial, 
    SUM(values) AS sum_values,
    classe
FROM 
    surfor."faits_TMF_annualChangeCollection_h3_nc_6"
GROUP BY 
    annee, 
    id_spatial,
    libelle,
    classe
ORDER BY
    annee, 
    id_spatial,
    libelle,
    classe;