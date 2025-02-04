with view_item_list as (

select
true_date,
week_of_year,
month_of_year,
device,
id,
user_pseudo_id,
item_list_name,
sum(total_item_quantity) total_item_quantity

from (

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
    (SELECT value.string_value FROM unnest(event_params) WHERE key = 'item_list_name') item_list_name,
    ecommerce.total_item_quantity

from
    `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'view_item_list'
    -- and _table_suffix between '20220824' and '20220827'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
    and regexp_extract(_table_suffix, '[0-9]+') between '20220929' and format_date('%Y%m%d', current_date())
    and platform like 'WEB'
    and regexp_contains((SELECT value.string_value FROM unnest(event_params) WHERE key = 'page_location'), r'https://www.empik.com/cart/.*') = TRUE
    -- AND user_pseudo_id = '1256137703.1635872171' # Chrome
    AND user_pseudo_id = '813200077.1639664593' # Firefox
    -- AND user_pseudo_id = '665549352.1661431727' # Edge

) where item_list_name is not null group by 1,2,3,4,5,6,7

),

select_item as (
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
    (SELECT value.string_value FROM unnest(event_params) WHERE key = 'box_reco') item_list_name

from
    `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'select_item'
    -- and _table_suffix between '20220824' and '20220827'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
    and regexp_extract(_table_suffix, '[0-9]+') between '20220929' and format_date('%Y%m%d', current_date())
    and platform like 'WEB'
    and regexp_contains((SELECT value.string_value FROM unnest(event_params) WHERE key = 'page_location'), r'https://www.empik.com/cart/.*') = TRUE
    -- AND user_pseudo_id = '1256137703.1635872171' # Chrome
    AND user_pseudo_id = '813200077.1639664593' # Firefox
    -- AND user_pseudo_id = '665549352.1661431727' # Edge
group by 1,2,3,4,5,6,7,8,9
having item_list_name is not null
),

purchase as (
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
    -- and _table_suffix between '20220824' and '20220827'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
    and regexp_extract(_table_suffix, '[0-9]+') between '20220929' and format_date('%Y%m%d', current_date())
    -- AND user_pseudo_id = '1256137703.1635872171' # Chrome
    AND user_pseudo_id = '813200077.1639664593' # Firefox
    -- AND user_pseudo_id = '665549352.1661431727' # Edge
    and platform like 'WEB')


select
v1.true_date,
v1.week_of_year,
v1.month_of_year,
v1.device,
v1.user_pseudo_id,
v1.item_list_name,
v1.total_item_quantity,

v2.item_id item_id_select_item,

v3.transaction_id,
v3.item_id item_id_purchase,
v3.quantity,
v3.price

from view_item_list v1 left join select_item v2 on v1.true_date=v2.true_date and v1.device=v2.device and v1.id=v2.id and v1.item_list_name=v2.item_list_name
left join purchase v3 on v2.true_date=v3.true_date and v2.device=v3.device and v2.id=v3.id and v2.item_id=v3.item_id