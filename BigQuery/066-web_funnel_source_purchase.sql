select
    true_date,
    week_of_year,
    month_of_year,
    device,
    session_source_medium,
    sum(all_sessions) all_sessions,
    sum(view_item) view_item,
    sum(addToCart) addToCart,
    sum(cart) cart,
    sum(delivery_payment) delivery_payment,
    sum(purchase) purchase

from (

with all_sessions as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    concat(ifnull(traffic_source.source,'(direct)'),' / ',ifnull(traffic_source.medium,'(none)')) as session_source_medium,
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) id,
    event_timestamp
from `empik-mobile-app.analytics_183670685.events_*`
where
    platform = 'WEB'
    and _table_suffix between '20220401' and '20220413'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
group by 1,2,3,4,5,6,7
),

krok_view_item as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) id,
    event_timestamp
from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'view_item'
    and platform = 'WEB'
    and _table_suffix between '20220401' and '20220413'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
),

krok_addToCart as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) id,
    event_timestamp
from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'add_to_cart'
    and platform = 'WEB'
    and _table_suffix between '20220401' and '20220413'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
),

krok_1 as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'APP' end device,
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) id,
    event_timestamp
from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'begin_checkout'
    and platform = 'WEB'
    and _table_suffix between '20220401' and '20220413'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
),

krok_2 as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) id,
    event_timestamp
from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'cart_summary_view'
    and platform = 'WEB'
    and _table_suffix between '20220401' and '20220413'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
),

krok_3 as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) id,
    event_timestamp
from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name in ('purchase', 'ecommerce_purchase')
    and platform = 'WEB'
    and _table_suffix between '20220401' and '20220413'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
)

SELECT
    all_s.true_date,
    all_s.week_of_year,
    all_s.month_of_year,
    case when all_s.device like 'WEB' then 'WEB' else 'MOB' end device,
    all_s.session_source_medium,
    count(distinct all_s.id) all_sessions,
    count(distinct k0v.id) view_item,
    count(distinct k0a.id) addToCart,
    count(distinct k1.id) cart,
    count(distinct k2.id) delivery_payment,
    count(distinct k3.id) purchase

FROM

    all_sessions all_s
    LEFT JOIN krok_view_item k0v on (all_s.true_date = k0v.true_date and all_s.id = k0v.id and all_s.event_timestamp < k0v.event_timestamp and all_s.device=k0v.device)
    LEFT JOIN krok_addToCart k0a on (k0v.true_date = k0a.true_date and k0v.id = k0a.id and k0v.event_timestamp < k0a.event_timestamp and k0v.device=k0a.device)
    LEFT JOIN krok_1 k1 on (k0a.true_date = k1.true_date and k0a.id = k1.id and k0a.event_timestamp < k1.event_timestamp and k0a.device=k1.device)
    LEFT JOIN krok_2 k2 ON (k1.true_date = k2.true_date and k1.id = k2.id and k1.event_timestamp < k2.event_timestamp and k1.device=k2.device)
    LEFT JOIN krok_3 k3 ON (k2.true_date = k3.true_date and k2.id = k3.id and k2.event_timestamp < k3.event_timestamp and k2.device=k3.device)

group by 1,2,3,4,5

) group by 1,2,3,4,5 order by 1 desc