{{ config(materialized='incremental', unique_key='ride_id') }}

with source_data as (
    select * from {{ ref('stg_rides') }}
)

select * from source_data

{% if is_incremental() %}

  where pickup_at >= (select max(pickup_at) - interval 3 day from {{ this }})

{% endif %}