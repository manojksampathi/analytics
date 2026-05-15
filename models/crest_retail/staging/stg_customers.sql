with source as (
    select * from {{ source('crest_raw', 'raw_customers') }}
),

renamed as (
    select
        customer_id,
        first_name,
        last_name,
        email,
        segment        as customer_segment,
        city,
        state,
        region,
        signup_date,
        acquired_channel
    from source
)

select * from renamed
