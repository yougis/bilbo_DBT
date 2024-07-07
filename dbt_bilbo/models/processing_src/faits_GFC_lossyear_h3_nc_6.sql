with source_data as (
      select * 
      from {{ source('oeil_traitement-processing','faits_GFC_lossyear_h3_nc_6') }} 
)

select *
from source_data 
