{{ config(materialized='table') }}

with daily_stats as (
    select * from {{ ref('fct_driver_daily_stats') }}
),

drivers as (
    select * from {{ ref('dim_drivers') }}
),

driver_totals as (
    select
        d.driver_id,
        d.driver_performance_tier, 
        sum(s.total_rides) as lifetime_rides,
        sum(s.total_revenue) as lifetime_revenue
    from daily_stats s
    left join drivers d 
        on s.driver_id = d.driver_id
    group by 
        d.driver_id, 
        d.driver_performance_tier
),

ranked_drivers as (
    select
        *,
        dense_rank() over (order by lifetime_revenue desc) as revenue_rank
    from driver_totals
)

select * from ranked_drivers