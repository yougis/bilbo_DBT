with source_data as (
      select * 
      from {{ source('oeil_traitement-processing','faits_TMF_acc_APP') }} 
)

select *
from source_data 
