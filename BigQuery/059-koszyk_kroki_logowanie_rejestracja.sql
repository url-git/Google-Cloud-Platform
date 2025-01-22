select * from (
with koszyk as (
select
    true_date, 
    week_of_year,
    month_of_year,
    device,
    count(distinct id) sesji_koszyk
from (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    (SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location') page_location,

from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'page_view'
    -- and _table_suffix between '20210101' and '20220530'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
group by 1,2,3,4,5,6)

where
    regexp_contains(page_location, r'(https://www.empik.com/koszyk/$)|(https://www.empik.com/cart/$)') = TRUE
group by 1,2,3,4),

delivery_and_payment as (
SELECT
    true_date,
    week_of_year,
    month_of_year,
    device,
    sum(case when page_0 IN ('https://www.empik.com/koszyk/','https://www.empik.com/cart/') then id else 0 end) po_koszyku,
    sum(case when page_0 IN ('https://www.empik.com/koszyk/logowanie?continue=/koszyk/dostawa-i-platnosc','https://www.empik.com/koszyk/logowanie?continue=/cart/delivery-and-payment') then id else 0 end) po_logowaniu,
    sum(case when page_0 IN ('https://www.empik.com/koszyk/rejestracja?continue=%2Fkoszyk%2Fdostawa-i-platnosc', 'https://www.empik.com/koszyk/rejestracja?continue=%2Fcart%2Fdelivery-and-payment') then id else 0 end) po_rejestracji


from (

select
    true_date,
    week_of_year,
    month_of_year,
    device,
    page_0,
    page_1,
    count(distinct id) id

from (

select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    event_timestamp,
    (SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location') page_0,
    lead((SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location'),1) over (partition by concat(user_pseudo_id,(select value.int_value from unnest     (event_params) where event_name = 'page_view' and key = 'ga_session_id')) order by event_timestamp asc) page_1

from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'page_view'
    -- and _table_suffix between '20210101' and '20220530'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
)
where
    regexp_contains(page_1, r'(https://www.empik.com/koszyk/dostawa-i-platnosc$)|(https://www.empik.com/cart/delivery-and-payment$)|(https://www.empik.com/cart/delivery-and-payment\?userConnectedToPremiumFree=true$)|(https://www.empik.com/koszyk/dostawa-i-platnosc\?userConnectedToPremiumFree=true$)') = TRUE

group by 1,2,3,4,5,6)
group by 1,2,3,4
),

gosc as (
select
    true_date,
    week_of_year,
    month_of_year,
    device,
    count(distinct id) gosc

from (

select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    event_timestamp,
    (SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location') page_0,
    lead((SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location'),1) over (partition by concat(user_pseudo_id,(select value.int_value from unnest     (event_params) where event_name = 'page_view' and key = 'ga_session_id')) order by event_timestamp asc) page_1,
    lead((SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location'),2) over (partition by concat(user_pseudo_id,(select value.int_value from unnest(event_params) where event_name = 'page_view' and key = 'ga_session_id')) order by event_timestamp asc) page_2

from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'page_view'
    -- and _table_suffix between '20210101' and '20220530'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))

)
where
    regexp_contains(page_0, r'(https://www.empik.com/koszyk/$)|(https://www.empik.com/cart/$)') = TRUE
    and
    regexp_contains(page_1, r'(https://www.empik.com/koszyk/logowanie\?continue=/koszyk/dostawa-i-platnosc$)|(https://www.empik.com/koszyk/logowanie\?continue=/cart/delivery-and-payment$)') = TRUE
    and
    regexp_contains(page_2, r'(https://www.empik.com/gosc/koszyk/dostawa-i-platnosc$)|(https://www.empik.com/cart/guest/delivery-and-payment$)') = TRUE

group by 1,2,3,4
),

after_guest as (
select
    true_date,
    week_of_year,
    month_of_year,
    device,
    count(distinct id) after_guest

from (

select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    event_timestamp,
    (SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location') page_0,
    lead((SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location'),1) over (partition by concat(user_pseudo_id,(select value.int_value from unnest     (event_params) where event_name = 'page_view' and key = 'ga_session_id')) order by event_timestamp asc) page_1,
    lead((SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location'),2) over (partition by concat(user_pseudo_id,(select value.int_value from unnest(event_params) where event_name = 'page_view' and key = 'ga_session_id')) order by event_timestamp asc) page_2,
    lead((SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location'),3) over (partition by concat(user_pseudo_id,(select value.int_value from unnest(event_params) where event_name = 'page_view' and key = 'ga_session_id')) order by event_timestamp asc) page_3

from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'page_view'
    -- and _table_suffix between '20210101' and '20220530'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))

)
where
    regexp_contains(page_0, r'(https://www.empik.com/koszyk/$)|(https://www.empik.com/cart/$)') = TRUE
    and
    regexp_contains(page_1, r'(https://www.empik.com/koszyk/logowanie\?continue=/koszyk/dostawa-i-platnosc$)|(https://www.empik.com/koszyk/logowanie\?continue=/cart/delivery-and-payment$)') = TRUE
    and
    regexp_contains(page_2, r'(https://www.empik.com/gosc/koszyk/dostawa-i-platnosc$)|(https://www.empik.com/cart/guest/delivery-and-payment$)') = TRUE
    and
    regexp_contains(page_3, r'(https://www.empik.com/koszyk/logowanie\?continue=/koszyk/dostawa-i-platnosc$)|(https://www.empik.com/koszyk/logowanie\?continue=/cart/delivery-and-payment$)|(https://www.empik.com/koszyk/logowanie\?continue=%2Fkoszyk)') = TRUE

group by 1,2,3,4
),

login_after_guest as (
select
    true_date,
    week_of_year,
    month_of_year,
    device,
    count(distinct id) login_after_guest

from (

select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    event_timestamp,
    (SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location') page_0,
    lead((SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location'),1) over (partition by concat(user_pseudo_id,(select value.int_value from unnest     (event_params) where event_name = 'page_view' and key = 'ga_session_id')) order by event_timestamp asc) page_1,
    lead((SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location'),2) over (partition by concat(user_pseudo_id,(select value.int_value from unnest(event_params) where event_name = 'page_view' and key = 'ga_session_id')) order by event_timestamp asc) page_2,
    lead((SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location'),3) over (partition by concat(user_pseudo_id,(select value.int_value from unnest(event_params) where event_name = 'page_view' and key = 'ga_session_id')) order by event_timestamp asc) page_3,
    lead((SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location'),4) over (partition by concat(user_pseudo_id,(select value.int_value from unnest(event_params) where event_name = 'page_view' and key = 'ga_session_id')) order by event_timestamp asc) page_4

from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'page_view'
    -- and _table_suffix between '20210101' and '20220530'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))

)
where
    regexp_contains(page_0, r'(https://www.empik.com/koszyk/$)|(https://www.empik.com/cart/$)') = TRUE
    and
    regexp_contains(page_1, r'(https://www.empik.com/koszyk/logowanie\?continue=/koszyk/dostawa-i-platnosc$)|(https://www.empik.com/koszyk/logowanie\?continue=/cart/delivery-and-payment$)') = TRUE
    and
    regexp_contains(page_2, r'(https://www.empik.com/gosc/koszyk/dostawa-i-platnosc$)|(https://www.empik.com/cart/guest/delivery-and-payment$)') = TRUE
    and
    regexp_contains(page_3, r'(https://www.empik.com/koszyk/logowanie\?continue=/koszyk/dostawa-i-platnosc$)|(https://www.empik.com/koszyk/logowanie\?continue=/cart/delivery-and-payment$)|(https://www.empik.com/koszyk/logowanie\?continue=%2Fkoszyk)') = TRUE
    and
    regexp_contains(page_4, r'(https://www.empik.com/koszyk/$)|(https://www.empik.com/cart/$)') = TRUE

group by 1,2,3,4
),

cofniecie_po_formularzu as (
select
    true_date,
    week_of_year,
    month_of_year,
    device,
    count(distinct id) cofniecie_po_formularzu

from (

select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    event_timestamp,
    (SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location') page_0,
    lead((SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location'),1) over (partition by concat(user_pseudo_id,(select value.int_value from unnest     (event_params) where event_name = 'page_view' and key = 'ga_session_id')) order by event_timestamp asc) page_1,
    lead((SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location'),2) over (partition by concat(user_pseudo_id,(select value.int_value from unnest(event_params) where event_name = 'page_view' and key = 'ga_session_id')) order by event_timestamp asc) page_2,
    lead((SELECT value.string_value FROM unnest(event_params) WHERE event_name = 'page_view' and key = 'page_location'),3) over (partition by concat(user_pseudo_id,(select value.int_value from unnest(event_params) where event_name = 'page_view' and key = 'ga_session_id')) order by event_timestamp asc) page_3

from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'page_view'
    -- and _table_suffix between '20210101' and '20220530'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))

)
where
    regexp_contains(page_0, r'(https://www.empik.com/koszyk/$)|(https://www.empik.com/cart/$)') = TRUE
    and
    regexp_contains(page_1, r'(https://www.empik.com/koszyk/logowanie\?continue=/koszyk/dostawa-i-platnosc$)|(https://www.empik.com/koszyk/logowanie\?continue=/cart/delivery-and-payment$)') = TRUE
    and
    regexp_contains(page_2, r'(https://www.empik.com/gosc/koszyk/dostawa-i-platnosc$)|(https://www.empik.com/cart/guest/delivery-and-payment$)') = TRUE
    and
    regexp_contains(page_3, r'(https://www.empik.com/koszyk/logowanie\?continue=/koszyk/dostawa-i-platnosc$)|(https://www.empik.com/koszyk/logowanie\?continue=/cart/delivery-and-payment$)') = TRUE


group by 1,2,3,4
)

select
a1.true_date,
a1.week_of_year,
a1.month_of_year,
a1.device,
a1.sesji_koszyk,
a2.po_koszyku,
a2.po_logowaniu,
a2.po_rejestracji,
a3.gosc,
a4.after_guest,
a5.login_after_guest,
a6.cofniecie_po_formularzu
from koszyk a1 left join delivery_and_payment a2 on a1.true_date=a2.true_date and a1.device=a2.device
left join gosc a3 on a1.true_date=a3.true_date and a1.device=a3.device
left join after_guest a4 on a1.true_date=a4.true_date and a1.device=a4.device
left join login_after_guest a5 on a1.true_date=a5.true_date and a1.device=a5.device
left join cofniecie_po_formularzu a6 on a1.true_date=a6.true_date and a1.device=a6.device
) order by 1 desc