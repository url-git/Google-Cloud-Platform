select *
from (
select
    true_date,
    week_of_year,
    month_of_year,
    device,
    sum(cart) cart,
    sum(delivery_payment) delivery_payment,
    sum(purchase) purchase,
    sum(purchase_value) purchase_value

from (
with krok_1 as (
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
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
),

krok_2 as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'APP' end device,
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) id,
    event_timestamp
from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'cart_summary_view'
    and platform = 'WEB'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
),

krok_3 as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'APP' end device,
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) id,
    event_timestamp
from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name in ('purchase', 'ecommerce_purchase')
    and platform = 'WEB'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
)

SELECT
    k1.true_date,
    k1.week_of_year,
    k1.month_of_year,
    case when k1.device like 'WEB' then 'WEB'
    else 'MOB' end device,
    count(distinct k1.id) cart,
    count(distinct k2.id) delivery_payment,
    count(distinct k3.id) purchase,
    v.purchase_value purchase_value,

FROM krok_1 k1
    LEFT JOIN krok_2 k2 ON (k1.true_date = k2.true_date and k1.id = k2.id and k1.event_timestamp < k2.event_timestamp and k1.device=k2.device)
    LEFT JOIN krok_3 k3 ON (k2.true_date = k3.true_date and k2.id = k3.id and k2.event_timestamp < k3.event_timestamp and k1.device=k2.device)
    left join (select
        parse_date("%Y%m%d",event_date) true_date,
        case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
        when device.category like 'mobile' and platform like 'WEB' then 'MOB'
        when device.category like 'tablet' and platform like 'WEB' then 'MOB'
        else 'APP' end device,
        sum((SELECT value.double_value FROM unnest(event_params) WHERE key = 'value')) purchase_value
        from `empik-mobile-app.analytics_183670685.events_*`
        where event_name in ('purchase', 'ecommerce_purchase')
        and platform = 'WEB'
        and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
        group by 1,2) v on v.true_date=k3.true_date and v.device=k1.device

group by 1,2,3,4,8

) group by 1,2,3,4

-- APP
union all

select
    true_date,
    week_of_year,
    month_of_year,
    device,
    sum(cart) cart,
    sum(delivery_payment) delivery_payment,
    sum(purchase) purchase,
    sum(purchase_value) purchase_value

from (
with krok_1 as (
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
    and platform <> 'WEB'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
),

krok_2 as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'APP' end device,
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) id,
    event_timestamp
from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'cart_summary_view'
    and platform <> 'WEB'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
),

krok_3 as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'APP' end device,
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) id,
    event_timestamp
from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name in ('purchase', 'ecommerce_purchase')
    and platform <> 'WEB'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
)

SELECT
    k1.true_date,
    k1.week_of_year,
    k1.month_of_year,
    k1.device,
    count(distinct k1.id) cart,
    count(distinct k2.id) delivery_payment,
    count(distinct k3.id) purchase,
    v.purchase_value purchase_value,

FROM krok_1 k1
    LEFT JOIN krok_2 k2 ON (k1.true_date = k2.true_date and k1.id = k2.id and k1.event_timestamp < k2.event_timestamp and k1.device=k2.device)
    LEFT JOIN krok_3 k3 ON (k2.true_date = k3.true_date and k2.id = k3.id and k2.event_timestamp < k3.event_timestamp and k1.device=k2.device)
    left join (select
        parse_date("%Y%m%d",event_date) true_date,
        case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
        when device.category like 'mobile' and platform like 'WEB' then 'MOB'
        when device.category like 'tablet' and platform like 'WEB' then 'MOB'
        else 'APP' end device,
        sum((SELECT value.double_value FROM unnest(event_params) WHERE key = 'value')) purchase_value
        from `empik-mobile-app.analytics_183670685.events_*`
        where event_name in ('purchase', 'ecommerce_purchase')
        and platform <> 'WEB'
        and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
        group by 1,2) v on v.true_date=k3.true_date and v.device=k3.device

group by 1,2,3,4,8

) group by 1,2,3,4)

order by 1 desc