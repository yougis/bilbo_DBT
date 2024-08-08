SELECT
    id_spatial,
    dimension_spatiale,
    type_spatial,
    proprio_ty,
    SUM(values) AS sup_total_theme
    
FROM
    contexte."admin_foncier"

GROUP BY
    id_spatial,
    dimension_spatiale,
    type_spatial,
    proprio_ty

ORDER BY
    id_spatial,
    dimension_spatiale,
    type_spatial,
    proprio_ty;