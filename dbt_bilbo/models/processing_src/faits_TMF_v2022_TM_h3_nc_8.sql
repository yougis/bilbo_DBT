with source_data as (
      select * 
      from {{ source('oeil_traitement-processing','faits_TMF_v2022_TM_h3_nc_8') }} 
)

select *
from source_data 
