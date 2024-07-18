with source_data as (
      select * 
      from {{ source('oeil_traitement-processing','faits_TMF_acc_ppe_statut_v3') }} 
)

select *
from source_data 
