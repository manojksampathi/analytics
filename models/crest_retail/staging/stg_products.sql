with source as (
    select * from {{ source('crest_raw', 'raw_products') }}
),

renamed as (
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
        retail_price - cost_price as gross_margin_per_unit,
        launch_date,
        status as product_status
    from source
)

select * from renamed
