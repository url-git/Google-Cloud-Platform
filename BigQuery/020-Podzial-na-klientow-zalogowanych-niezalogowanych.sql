with zalogowani as (
Select format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
event_name, user_pseudo_id,
(select user_properties.value.string_value from unnest(user_properties) as user_properties where user_properties.key='user_id') as user_id
FROM `produkcja-mobile.analytics_152051616.events_*`
where _TABLE_SUFFIX BETWEEN '20200101' AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and
user_id is not null),

rob_zal as (select month_of_year, count (distinct user_pseudo_id) zalogowani
from zalogowani
group by 1
order by 1,2),

all_users as (
Select format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
count (distinct user_pseudo_id) wszyscy,
FROM `produkcja-mobile.analytics_152051616.events_*`
where _TABLE_SUFFIX BETWEEN '20200101' AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1),

niezalogowani as (
Select format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
event_name, user_pseudo_id,
(select user_properties.value.string_value from unnest(user_properties) as user_properties where user_properties.key='user_id') as user_id
FROM `produkcja-mobile.analytics_152051616.events_*`
where _TABLE_SUFFIX BETWEEN '20200101' AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and
user_id is null)

select niezalogowani.month_of_year, count(distinct user_pseudo_id) niezalogowani, rob_zal.zalogowani zalogowani,
rob_zal.zalogowani / count(distinct user_pseudo_id) ratio, all_users.wszyscy
from niezalogowani
left join rob_zal on niezalogowani.month_of_year=rob_zal.month_of_year
left join all_users on all_users.month_of_year=rob_zal.month_of_year
group by 1,3,5
order by 1 desc
LIMIT 4