-- Store dimension
-- One row per store

with stg_stores as (
    select * from {{ ref('stg_stores') }}
)

select
    store_id,
    store_name,
    store_type,
    region,
    city,
    state,
    zip_code,
    opened_date,
    store_status,
    square_footage,
    date_diff(current_date(), opened_date, year) as years_open
from stg_stores
