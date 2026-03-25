{% snapshot customers_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='customer_id',
      strategy='check',
      check_cols=['first_name', 'last_name', 'customer_priority']
    )
}}

with source_data as (
    select * from {{ ref('stg_customers') }}
),

final as (
    select
        *,
        case
            when customer_id <= 10 then 'High Priority'
            when customer_id between 11 and 50 then 'Medium Priority'
            else 'Standard'
        end as customer_priority
    from source_data
)

select * from final

{% endsnapshot %}