with source as (
    select * from {{ ref('events') }}
),

renamed as (
    select
        event_id::integer as event_id,
        event_name,
        location_id,
        event_date::date as event_date,
        estimated_attendance::integer as attendees_count
    from source
)

select * from renamed