{{ config(materialized='incremental', unique_key=['driver_id', 'date'] ) }}

with rides as (
    select * from {{ ref('stg_rides') }}
),

daily_stats as (
    select
        driver_id,
        cast(pickup_at as date) as date,
        count(ride_id) as total_rides,
        sum(fare_amount) as total_revenue,
        sum(trip_duration_minutes) as total_duration_minutes
    from rides
    
    {% if is_incremental() %}
      where pickup_at >= (select max(date) - interval 3 day from {{ this }})
    {% endif %}
    
    group by 
        driver_id, 
        cast(pickup_at as date)
)

select * from daily_stats