-- Requête pour obtenir des statistiques avancées sur les tables (sans thématique / sans dimension contextuelle)

--DROP TABLE IF EXISTS processing.faits_GFC_gain_foncier;

--CREATE TABLE processing.faits_GFC_gain_foncier AS


WITH dtm_alldim AS (
    SELECT 
        annee,
        id_spatial,
        upper_libelle,
        level,
        ROUND(CAST(SUM(ROUND(CAST(ST_Area(geometry) / 10000 AS numeric), 2)) AS numeric), 2) AS ha,
        classe
    FROM 
        processing."faits_GFC_gain_APP"
    GROUP BY 
        annee,
        id_spatial,
        upper_libelle,
        level,
        classe
    ORDER BY
        annee,
        id_spatial,
        level,
        classe
),
etats AS (
    SELECT 
        annee,
        id_spatial,
        upper_libelle,
        level,
        ha,
        classe,
        SUM(ha) OVER (PARTITION BY id_spatial, annee) AS ha_total_spatial,
        ROUND((ha * 1.0 / SUM(ha) OVER (PARTITION BY id_spatial, annee)) * 100.0, 2) AS p100_ha_spatial,
        ha - LAG(ha) OVER (PARTITION BY id_spatial, classe ORDER BY annee) AS diff_annee_prec,
        CASE 
            WHEN ha > LAG(ha) OVER (PARTITION BY id_spatial, classe ORDER BY annee) THEN 'augmentation'
            WHEN ha = LAG(ha) OVER (PARTITION BY id_spatial, classe ORDER BY annee) THEN 'égalité'
            WHEN ha < LAG(ha) OVER (PARTITION BY id_spatial, classe ORDER BY annee) THEN 'diminution'
            ELSE 'N/A' -- Pour la première année où il n'y a pas de valeur précédente
        END AS etat_annee_prec
    FROM 
        dtm_alldim
),
compte_etats AS (
    SELECT 
        id_spatial,
        classe,
        etat_annee_prec,
        COUNT(*) AS compte_etat
    FROM 
        etats
    WHERE 
        etat_annee_prec IN ('augmentation', 'égalité', 'diminution')
    GROUP BY 
        id_spatial, 
        classe, 
        etat_annee_prec
),
sums AS (
    SELECT 
        annee,
        level,
        classe,
        SUM(ha) AS ha_total_annee_level_classe,
        SUM(SUM(ha)) OVER (PARTITION BY annee, level) AS ha_total_annee_level
    FROM 
        etats
    GROUP BY 
        annee, 
        level, 
        classe
)
SELECT 
    e.annee,
    e.id_spatial,
    e.upper_libelle,
    e.level,
    e.classe,
    e.ha,
    e.ha_total_spatial,
    e.p100_ha_spatial,
    DENSE_RANK() OVER (PARTITION BY e.annee, e.level, e.classe ORDER BY e.ha DESC) AS classement,
    DENSE_RANK() OVER (PARTITION BY e.annee, e.level ORDER BY e.ha_total_spatial DESC) AS classement_sans_classe,
    e.diff_annee_prec,
    e.etat_annee_prec,
    c.compte_etat,
    s.ha_total_annee_level_classe,
    ROUND((e.ha * 100.0 / NULLIF(s.ha_total_annee_level_classe, 0)), 2) AS p100_ha_total_annee_level_classe,
    s.ha_total_annee_level,
    ROUND((e.ha_total_spatial * 100.0 / NULLIF(s.ha_total_annee_level, 0)), 2) AS p100_ha_total_annee_level
FROM 
    etats e
LEFT JOIN 
    compte_etats c
ON 
    e.id_spatial = c.id_spatial AND 
    e.classe = c.classe AND 
    e.etat_annee_prec = c.etat_annee_prec
LEFT JOIN 
    sums s
ON 
    e.annee = s.annee AND 
    e.level = s.level AND 
    e.classe = s.classe
ORDER BY 
    e.annee, 
    e.id_spatial,
    e.classe;
