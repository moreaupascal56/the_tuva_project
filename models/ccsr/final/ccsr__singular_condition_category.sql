{{ config(
     enabled = var('ccsr_enabled',var('tuva_marts_enabled',True))
   )
}}

select 
    encounter_id,
    claim_id,
    patient_id,
    ccsr_category,
    ccsr_category_description,
    ccsr_parent_category,
    parent_category_description,
    body_system,
    {{ var('dxccsr_version') }} as dxccsr_version,
    '{{ var('last_update')}}' as last_update
from {{ref('ccsr__long_condition_category')}}
where 
    is_{{ var('record_type', 'ip') }}_default_category = true
    and diagnosis_rank = 1