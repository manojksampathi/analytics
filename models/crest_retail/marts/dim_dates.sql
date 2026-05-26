-- Date dimension
-- One row per day from 2020-01-01 to 2026-12-31

with date_spine as (
    select date_day
    from unnest(generate_date_array('2020-01-01', '2026-12-31', interval 1 day)) as date_day
)

select
    date_day                                          as date_key,
    extract(year      from date_day)                  as year,
    extract(quarter   from date_day)                  as quarter,
    extract(month     from date_day)                  as month,
    format_date('%B', date_day)                       as month_name,
    extract(week      from date_day)                  as week_of_year,
    extract(day       from date_day)                  as day_of_month,
    extract(dayofweek from date_day)                  as day_of_week,
    format_date('%A', date_day)                       as day_name,
    case 
        when extract(dayofweek from date_day) in (1, 7) then true
        else false
    end                                               as is_weekend,
    case
        when extract(month from date_day) in (11, 12) then 'Q4 Peak'
        when extract(month from date_day) in (6, 7, 8) then 'Summer'
        else 'Regular'
    end                                               as season_flag
from date_spine
