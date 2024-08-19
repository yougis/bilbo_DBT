CREATE VIEW processing.vue_viirs_snpp_noaa_h3_nc_6_combined AS
SELECT *
FROM processing."faits_viirs_snpp_noaa_h3_nc_6"
UNION ALL
SELECT *
FROM processing."faits_viirs_snpp_noaa_h3_nc_6_withError";
