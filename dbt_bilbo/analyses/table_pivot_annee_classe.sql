SELECT 
  id_spatial,
  SUM(values) FILTER (WHERE annee = 1990 AND classe = '1') AS "1990_c1",
  SUM(values) FILTER (WHERE annee = 1990 AND classe = '2') AS "1990_c2",
  SUM(values) FILTER (WHERE annee = 1990 AND classe = '3') AS "1990_c3",
  SUM(values) FILTER (WHERE annee = 1990 AND classe = '4') AS "1990_c4",
  SUM(values) FILTER (WHERE annee = 1991 AND classe = '1') AS "1991_c1",
  SUM(values) FILTER (WHERE annee = 1991 AND classe = '2') AS "1991_c2",
  SUM(values) FILTER (WHERE annee = 1991 AND classe = '3') AS "1991_c3",
  SUM(values) FILTER (WHERE annee = 1991 AND classe = '4') AS "1991_c4",
  SUM(values) FILTER (WHERE annee = 1992 AND classe = '1') AS "1992_c1",
  SUM(values) FILTER (WHERE annee = 1992 AND classe = '2') AS "1992_c2",
  SUM(values) FILTER (WHERE annee = 1992 AND classe = '3') AS "1992_c3",
  SUM(values) FILTER (WHERE annee = 1992 AND classe = '4') AS "1992_c4"
FROM 
  surfor."faits_TMF_annualChangeCollection_h3_nc_6"
GROUP BY 
  id_spatial
ORDER BY 
  id_spatial;
