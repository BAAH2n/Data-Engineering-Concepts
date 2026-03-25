{{ config(materialized='table') }}

with daily_demand as (
    select * from {{ ref('fct_zone_daily_demand') }}
),

zones as (
    select * from {{ ref('dim_locations') }}
),


trends as (
    select
        z.borough_name,
        z.zone_name,
        d.date,
        d.total_rides,
        lag(d.total_rides) over (partition by z.location_id order by d.date) as prev_day_rides
        
    from daily_demand d
    left join zones z 
        on d.pickup_location_id = z.location_id
),


growth_calc as (
    select
        *,
        case
            when prev_day_rides = 0 or prev_day_rides is null then null
            else round((total_rides - prev_day_rides)::numeric / prev_day_rides * 100, 2)
        end as day_over_day_growth_pct
from trends
)

select * from growth_calc