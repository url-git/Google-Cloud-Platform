select
x_true_date true_date,
x_week_of_year week_of_year,
x_month_of_year month_of_year,
x_device device,
if(flaga = true, e_user_pseudo_id, null) id,
if(flaga = true, item_list_name, null) box_name,
if(flaga = true, e_item_id, null) id_product,
if(flaga = true, e_item_name, null) name_product,
if(flaga = true, e_item_category, null) category_product,
if(flaga = true, e_price, null) price_product,
transaction_id,
flaga

from (

with select_item as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'mobile' then 'mobile'
    when device.category like 'tablet' then 'mobile'
    else 'desktop' end device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    user_pseudo_id,
    x.item_id,
    x.item_list_name,
    x.price

from
    `empik-mobile-app.analytics_183670685.events_*`, unnest(items) x
where event_name like 'select_item'
    -- and _table_suffix between '20220512' and '20220512'
    and regexp_extract(_table_suffix, '[0-9]+') between '20220513' and format_date('%Y%m%d', current_date())
    and platform like 'WEB'
    and regexp_contains((SELECT value.string_value FROM unnest(event_params) WHERE key = 'page_location'), r'https://www.empik.com/cart/.*') = TRUE
    -- and user_pseudo_id = '1256137703.1635872171'
    and user_pseudo_id = '813200077.1639664593' # (Firefox)
group by 1,2,3,4,5,6,7,8,9
),

ecommerce as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'mobile' then 'mobile'
    when device.category like 'tablet' then 'mobile'
    else 'desktop' end device,
    event_timestamp,
    e.item_id,
    e.item_name,
    e.item_category,
    e.price,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    user_pseudo_id,
    ecommerce.transaction_id

from `empik-mobile-app.analytics_183670685.events_*`, unnest(items) e
where
    event_name in ('purchase', 'ecommerce_purchase')
    and platform like 'WEB'
    -- and _table_suffix between '20220512' and '20220512'
    and regexp_extract(_table_suffix, '[0-9]+') between '20220513' and format_date('%Y%m%d', current_date())
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    -- and user_pseudo_id = '1256137703.1635872171' # (Chrome)
    and user_pseudo_id = '813200077.1639664593' # (Firefox)
)

select
x.true_date x_true_date,
x.week_of_year x_week_of_year,
x.month_of_year x_month_of_year,
x.device x_device,
x.item_id x_item_id,
x.item_list_name,
x.price x_price,
e.user_pseudo_id e_user_pseudo_id,
e.item_name e_item_name,
e.item_category e_item_category,
e.item_id e_item_id,
e.price e_price,
e.transaction_id,
REGEXP_CONTAINS(x.item_id, e.item_id) flaga,


from select_item x left join ecommerce e on x.true_date=e.true_date and x.device=e.device and x.id=e.id)
where flaga is true