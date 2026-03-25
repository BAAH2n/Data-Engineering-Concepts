{{ config(materialized='incremental', unique_key=['pickup_location_id', 'pickup_hour']) }}

with rides as (
    select * from {{ ref('stg_rides') }}
),

hourly_demand as (
    select
        pickup_location_id,
        date_trunc('hour', pickup_at) as pickup_hour,
        count(ride_id) as total_rides,
        sum(fare_amount) as total_revenue
    from rides
    
    {% if is_incremental() %}
      where pickup_at >= (select max(pickup_hour) - interval 3 day from {{ this }})
    {% endif %}
    
    group by 
        pickup_location_id, 
        date_trunc('hour', pickup_at)
)

select * from hourly_demand