-- Requête pour obtenir des statistiques avancées sur les tables (sans thématique / sans dimension contextuelle)

--DROP TABLE IF EXISTS processing.faits_GFC_gain_foncier;

--CREATE TABLE processing.faits_GFC_gain_foncier AS


WITH dtm_alldim AS (
    SELECT 
        CASE
            WHEN ROUND(CAST(f.annee AS numeric)) < 100 THEN ROUND(CAST(f.annee AS numeric)) + 2000
            ELSE ROUND(CAST(f.annee AS numeric))
        END AS annee,
        f.id_spatial,
        f.upper_libelle,
        f.level,
        f.upper_libelle AS libelle, -- Correction: assuming 'libelle' maps to 'upper_libelle' in the first query
        f.nature,
        SUM(ROUND(CAST(ST_Area(geometry) / 10000 AS numeric), 2)) AS ha
    FROM 
        processing."faits_GFC_lossyear_h3_nc_6_APP" f 
    GROUP BY 
        CASE
            WHEN ROUND(CAST(f.annee AS numeric)) < 100 THEN ROUND(CAST(f.annee AS numeric)) + 2000
            ELSE ROUND(CAST(f.annee AS numeric))
        END,
        f.id_spatial,
        f.upper_libelle,
        f.level,
        f.nature
),
etats AS (
    SELECT 
        annee,
        id_spatial,
        upper_libelle,
        level,
        ha,
        nature,
        SUM(ha) OVER (PARTITION BY id_spatial, annee) AS ha_total_spatial,
        ROUND((ha * 1.0 / NULLIF(SUM(ha) OVER (PARTITION BY id_spatial, annee), 0)) * 100.0, 2) AS p100_ha_spatial,
        ha - LAG(ha) OVER (PARTITION BY id_spatial, nature ORDER BY annee) AS diff_annee_prec,
        CASE 
            WHEN ha > LAG(ha) OVER (PARTITION BY id_spatial, nature ORDER BY annee) THEN 'augmentation'
            WHEN ha = LAG(ha) OVER (PARTITION BY id_spatial, nature ORDER BY annee) THEN 'égalité'
            WHEN ha < LAG(ha) OVER (PARTITION BY id_spatial, nature ORDER BY annee) THEN 'diminution'
            ELSE 'N/A'
        END AS etat_annee_prec
    FROM 
        dtm_alldim
),
compte_etats AS (
    SELECT 
        id_spatial,
        nature,
        etat_annee_prec,
        COUNT(*) AS compte_etat
    FROM 
        etats
    WHERE 
        etat_annee_prec IN ('augmentation', 'égalité', 'diminution')
    GROUP BY 
        id_spatial, 
        nature, 
        etat_annee_prec
),
sums AS (
    SELECT 
        annee,
        level,
        nature,
        SUM(ha) AS ha_total_annee_level_nature,
        SUM(SUM(ha)) OVER (PARTITION BY annee, level) AS ha_total_annee_level
    FROM 
        etats
    GROUP BY 
        annee, 
        level, 
        nature
)
SELECT 
    e.annee,
    e.id_spatial,
    e.upper_libelle,
    e.level,
    e.nature,
    e.ha,
    e.ha_total_spatial,
    e.p100_ha_spatial,
    DENSE_RANK() OVER (PARTITION BY e.annee, e.level, e.nature ORDER BY e.ha DESC) AS classement,
    DENSE_RANK() OVER (PARTITION BY e.annee, e.level ORDER BY e.ha_total_spatial DESC) AS classement_sans_nature,
    e.diff_annee_prec,
    e.etat_annee_prec,
    c.compte_etat,
    s.ha_total_annee_level_nature,
    ROUND((e.ha * 100.0 / NULLIF(s.ha_total_annee_level_nature, 0)), 2) AS p100_ha_total_annee_level_nature,
    s.ha_total_annee_level,
    ROUND((e.ha_total_spatial * 100.0 / NULLIF(s.ha_total_annee_level, 0)), 2) AS p100_ha_total_annee_level
FROM 
    etats e
LEFT JOIN 
    compte_etats c
    ON e.id_spatial = c.id_spatial 
    AND e.nature = c.nature 
    AND e.etat_annee_prec = c.etat_annee_prec
LEFT JOIN 
    sums s
    ON e.annee = s.annee 
    AND e.level = s.level 
    AND e.nature = s.nature
ORDER BY 
    e.annee, 
    e.id_spatial,
    e.nature;
