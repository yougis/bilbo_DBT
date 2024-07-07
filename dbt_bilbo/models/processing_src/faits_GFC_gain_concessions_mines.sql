with source_data as (
      select * 
      from {{ source('oeil_traitement-processing','faits_GFC_gain_concessions_mines') }} 
)

select *
from source_data 
