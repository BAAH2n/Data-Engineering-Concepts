with source as (
    select * from {{ ref('drivers') }}
),

renamed as (
    select
        driver_id::integer as driver_id,
        vehicle_type as car_category, 
        rating::float as driver_rating,
        upper(status) as driver_status
    from source
)

select * from renamed