with a AS  (
select
PARSE_DATE('%Y%m%d', event_date) AS event_date,
user_pseudo_id
FROM `produkcja-mobile.analytics_152051616.events_*`
where _TABLE_SUFFIX BETWEEN '20200101' AND FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2),

b as (
select
user_pseudo_id,
event_date,
lag (event_date) over (partition by user_pseudo_id order by event_date) b_event_date
from a)

select
'30/60 dni' zakres_dni,
count(distinct user_pseudo_id) user
from b
where date_diff (event_date, b_event_date,day) >30 and date_diff (event_date, b_event_date,day) <60
group by 1

union all
select '30/90 dni' zakres_dni,
count(distinct user_pseudo_id) user
from b
where date_diff (event_date, b_event_date,day) >30 and date_diff (event_date, b_event_date,day) <90
group by 1

union all
select '30/120 dni'
zakres_dni,
count(distinct user_pseudo_id) user
from b
where date_diff (event_date, b_event_date,day) >30 and date_diff (event_date, b_event_date,day) <120
group by 1
order by 2