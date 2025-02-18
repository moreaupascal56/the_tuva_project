{{ config(
     enabled = var('claims_date_profiling_enabled',var('tuva_marts_enabled',True))
   )
}}

select
  'claim_start_date > claim_end_date' as test_description
, count(distinct claim_id) as claim_count
, '{{ var('last_update')}}' as last_update
from {{ ref('medical_claim') }} 
where claim_start_date > claim_end_date

union all

select
  'admission_date > discharge_date' as test_description
, count(distinct claim_id) as claim_count
, '{{ var('last_update')}}' as last_update
from {{ ref('medical_claim') }} 
where admission_date > discharge_date

union all

select
  'enrollment_start_date > enrollment_end_date' as test_description
, count(1) as claim_count
, '{{ var('last_update')}}' as last_update
from {{ ref('eligibility') }} 
where enrollment_start_date > enrollment_end_date