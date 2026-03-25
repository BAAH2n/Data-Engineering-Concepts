{{ config(materialized='incremental', unique_key='date') }}

with rides as (
    select * from {{ ref('stg_rides') }}
),

daily_metrics as (
    select
        cast(pickup_at as date) as date,
        count(ride_id) as platform_total_rides,
        sum(fare_amount) as platform_total_revenue,
        count(distinct driver_id) as active_drivers
    from rides
    
    {% if is_incremental() %}
      where pickup_at >= (select max(date) - interval 3 day from {{ this }})
    {% endif %}
    
    group by 
        cast(pickup_at as date)
)

select * from daily_metrics