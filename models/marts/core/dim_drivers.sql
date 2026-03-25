{{ config(materialized='table') }}

with stg_drivers as (
    select * from {{ ref('stg_drivers') }}
),

rated_drivers as (
    select
        driver_id,
        car_category,
        driver_rating,
        driver_status,
        {{ categorize_rating('driver_rating') }} as driver_performance_tier
        
    from stg_drivers
)

select * from enriched_drivers