with source_data as (
      select * 
      from {{ source('oeil_traitement-processing','faits_TMF_acc_v12022_h3_nc_6') }} 
)

select *
from source_data 
