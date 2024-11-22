with prep as (
select
    event_date,
    PARSE_DATE('%Y%m%d', CAST(event_date AS STRING)) as true_date,
    user_pseudo_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_number') as session_number,
    max((select value.int_value from unnest(event_params) where key = 'engagement_time_msec')) as engagement_time_msec,
    format_date('%G',parse_date("%Y%m%d",event_date)) as year,
    format_date('%U',parse_date("%Y%m%d",event_date)) as week_of_the_year
from
    `produkcja-mobile.analytics_152051616.events_*`
where
_TABLE_SUFFIX BETWEEN
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

group by
    1,2,3,4,5)

select
    event_date,
    true_date,
    count(distinct case when session_number > 0 then user_pseudo_id else null end) all_user,
    count(distinct case when session_number = 1 then user_pseudo_id else null end) as new_users,
    count(distinct case when session_number > 1 then user_pseudo_id else null end) as returning_users,
    year,
    week_of_the_year
from
    prep
group by 1,2,6,7
order by 1 desc
limit 5