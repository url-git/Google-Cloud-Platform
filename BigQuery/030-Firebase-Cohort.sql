with prep as (
select
    user_pseudo_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_number') as session_number,
    parse_date('%Y%m%d',event_date) as session_date,
    first_value(parse_date('%Y%m%d',event_date)) over (partition by user_pseudo_id order by event_date) as first_session_date
from
     `produkcja-mobile.analytics_152051616.events_*`
where
    _table_suffix between format_date('%Y%m%d',date_sub(current_date(), interval 100 day)) and format_date('%Y%m%d',date_sub(current_date(), interval 1 day))
group by
    user_pseudo_id,
    session_id,
    session_number,
    event_date
order by
    user_pseudo_id,
    session_id,
    session_number)

select
    distinct concat(extract(isoyear from first_session_date),'-',format('%02d',extract(isoweek from first_session_date))) as year_week,
    count(distinct case when date_diff(session_date, first_session_date, isoweek) = 0 and session_number >= 1 then user_pseudo_id end) as week_0,
    count(distinct case when date_diff(session_date, first_session_date, isoweek) = 1 and session_number > 1 then user_pseudo_id end) as week_1,
    count(distinct case when date_diff(session_date, first_session_date, isoweek) = 2 and session_number > 1 then user_pseudo_id end) as week_2,
    count(distinct case when date_diff(session_date, first_session_date, isoweek) = 3 and session_number > 1 then user_pseudo_id end) as week_3,
    count(distinct case when date_diff(session_date, first_session_date, isoweek) = 4 and session_number > 1 then user_pseudo_id end) as week_4,
    count(distinct case when date_diff(session_date, first_session_date, isoweek) = 5 and session_number > 1 then user_pseudo_id end) as week_5
from
    prep
group by
    year_week
order by
   year_week asc
limit 10