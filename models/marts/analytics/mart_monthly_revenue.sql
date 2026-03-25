{{ config(materialized='table') }}

with daily_metrics as (
    select * from {{ ref('fct_daily_platform_metrics') }}
),

monthly_summary as (
    select
        date_trunc('month', date) as report_month,
        sum(platform_total_rides) as total_monthly_rides,
        sum(platform_total_revenue) as total_monthly_revenue,
        round(avg(active_drivers), 0) as avg_daily_active_drivers
    from daily_metrics
    group by 
        date_trunc('month', date)
)

select * from monthly_summary