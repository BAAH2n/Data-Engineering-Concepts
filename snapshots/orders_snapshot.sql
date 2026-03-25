{% snapshot orders_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='order_id',
      strategy='check',
      check_cols=['status']
    )
}}

with source_data as (
    select * from {{ ref('stg_orders') }}
),

final as (
    select
        *,
        case
            when status = 'completed' then 'Fulfilled'
            when status = 'returned' then 'Returned'
            else 'Other'
        end as order_category
    from source_data
)

select * from final

{% endsnapshot %}