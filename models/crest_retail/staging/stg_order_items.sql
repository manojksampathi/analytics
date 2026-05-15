with source as (
    select * from {{ source('crest_raw', 'raw_order_items') }}
),

renamed as (
    select
        order_item_id,
        order_id,
        product_id,
        quantity,
        unit_price,
        discount_amount,
        net_unit_price,
        line_total
    from source
)

select * from renamed
