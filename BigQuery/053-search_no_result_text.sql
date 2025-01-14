select * from (

select * from (

with search_no_result_text as (
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
    ifnull(traffic_source.source,'(not set)') tsource,
    ifnull(traffic_source.medium,'(not set)') medium,
    case when (SELECT value.string_value FROM unnest(event_params) WHERE key = 'search_term') is null
    then cast ((SELECT value.int_value FROM unnest(event_params) WHERE key = 'search_term') as string)
    else (SELECT value.string_value FROM unnest(event_params) WHERE key = 'search_term') end keywords,
    ifnull((SELECT value.string_value FROM unnest(event_params) WHERE key = 'content_group'), 'no data') content_group,
    case when (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'logged') is null
    then (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'status')
    else (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'logged') end status,

    case when (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'subscription_logged') is null
    then (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'ep')
    else (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'subscription_logged') end ep,

    case when (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'me_logged') is null
    then (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'me')
    else (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'me_logged') end me,
    count(*) cnt_search

from `empik-mobile-app.analytics_183670685.events_*`
where
    _table_suffix between '20210101' and '20220604'
    -- _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
    and platform like 'WEB'
    and event_name in ('search_no_result_text')
group by 1,2,3,4,5,6,7,8,9,10,11,12,13
)

select
n.true_date,
n.week_of_year,
n.month_of_year,
n.device,
concat(n.tsource, ' / ', n.medium) source_medium,
function_us.channel_grouping_ga4_AWA51 (n.tsource, n.medium, null) as channel_grouping,
n.keywords,
n.content_group,
case when n.status = 'Zalogowany' then 'true' when n.status = 'Niezalogowany' then 'false' else 'no data' end czy_zalogowany,
case when n.ep = 'true' then 'EP' when n.me = 'true' and n.ep = 'false' then 'EPF' else 'ecom' end subscription,
cnt_search

from search_no_result_text n
where regexp_contains(page_location, r'qtype=facetForm') = FALSE
)

union all

select * from (

with search_no_result_text as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    'APP' device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    (SELECT value.string_value FROM unnest(event_params) WHERE key = 'page_location') page_location,
    ifnull(traffic_source.source,'(not set)') tsource,
    ifnull(traffic_source.medium,'(not set)') medium,
    ifnull((SELECT value.string_value FROM unnest(event_params) WHERE key = 'search_term'), 'no data') keywords,
    ifnull((SELECT value.string_value FROM unnest(event_params) WHERE key = 'content_group'), 'no data') content_group,
    ifnull(max((SELECT value.string_value FROM unnest(user_properties) WHERE key = 'logged')), 'no data') status,
    ifnull(max((SELECT value.string_value FROM unnest(user_properties) WHERE key = 'me_logged')), 'no data') me,
    ifnull(max((SELECT value.string_value FROM unnest(user_properties) WHERE key = 'subscription_logged')), 'no data') ep,
    count(*) cnt_search

from `empik-mobile-app.analytics_183670685.events_*`
where
    _table_suffix between '20210101' and '20220604'
    -- _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
    and platform <> 'WEB'
    and event_name in ('search_no_result_text')
group by 1,2,3,4,5,6,7,8,9,10
)

select
n.true_date,
n.week_of_year,
n.month_of_year,
n.device,
concat(n.tsource, ' / ', n.medium) source_medium,
function_us.channel_grouping_ga4_AWA51 (n.tsource, n.medium, null) as channel_grouping,
n.keywords,
n.content_group,
case when n.status = '1' then 'true' when n.status = '0' then 'false' else 'false' end czy_zalogowany,
case when n.ep = '1' then 'EP' when n.me = '1' and n.ep = '0' then 'EPF' else 'ecom' end subscription,
cnt_search

from search_no_result_text n ))
where keywords is not null
order by 1 desc