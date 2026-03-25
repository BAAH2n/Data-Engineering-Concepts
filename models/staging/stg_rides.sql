with source as (
    select * from {{ ref('rides') }}
),

renamed as (
    select
        ride_id::integer as ride_id,
        driver_id::integer as driver_id,
        pickup_location_id::integer as pickup_location_id,
        dropoff_location_id::integer as dropoff_location_id,
        pickup_datetime::timestamp as pickup_at,
        trip_duration_minutes::integer as trip_duration_minutes,
        fare_amount::numeric(10, 2) as fare_amount
        
    from source
)

select * from renamed