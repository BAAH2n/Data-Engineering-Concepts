with source as (
    select * from {{ ref('taxi_zones') }}
),

renamed as (
    select
        "LocationID"::integer as location_id,
        "Borough"::varchar as borough_name,
        "Zone"::varchar as zone_name,
        "service_zone"::varchar as service_zone_name
    from source
)

select * from renamed