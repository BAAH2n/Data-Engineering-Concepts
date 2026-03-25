{{ config(materialized='table') }}

with stg_taxi_zones as (
    select * from {{ ref('stg_taxi_zones') }}
),

borough_zone as (
    select
        location_id,
        borough_name,
        zone_name,
        service_zone_name,
        concat(borough_name, " - ", zone_name)
        
    from stg_taxi_zones
)

select * from borough_zone