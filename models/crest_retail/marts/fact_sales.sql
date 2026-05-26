-- Sales fact table
-- Grain: one row per order line item
-- Combines order header + line items + return info

with stg_orders as (
    select * from {{ ref('stg_orders') }}
),

stg_order_items as (
    select * from {{ ref('stg_order_items') }}
),

returns as (
    select 
        order_item_id,
        return_id,
        return_date,
        return_reason,
        refund_amount,
        status as return_status
    from {{ source('crest_raw', 'raw_returns') }}
),

joined as (
    select
        -- Primary key
        oi.order_item_id,
        
        -- Foreign keys to dimensions
        o.order_id,
        o.customer_id,
        o.store_id,
        oi.product_id,
        o.promo_id,
        o.order_date_only            as date_key,
        
        -- Degenerate dimensions (attributes that live on the fact)
        o.order_date,
        o.channel,
        o.order_status,
        o.payment_method,
        
        -- Measures
        oi.quantity,
        oi.unit_price,
        oi.discount_amount           as line_discount_amount,
        oi.net_unit_price,
        oi.line_total                as gross_revenue,
        
        -- Order-level allocations (proportional to line value)
        round(o.tax_amount * safe_divide(oi.line_total, o.gross_amount), 2) as allocated_tax,
        round(o.shipping_amount * safe_divide(oi.line_total, o.gross_amount), 2) as allocated_shipping,
        
        -- Return info (NULL if not returned)
        r.return_id,
        r.return_date,
        r.return_reason,
        r.refund_amount,
        case when r.return_id is not null then true else false end as is_returned,
        
        -- Net revenue (gross minus refund)
        oi.line_total - coalesce(r.refund_amount, 0) as net_revenue
        
    from stg_order_items oi
    inner join stg_orders o
        on oi.order_id = o.order_id
    left join returns r
        on oi.order_item_id = r.order_item_id
)

select * from joined
