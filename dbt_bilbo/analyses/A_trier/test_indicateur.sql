SELECT
    dtm.annee,
    dtm.id_spatial,
    dtm.upper_libelle,
    ds.superficie_ha AS sup_id_spatial_ha, -- Superficie de l'id_spatial
    dtm.level,
    dtm.proprio_na,
    dtm.superficie_ha AS sup_brulee_ha, -- Superficie des zones brûlées
    ROUND((dtm.superficie_ha * 1.0 / ds.superficie_ha) * 100.0, 2) AS p100_brulee_classe, -- % de l'id_spatial qui est brûlé
    ROUND((dtm.superficie_ha * 1.0 / SUM(ds.superficie_ha) OVER (PARTITION BY dtm.level, dtm.annee)) * 100.0, 2) AS p100_brulee_id_spatial,
    
    SUM(dtm.superficie_ha) OVER (PARTITION BY dtm.level, dtm.annee) AS sup_totale_brulee_level, -- Somme des zones brûlées par level
    ROUND((dtm.superficie_ha * 1.0 / SUM(dtm.superficie_ha) OVER (PARTITION BY dtm.level, dtm.annee)) * 100.0, 2) AS p100_brulee_level, -- %
    
    SUM(dtm.superficie_ha) OVER (PARTITION BY dtm.level, dtm.annee, dtm.proprio_na) AS sup_tot_brulee_level_classe, -- Somme des zones brûlées par level et classe
    ROUND((dtm.superficie_ha * 1.0 / SUM(dtm.superficie_ha) OVER (PARTITION BY dtm.level, dtm.annee, dtm.proprio_na)) * 100.0, 2) AS p100_brulee_level_classe -- %
FROM
    processing."dtm_TMF_acc_h3_nc_6_foncier_annee_level" AS dtm
LEFT JOIN
    processing."dim_spatial_superficie" AS ds
ON
    dtm.id_spatial = ds.id_spatial
ORDER BY
    dtm.annee,
    dtm.level,
    dtm.id_spatial,
    dtm.upper_libelle,
    dtm.proprio_na;
