with source_data as (
      select * 
      from {{ source('oeil_traitement-processing','faits_TMF_v2022_degradation_h3_nc_6_unesco_terre') }} 
)

select *
from source_data 
