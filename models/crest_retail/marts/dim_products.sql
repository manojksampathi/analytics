-- Product dimension
-- One row per product

with stg_products as (
    select * from {{ ref('stg_products') }}
)

select
    product_id,
    sku,
    product_name,
    category,
    sub_category,
    gender_segment,
    brand,
    cost_price,
    retail_price,
    gross_margin_per_unit,
    round(safe_divide(gross_margin_per_unit, retail_price) * 100, 2) as margin_pct,
    launch_date,
    product_status
from stg_products
