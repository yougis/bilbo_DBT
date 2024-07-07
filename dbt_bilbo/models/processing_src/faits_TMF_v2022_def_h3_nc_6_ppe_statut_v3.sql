with source_data as (
      select * 
      from {{ source('oeil_traitement-processing','faits_TMF_v2022_def_h3_nc_6_ppe_statut_v3') }} 
)

select *
from source_data 
