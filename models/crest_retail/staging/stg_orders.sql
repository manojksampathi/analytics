-- Staging model: cleaned and renamed DTC orders
-- Source: crest_raw.raw_orders

with source as (
    select * from {{ source('crest_raw', 'raw_orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        store_id,
        promo_id,
        order_date,
        cast(order_date as date) as order_date_only,
        channel,
        status              as order_status,
        gross_amount,
        discount_amount,
        net_amount,
        tax_amount,
        shipping_amount,
        payment_method
    from source
)

select * from renamed
