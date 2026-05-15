with source as (
    select * from {{ source('crest_raw', 'raw_stores') }}
),

renamed as (
    select
        store_id,
        store_name,
        store_type,
        region,
        city,
        state,
        zip_code,
        opened_date,
        status as store_status,
        square_footage
    from source
)

select * from renamed
