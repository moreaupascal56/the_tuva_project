{{ config(
     enabled = var('data_profiling_enabled',var('tuva_marts_enabled',True))
   )
}}

select
    source_table
    , grain
    , test_category
    , test_name
    , claim_type
    , count(distinct foreign_key) as failures
    , denom.denominator
    , '{{ var('last_update')}}' as last_update
from {{ ref('data_profiling__test_detail') }} det
inner join {{ ref('data_profiling__medical_claim_denominators') }} denom
    on det.claim_type = denom.test_denominator_name
where source_table = 'medical_claim'
and test_name not like '%invalid'
group by
    source_table
    , grain
    , test_category
    , test_name
    , claim_type
    , denom.denominator

union all

select
    source_table
    , grain
    , test_category
    , test_name
    , claim_type
    , count(distinct foreign_key) as failures
    , denom.denominator
    , '{{ var('last_update')}}' as last_update
from {{ ref('data_profiling__test_detail') }} det
inner join {{ ref('data_profiling__medical_claim_denominators') }} denom
    on det.test_name = denom.test_denominator_name
where source_table = 'medical_claim'
and test_name like '%invalid'
group by
    source_table
    , grain
    , test_category
    , test_name
    , claim_type
    , denom.denominator