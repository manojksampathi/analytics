-- Customer dimension
-- One row per customer

with stg_customers as (
    select * from {{ ref('stg_customers') }}
)

select
    customer_id,
    first_name,
    last_name,
    concat(first_name, ' ', last_name) as full_name,
    email,
    customer_segment,
    city,
    state,
    region,
    signup_date,
    acquired_channel,
    date_diff(current_date(), signup_date, day) as customer_tenure_days
from stg_customers
