with a AS
(select
    PARSE_DATE('%Y%m%d', event_date) AS a_event_date,
    user_pseudo_id as a_user,
    event_timestamp,
    (select event_params.value.int_value from unnest(event_params) as event_params where event_params.key='ga_session_id') as a_id_session,
    geo.country a_country
FROM `produkcja-mobile.analytics_152051616.events_*`
where _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY)) and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and
event_name like 'esizme_2D_scan_screen_success'
),

b AS
(select
    PARSE_DATE('%Y%m%d', event_date) AS b_event_date,
    user_pseudo_id,
    event_value_in_usd AS revenue_usd,
    (select event_params.value.string_value from unnest(event_params) as event_params where event_params.key='transaction_id') AS transaction_id,
    (select event_params.value.string_value from unnest(event_params) as event_params where event_params.key='currency') AS local_currency,
    (select event_params.value.double_value from unnest(event_params) as event_params where event_params.key='value') AS local_revenue,
    (select event_params.value.int_value from unnest(event_params) as event_params where event_params.key='ga_session_id') as b_id_session,
    geo.country b_country
FROM `produkcja-mobile.analytics_152051616.events_*`
where _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY)) and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and
event_name like 'ecommerce_purchase'
),

c AS (
select
    PARSE_DATE('%Y%m%d', event_date) AS c_event_date,
    geo.country c_country,
    count (distinct user_pseudo_id) as c_users,
    sum(event_value_in_usd) AS Przychod_All,
    count(distinct(select event_params.value.int_value from unnest(event_params) as event_params where event_params.key='ga_session_id')) as c_id_session
FROM `produkcja-mobile.analytics_152051616.events_*`
where _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY)) and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2
),

d as (
select *
from a left join b on a.a_user = b.user_pseudo_id
and a.a_id_session=b.b_id_session and a.a_country=b.b_country),


e as (
select
b_event_date,
b_country,
count (distinct transaction_id) AS e_transaction
from b
group by 1,2)

select
a_event_date date,
a_country kraj,
uzytkownicy_skan2D,
c_users uzytkownicyAll,
round(Przychod_USD * Close,2) Przychod_skan2D,
round(Przychod_All * Close,2) AS Przychod_All,
round(CR_skan2D,2) CR_skan,
round(e_transaction / c_id_session,2) AS CR_All

from (select a_event_date, a_country, count(distinct a_user) AS uzytkownicy_skan2D, count(*) AS liczba_skan, sum(revenue_usd) AS Przychod_USD,
count (distinct transaction_id) / count (distinct a_id_session) AS CR_skan2D
from d
group by 1,2) AS t1
left join c
on t1.a_event_date=c.c_event_date
and t1.a_country = c.c_country
left join e on t1.a_event_date = e.b_event_date
and t1.a_country = e.b_country
left join  (select * from `elevated-honor-235814.currency_exchange_rates_US.usd_pln`) kursy
on t1.a_event_date = kursy.date
# where a_country in ('Poland', 'Germany')
order by 1