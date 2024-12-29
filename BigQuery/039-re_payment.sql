with lp as (
select *
from (
select
    event_date, week_of_year, month_of_year, user_pseudo_id, session_id, concat(user_pseudo_id, session_id) id,
    case when REGEXP_CONTAINS(page_location, r'(https://www.empik.com/twoje-konto/zamowienie/platnosc.*)') = TRUE then 'old'
    when REGEXP_CONTAINS(page_location, r'(https://www.empik.com/zamowienia/platnosc/.*)') = TRUE then 'new' end form

from (
select
    event_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    user_pseudo_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
    (select value.string_value from unnest(event_params) where key = 'page_location') page_location

from
    `empik-mobile-app.analytics_183670685.events_20220124`
)) where form is not null
),

re_payment1 as (
select
    event_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    user_pseudo_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
    concat(user_pseudo_id, (select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    (select value.string_value from unnest(event_params) where key = 'payment_method') payment_method,
    (select value.string_value from unnest(event_params) where key = 'form') form

from
    `empik-mobile-app.analytics_183670685.events_20220124`
where
    event_name = 're_payment1'
),

re_payment2 as (
select
    event_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    user_pseudo_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
    concat(user_pseudo_id, (select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    (select value.string_value from unnest(event_params) where key = 'payment_method') payment_method,
    (select value.string_value from unnest(event_params) where key = 'form') form

from
    `empik-mobile-app.analytics_183670685.events_20220124`
where
    event_name = 're_payment2'
),

re_payment3 as (
select
    event_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    user_pseudo_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
    concat(user_pseudo_id, (select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    (select value.string_value from unnest(event_params) where key = 'payment_method') payment_method,
    (select value.string_value from unnest(event_params) where key = 'form') form

from
    `empik-mobile-app.analytics_183670685.events_20220124`
where
    event_name = 're_payment3'
)

select
    lp.event_date, lp.week_of_year, lp.month_of_year, lp.form lp_form, r1.form form_step1,
    r1.payment_method payment_method_step1,
    count (distinct lp.id) sessions_lp,
    count (distinct r1.id) sessions_step1,
    count (distinct r2.id) sessions_step2,
    count (distinct r3.id) sessions_step3,
from lp left join re_payment1 r1 on lp.event_date=r1.event_date and lp.id=r1.id
left join re_payment2 r2 on r1.event_date=r2.event_date and r1.id=r2.id
left join re_payment3 r3 on r2.event_date=r3.event_date and r2.id=r3.id

group by 1,2,3,4,5,6