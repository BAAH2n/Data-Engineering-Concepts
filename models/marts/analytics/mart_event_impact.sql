{{ config(materialized='table') }}

with daily_demand as (
    select * from {{ ref('fct_zone_daily_demand') }}
),

events as (
    select * from {{ ref('dim_events') }}
),

zones as (
    select * from {{ ref('dim_locations') }}
),

event_impact as (
    select
        e.event_name,
        e.event_date,
        z.borough_name,
        z.zone_name,
        e.attendees_count,
        d.total_rides as rides_on_event_day,
        d.total_revenue as revenue_on_event_day
    from events e
    left join daily_demand d
        on e.location_id = d.pickup_location_id
        and e.event_date = d.date
    left join zones z
        on e.location_id = z.location_id
)

select * from event_impact