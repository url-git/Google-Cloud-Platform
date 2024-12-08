with remarketing as ( SELECT partition_time, cast(attributed_touch_time as datetime) as attributed_touch_time, event_time,
JSON_VALUE(event_value,'$.af_order_id') as order_id, sum(cast(revenue_in_selected_currency as float64)) as revenue
FROM `eobuwie-181013.01_AppsFlyer_EOB.mobile_devices_events` where partition_time<'2021-07-15'
and event_name like ('%purchase%') and
is_retargeting = true
group by 1,2,3,4
order by 1),

merged as (
SELECT w.partition_time, cast(w.event_time as datetime) as event_time, cast(remarketing.attributed_touch_time as datetime) as remarketing_touch,
'p' as diff,  JSON_VALUE(event_value,'$.af_order_id') as order_id2, remarketing.order_id, sum(cast(w.revenue_in_selected_currency as float64)) as revenue
FROM `eobuwie-181013.01_AppsFlyer_EOB.mobile_devices_events` as w

left join remarketing on JSON_VALUE(event_value,'$.af_order_id')=remarketing.order_id
where w.partition_time<'2021-07-15'
and w.event_name like ('%purchase%') and
w.is_retargeting = false
group by 1,2,3,4,5,6)

SELECT event_time, order_id, if(remarketing_touch is not null,datetime_diff(event_time,remarketing_touch,HOUR),null) as czas
from merged
limit 5