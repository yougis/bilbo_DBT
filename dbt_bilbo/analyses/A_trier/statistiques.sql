-- Calculer la somme dans une sous-requête
WITH summed_values AS (
    SELECT 
        annee,
        id_spatial,
        upper_libelle,
        SUM(values) AS total_values,
	classe
    FROM 
        processing."faits_TMF_acc_v12022_h3_nc_6"
    GROUP BY 
        annee,
        id_spatial,
        upper_libelle,
	classe
)

-- Prendre la moyenne de ces sommes dans la requête principale
SELECT 
    id_spatial,
    upper_libelle,
    ROUND(CAST(AVG(total_values) AS numeric), 2) AS ha_moy,
    classe
FROM 
    summed_values
GROUP BY 
    id_spatial,
    upper_libelle,
    classe
ORDER BY
    id_spatial,
    classe;