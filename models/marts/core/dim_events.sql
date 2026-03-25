{{ config(materialized='table') }}

with stg_events as (
    select * from {{ ref('stg_events') }}
),

enriched_events as (
    select
        event_id,
        event_name,
        location_id,
        event_date,
        attendees_count,
        dayname(event_date) as day_of_week,
        case 
            when dayofweek(event_date) in (0, 6) then true 
            else false 
        end as is_weekend_event
        
    from stg_events
)

select * from enriched_events