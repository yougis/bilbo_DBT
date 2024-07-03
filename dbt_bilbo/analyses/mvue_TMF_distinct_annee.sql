-- Création d'une MVUE pour connaître les différentes années dans une table de données

CREATE MATERIALIZED VIEW surfor.mvue_TMF_distinct_annee AS

SELECT DISTINCT annee
FROM surfor."faits_TMF_annualChangeCollection_h3_nc_6"
ORDER BY annee;
