{{ config(materialized='incremental', unique_key=['pickup_location_id', 'date']) }}

with rides as (
    select * from {{ ref('stg_rides') }}
),

daily_demand as (
    select
        pickup_location_id,
        cast(pickup_at as date) as date,
        count(ride_id) as total_rides,
        sum(fare_amount) as total_revenue,
        avg(trip_duration_minutes) as avg_trip_duration
    from rides
    
    {% if is_incremental() %}
      where pickup_at >= (select max(date) - interval 3 day from {{ this }})
    {% endif %}
    
    group by 
        pickup_location_id, 
        cast(pickup_at as date)
)

select * from daily_demand