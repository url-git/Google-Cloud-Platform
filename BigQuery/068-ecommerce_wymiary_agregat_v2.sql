select * from (

with ecommerce_web as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    case when (SELECT value.string_value FROM unnest(event_params) WHERE key = 'merchant') = 'Empik' then 'Empik'
    when regexp_contains((SELECT value.string_value FROM unnest(event_params) WHERE key = 'merchant'), r'^Empik, Empik$|^Empik, Empik, Empik$|^Empik, Empik, Empik, Empik$') = true then 'Empik'
    when regexp_contains((SELECT value.string_value FROM unnest(event_params) WHERE key = 'merchant'), r'.*Empik.*') = true then 'Empik + Marketplace'
    else 'Marketplace' end merchant,
    ecommerce.total_item_quantity quantity,
    ecommerce.purchase_revenue purchase_value,
    max((SELECT value.string_value FROM unnest(user_properties) WHERE key = 'status')) status,
    max((SELECT value.string_value FROM unnest(user_properties) WHERE key = 'ep')) ep,
    max((SELECT value.string_value FROM unnest(user_properties) WHERE key = 'me')) me,
    ecommerce.transaction_id order_id
    from `empik-mobile-app.analytics_183670685.events_*`
    where event_name in ('purchase', 'ecommerce_purchase')
    and platform like 'WEB'
    and _table_suffix between '20220401' and '20220430'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    group by 1,2,3,4,5,6,7,11)

select
    true_date,
    week_of_year,
    month_of_year,
    device,
    case when status = 'Zalogowany' then 'true' when status = 'Niezalogowany' then 'false' else 'false' end zalogowany,
    case when ep = 'true' then 'EP' when me = 'true' and ep = 'false' then 'EPF' else 'other' end subscription,
    merchant,
    sum(quantity) quantity,
    count (distinct order_id) order_id,
    sum(purchase_value) purchase_value
from ecommerce_web
GROUP BY 1,2,3,4,5,6,7

union all

select * from (

with ecommerce_app as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    'APP' device,
    case when (SELECT value.string_value FROM unnest(event_params) WHERE key = 'cart_type') = 'empik_only' then 'Empik'
    when (SELECT value.string_value FROM unnest(event_params) WHERE key = 'cart_type') = 'mixed' then 'Empik + Marketplace'
    else 'Marketplace' end merchant,
    (SELECT value.int_value FROM unnest(event_params) WHERE key = 'item_number_total') quantity,
    case when (select value.double_value from unnest(event_params) where key = "value") is null
    then (select value.int_value from unnest(event_params) where key = "value")
    else (select value.double_value from unnest(event_params) where key = "value") end as purchase_value,
    (SELECT value.string_value FROM unnest(event_params) WHERE key = 'order_id') order_id,
    max((SELECT value.string_value FROM unnest(user_properties) WHERE key = 'logged')) status,
    max((SELECT value.string_value FROM unnest(user_properties) WHERE key = 'me_logged')) me,
    max((SELECT value.string_value FROM unnest(user_properties) WHERE key = 'subscription_logged')) ep,
    from `empik-mobile-app.analytics_183670685.events_*`
    where event_name in ('purchase', 'ecommerce_purchase')
    and platform <> 'WEB'
    and _table_suffix between '20220401' and '20220430'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    group by 1,2,3,4,5,6,7,8)

select
    true_date,
    week_of_year,
    month_of_year,
    device,
    case when status = '1' then 'true' when status = '0' then 'false' else 'false' end zalogowany,
    case when ep = '1' then 'EP' when me = '1' and ep = '0' then 'EPF' else 'other' end subscription,
    merchant,
    sum(quantity) quantity,
    count(distinct order_id) order_id,
    sum(purchase_value) purchase_value
from ecommerce_app
GROUP BY 1,2,3,4,5,6,7)) order by 1 desc