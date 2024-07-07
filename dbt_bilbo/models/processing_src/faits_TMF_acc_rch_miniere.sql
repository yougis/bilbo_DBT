with source_data as (
      select * 
      from {{ source('oeil_traitement-processing','faits_TMF_acc_rch_miniere') }} 
)

select *
from source_data 
