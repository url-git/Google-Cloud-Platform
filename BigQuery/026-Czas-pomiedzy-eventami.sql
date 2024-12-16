
with a AS (
Select
event_date,
user_pseudo_id user_a,
(select value.int_value from unnest(event_params) where key = 'ga_session_id') session_a
FROM `produkcja-mobile.analytics_152051616.events_*`
# FROM `mod-mobile-app-production.analytics_212969813.events_*`
where _TABLE_SUFFIX BETWEEN '20200101' AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and event_name like 'add_to_cart'
group by 1,2,3),

b AS
(Select
user_pseudo_id user_b,
(select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_b
FROM `produkcja-mobile.analytics_152051616.events_*`
# FROM `mod-mobile-app-production.analytics_212969813.events_*`
where _TABLE_SUFFIX BETWEEN '20200101' AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and event_name like 'ecommerce_purchase'),

# Tworzę kolumnę "purchase" gdzie jeśli jest null czyli jest tylko addtocart, ale brak purchase to daj 1
c as (select *,
case when user_b is null then 1 else 0 END as nope_purchase
from a
left join b on a.user_a=b.user_b and a.session_a=b.session_b)

select
PARSE_DATE('%Y%m%d', event_date) event_date,
round(sum(nope_purchase) / count (nope_purchase) * 100,2) bez_transakcja_procent,
sum(nope_purchase) bez_transakcja,

round(100-sum(nope_purchase) / count(nope_purchase)*100,2) z_transakcja_procent,
count(nope_purchase) - sum(nope_purchase) z_transakcja
from c
group by 1
order by 1 asc
LIMIT 5