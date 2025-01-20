select *
from (
select *,
RANK() OVER (PARTITION BY id, keywords ORDER BY event_timestamp desc) rank

from (

select *

from (

with v1 as (

select *,
LAST_VALUE(event_timestamp) OVER (partition by id, item_id ORDER BY id) AS last_timestamp,
RANK() OVER (PARTITION BY id, keywords ORDER BY event_timestamp desc) rank

from (

select
  parse_date("%Y%m%d",event_date) true_date,
  format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
  format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
  case when device.category like 'desktop' and platform like 'WEB' then 'DESKTOP_WEB'
  when device.category like 'mobile' and platform like 'WEB' then 'DESKTOP_MOB'
  when device.category like 'tablet' and platform like 'WEB' then 'DESKTOP_MOB'
  else 'DESKTOP_WEB' end device,
  'Flow :: Produkt dodany do koszyka' flow,
  case when (SELECT value.string_value FROM unnest(event_params) WHERE key = 'search_term') is null
  then cast ((SELECT value.int_value FROM unnest(event_params) WHERE key = 'search_term') as string)
  else (SELECT value.string_value FROM unnest(event_params) WHERE key = 'search_term') end keywords,
  (SELECT value.string_value FROM unnest(event_params) WHERE key = 'item_id_listing') item_id,
  event_timestamp,
  user_id,
  user_pseudo_id,
  concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id


from `empik-mobile-app.analytics_183670685.events_*`
where
  platform like 'WEB'
  and (SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'add_to_cart' and key = 'content_group') = 'Listingpage'
  and _table_suffix between '20220930' and '20220930'
  -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
  -- and REGEXP_EXTRACT(_table_suffix, '[0-9]+') BETWEEN '20220930' AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
group by 1,2,3,4,5,6,7,8,9,10,11
having keywords is not null and item_id is not null

)

-- QUALIFY RANK() OVER (PARTITION BY id, keywords ORDER BY event_timestamp desc) = 1

),

v2 as (

select *,
RANK() OVER (PARTITION BY id, item_id ORDER BY event_timestamp) rank

from (

select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'DESKTOP_WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'DESKTOP_MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'DESKTOP_MOB'
    else 'DESKTOP_WEB' end device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    'Flow :: Produkt dodany do koszyka' flow,
    user_pseudo_id,
    event_timestamp,
    ecommerce.transaction_id,
    e.item_id,
    lower(e.item_name) name_products,
    e.quantity,
    e.price,
    e.item_brand,
    e.item_category

from
    `empik-mobile-app.analytics_183670685.events_*`, unnest(items) e
where
  event_name = 'purchase'
  and _table_suffix between '20220930' and '20220930'
  -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
  -- and REGEXP_EXTRACT(_table_suffix, '[0-9]+') BETWEEN '20220930' AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
  and platform like 'WEB'
)

QUALIFY RANK() OVER (PARTITION BY id, item_id ORDER BY event_timestamp desc) = 1

)

select
v1.true_date,
v1.week_of_year,
v1.month_of_year,
v1.device,
v1.flow,
v1.keywords,
v1.event_timestamp,
v2.id,
v2.user_pseudo_id,
v2.item_id,
v2.name_products,
v2.quantity,
v2.item_brand,
v2.item_category,
v2.price,
v2.quantity * v2.price item_revenue,
v2.transaction_id

from v1 left join v2 on v1.true_date=v2.true_date and v1.id=v2.id and v1.device=v2.device and v1.item_id=v2.item_id and v1.flow=v2.flow
)

union all

select *
from (
with v1 as (

select *,
LAST_VALUE(event_timestamp) OVER (partition by id, item_id ORDER BY id) AS last_timestamp,
RANK() OVER (PARTITION BY id, keywords ORDER BY event_timestamp desc) rank

from (

select
  parse_date("%Y%m%d",event_date) true_date,
  format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
  format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
  case when device.category like 'desktop' and platform like 'WEB' then 'DESKTOP_WEB'
  when device.category like 'mobile' and platform like 'WEB' then 'DESKTOP_MOB'
  when device.category like 'tablet' and platform like 'WEB' then 'DESKTOP_MOB'
  else 'DESKTOP_WEB' end device,
  'Flow :: Przejście na kartę produktu' flow,
  case when (SELECT value.string_value FROM unnest(event_params) WHERE key = 'search_term') is null
  then cast ((SELECT value.int_value FROM unnest(event_params) WHERE key = 'search_term') as string)
  else (SELECT value.string_value FROM unnest(event_params) WHERE key = 'search_term') end keywords,
  split((SELECT value.string_value FROM unnest(event_params) WHERE key = 'click_url_path'), ',')[SAFE_OFFSET(1)] item_id,
  event_timestamp,
  user_pseudo_id,
  concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id


from `empik-mobile-app.analytics_183670685.events_*`
where
  platform like 'WEB'
  and (SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'select_item' and key = 'content_group') = 'Listingpage'
  and _table_suffix between '20220930' and '20220930'
  -- and user_pseudo_id = '914016054.1658505575'
  -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
  -- and REGEXP_EXTRACT(_table_suffix, '[0-9]+') BETWEEN '20220930' AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
  group by 1,2,3,4,5,6,7,8,9,10
  having keywords is not null and item_id is not null

)

-- QUALIFY RANK() OVER (PARTITION BY id, keywords ORDER BY event_timestamp desc) = 1

),

v2 as (

select *,
RANK() OVER (PARTITION BY id, item_id ORDER BY event_timestamp) rank

from (

select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'DESKTOP_WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'DESKTOP_MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'DESKTOP_MOB'
    else 'DESKTOP_WEB' end device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    'Flow :: Przejście na kartę produktu' flow,
    user_pseudo_id,
    event_timestamp,
    ecommerce.transaction_id,
    e.item_id,
    lower(e.item_name) name_products,
    e.quantity,
    e.price,
    e.item_brand,
    e.item_category

from
    `empik-mobile-app.analytics_183670685.events_*`, unnest(items) e
where
  event_name = 'purchase'
  and _table_suffix between '20220930' and '20220930'
  -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
  -- and REGEXP_EXTRACT(_table_suffix, '[0-9]+') BETWEEN '20220930' AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
  and platform like 'WEB'
  -- and user_pseudo_id = '914016054.1658505575'
)

QUALIFY RANK() OVER (PARTITION BY id, item_id ORDER BY event_timestamp desc) = 1

)

select
v1.true_date,
v1.week_of_year,
v1.month_of_year,
v1.device,
v1.flow,
v1.keywords,
v1.event_timestamp,
v2.id,
v2.user_pseudo_id,
v2.item_id,
v2.name_products,
v2.quantity,
v2.item_brand,
v2.item_category,
v2.price,
v2.quantity * v2.price item_revenue,
v2.transaction_id

from v1 left join v2 on v1.true_date=v2.true_date and v1.id=v2.id and v1.device=v2.device and v1.item_id=v2.item_id and v1.flow=v2.flow
))

# Deduplikacja wierszy (pozostawiam ostatni keywords)

qualify RANK() OVER (PARTITION BY id, keywords ORDER BY event_timestamp desc) = 1
)

where transaction_id is not null
order by 1 desc, id