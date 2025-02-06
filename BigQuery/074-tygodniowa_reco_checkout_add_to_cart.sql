%%bigquery

select

true_date,
week_of_year,
month_of_year,
device,
item_list_name,
count(distinct sesje) sesje,
sum(odslon_box_items) odslony_unikalnych_produktow,
count (distinct item_add_to_cart) add_to_cart,
count(distinct transaction_id) transakcje,
sum(quantity) quantity,
sum(price) przychody_z_klikanych_produktow


from (

with reco_view_item_list as (

select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'DESKTOP_WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'DESKTOP_MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'DESKTOP_MOB'
    else 'DESKTOP_WEB' end device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    user_pseudo_id,
    (SELECT value.string_value FROM unnest(event_params) WHERE key = 'page_location') page_location,
    x.item_list_name,
    count(distinct x.item_id) odslon_box_items


from
    `empik-mobile-app.analytics_183670685.events_*`, unnest(items) x
where
    event_name = 'view_item_list'
    -- and _table_suffix between '20220512' and '20220512'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    and _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 9 DAY)) AND FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
    -- and regexp_extract(_table_suffix, '[0-9]+') between '20220826' and format_date('%Y%m%d', current_date())
    and platform like 'WEB'
    and regexp_contains((SELECT value.string_value FROM unnest(event_params) WHERE key = 'page_location'), r'https://www.empik.com/cart/.*') = TRUE
group by 1,2,3,4,5,6,7,8),

reco_add_to_cart as (
select

    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'DESKTOP_WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'DESKTOP_MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'DESKTOP_MOB'
    else 'DESKTOP_WEB' end device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    user_pseudo_id,
    (SELECT value.string_value FROM unnest(event_params) WHERE key = 'page_location') page_location,
    (SELECT value.string_value FROM unnest(event_params) WHERE key = 'item_id') item_id,
    x.item_list_name,

from
    `empik-mobile-app.analytics_183670685.events_*`, unnest(items) x
where
    event_name = 'add_to_cart'
    -- and _table_suffix between '20220512' and '20220512'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    and _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 9 DAY)) AND FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
    -- and regexp_extract(_table_suffix, '[0-9]+') between '20220826' and format_date('%Y%m%d', current_date())
    and platform like 'WEB'
    and regexp_contains((SELECT value.string_value FROM unnest(event_params) WHERE key = 'page_location'), r'https://www.empik.com/cart/.*') = TRUE
group by 1,2,3,4,5,6,7,8,9),

reco_purchase as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'DESKTOP_WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'DESKTOP_MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'DESKTOP_MOB'
    else 'DESKTOP_WEB' end device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    user_pseudo_id,
    ecommerce.transaction_id,
    e.item_id,
    e.item_name,
    e.quantity,
    e.price

from
    `empik-mobile-app.analytics_183670685.events_*`, unnest(items) e
where
    event_name = 'purchase'
    -- and _table_suffix between '20220512' and '20220512'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    and _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 9 DAY)) AND FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
    -- and regexp_extract(_table_suffix, '[0-9]+') between '20220826' and format_date('%Y%m%d', current_date())
    and platform like 'WEB')


select
v1.true_date,
v1.week_of_year,
v1.month_of_year,
v1.device,
v1.id sesje,
v1.item_list_name,
v1.odslon_box_items,
v2.id,
v2.item_id item_add_to_cart,
v3.id,
v3.transaction_id,
v3.item_id,
v3.quantity,
v3.price

from reco_view_item_list v1 left join reco_add_to_cart v2 on v1.device=v2.device and v1.user_pseudo_id=v2.user_pseudo_id and v1.item_list_name=v2.item_list_name
left join reco_purchase v3 on v2.device=v3.device and v2.user_pseudo_id=v3.user_pseudo_id and v2.item_id=v3.item_id and date_diff(v3.true_date, v2.true_date, DAY) <=7
-- where transaction_id is not null
)
group by 1,2,3,4,5
order by true_date desc, transakcje desc