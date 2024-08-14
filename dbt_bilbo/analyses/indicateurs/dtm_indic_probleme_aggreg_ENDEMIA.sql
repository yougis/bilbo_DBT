SELECT
    upper_libelle,
    categoriee,
    SUM(DISTINCT nb_theme) AS nb_theme,
    SUM(nb_theme_indic) AS nb_theme_indic,
    SUM(nb_indic) AS nb_indic,
    SUM(superficie_ha) AS superficie_ha

FROM processing. dtm_indic_zb_perimetre_especes_endemia_spe_categorie

WHERE annee = '2020' AND level = 'province'

GROUP BY upper_libelle, categoriee;