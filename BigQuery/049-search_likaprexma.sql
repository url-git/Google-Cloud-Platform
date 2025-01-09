with krok1 as (
select *, case when regexp_contains(page_location, r'(fromSearchQuery=)') = TRUE then 'dopasowanie ścisłe'
else 'other' end type
from (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    (SELECT value.string_value FROM unnest(event_params) WHERE key = 'page_location') page_location,
    case when (SELECT value.string_value FROM unnest(event_params) WHERE key = 'search_term_redirect') is null
    then cast ((SELECT value.int_value FROM unnest(event_params) WHERE key = 'search_term_redirect') as string)
    else (SELECT value.string_value FROM unnest(event_params) WHERE key = 'search_term_redirect') end keywords,
    ifnull((SELECT value.string_value FROM unnest(event_params) WHERE key = 'content_group'), 'no data') content_group,
    'n/d' proposed_category,

from `empik-mobile-app.analytics_183670685.events_*`
where
    -- _table_suffix between '20210101' and '20220530'
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    and platform like 'WEB'
    and event_name = 'perfect_match'
group by 1,2,3,4,5,6,7,8,9)
),

krok2 as (
select * except(page_referrer)
from (

select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' then 'WEB'
    when device.category like 'mobile' then 'MOB'
    when device.category like 'tablet' then 'MOB'
    else 'WEB' end device,
    (SELECT value.string_value FROM unnest(event_params) WHERE key = 'page_location') page_location,
    (SELECT value.string_value FROM unnest(event_params) WHERE key = 'page_referrer') page_referrer,
    ifnull((SELECT value.string_value FROM unnest(event_params) WHERE key = 'content_group'), 'no data') content_group,
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) id
from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'add_to_cart'
    and platform = 'WEB'
    -- and _table_suffix between '20220101' and '20220505'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
)
where regexp_contains(page_location, r'(fromSearchQuery=)') = TRUE)


select
k1.true_date,
k1.week_of_year,
k1.month_of_year,
k1.device,
k1.type,
k1.keywords,
k1.content_group,
k1.proposed_category,
'search listing => karta produktu (exact match)' type_funnel,
count(distinct k1.id) search,
count(distinct k2.id) conversion,

from krok1 k1 left join krok2 k2 on k1.true_date=k2.true_date and k1.device=k2.device and k1.id=k2.id and k1.content_group=k2.content_group and k1.page_location=k2.page_location

group by 1,2,3,4,5,6,7,8