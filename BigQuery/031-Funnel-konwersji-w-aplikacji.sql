with a as
(select
event_date,
event_name,
user_pseudo_id,
(select event_params.value.int_value from unnest(event_params) as event_params where event_params.key='ga_session_id') as id_session,
(select event_params.value.string_value from unnest(event_params) as event_params where event_params.key='transaction_id') AS transaction_id,
rank() over (partition by user_pseudo_id, (select event_params.value.int_value from unnest(event_params) as event_params where event_params.key='ga_session_id') order by event_timestamp) rank

from
`produkcja-mobile.analytics_152051616.events_*`
where
_TABLE_SUFFIX BETWEEN '20210802' AND FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and event_name in ('first_open', 'session_start', 'view_item_list', 'view_item', 'add_to_cart', 'begin_checkout', 'ecommerce_purchase')
order by 3,4),

b as
(select user_pseudo_id,
id_session,
max(transaction_id) trans,
string_agg(event_name,">" order by rank) funnel
from a
group by 1,2)

select *
from b
where trans is not null