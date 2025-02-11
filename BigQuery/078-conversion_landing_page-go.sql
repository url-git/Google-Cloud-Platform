with krok_1 as (

select *

from (

select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    ifnull(traffic_source.source,'(not set)') tsource,
    ifnull(traffic_source.medium,'(not set)') medium,
    (select value.string_value from unnest(event_params) where key = 'page_location') landing_page,
    (select value.string_value from unnest(event_params) where key = 'content_group') content_group,
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) as id
    from  `empik-go.analytics_160010935.events_*`
where event_name = 'page_view'
    and _table_suffix between '20220627' and '20220627'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    -- and REGEXP_EXTRACT(_table_suffix, '[0-9]+') BETWEEN '20220627' AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
    and platform like 'WEB')

where
regexp_contains(landing_page, r'www.empik.com\/gofree.*|www.empik.com\/go.*')
and content_group = 'other'

),


funnel_confirmation as
(select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) as id,
    ifnull(traffic_source.source,'(not set)') tsource,
    ifnull(traffic_source.medium,'(not set)') medium
from `empik-go.analytics_160010935.events_*`
where
    event_name LIKE 'funnel_confirmation'
    and _table_suffix between '20220627' and '20220627'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    -- and REGEXP_EXTRACT(_table_suffix, '[0-9]+') BETWEEN '20220627' AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
    and platform like 'WEB')

select
k.true_date,
k.week_of_year,
k.month_of_year,
k.device,
case when regexp_contains(k.landing_page, r'(https://www.empik.com/gofree.*)') = TRUE then 'empik.com/gofree' else 'empik.com/go' end lp,
concat(k.tsource, ' / ', k.medium) source_medium,
function_us.channel_grouping_ga4_AWA107 (k.tsource, k.medium, null) channel_grouping,
count (distinct k.id) count_landing_page,
count (distinct c.id) count_subscription_purchase,

from krok_1 k left join funnel_confirmation c on k.true_date=c.true_date and k.id=c.id and k.tsource=c.tsource and k.medium=c.medium and k.device=c.device
group by 1,2,3,4,5,6,7