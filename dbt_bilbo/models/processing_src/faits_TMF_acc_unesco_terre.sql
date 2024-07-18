with source_data as (
      select * 
      from {{ source('oeil_traitement-processing','faits_TMF_acc_unesco_terre') }} 
)

select *
from source_data 
