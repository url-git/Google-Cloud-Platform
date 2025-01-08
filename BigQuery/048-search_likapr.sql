with krok1 as (
select *, case when regexp_contains(page_location, r'(sort=)') = TRUE then 'sortowanie'
else 'wyszukiwanie' end type
from (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    (SELECT value.string_value FROM unnest(event_params) WHERE key = 'page_location') page_location,
    case when (SELECT value.string_value FROM unnest(event_params) WHERE key = 'search_term') is null
    then cast ((SELECT value.int_value FROM unnest(event_params) WHERE key = 'search_term') as string)
    else (SELECT value.string_value FROM unnest(event_params) WHERE key = 'search_term') end keywords,
    ifnull((SELECT value.string_value FROM unnest(event_params) WHERE key = 'content_group'), 'no data') content_group,
    cast ((SELECT value.int_value FROM unnest(event_params) WHERE key = 'searchFacetProposedCategory') as string) proposed_category,

from `empik-mobile-app.analytics_183670685.events_*`
where
    -- _table_suffix between '20210101' and '20220530'
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    and platform like 'WEB'
    and event_name = 'search'
group by 1,2,3,4,5,6,7,8,9)
where regexp_contains(page_location, r'(sort=)|(.*q=.*)|(.*rq=.*)|(.*nrq=.*)|(.*qa=.*)') = TRUE
),

krok2 as (
select * except(page_location)
from (

select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) month_of_year,
    case when device.category like 'desktop' then 'WEB'
    when device.category like 'mobile' then 'MOB'
    when device.category like 'tablet' then 'MOB'
    else 'WEB' end device,
    (SELECT value.string_value FROM unnest(event_params) WHERE key = 'page_location') page_location,
    (SELECT value.string_value FROM unnest(event_params) WHERE key = 'page_referrer') page_referrer,
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) id
from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'view_item'
    and platform = 'WEB'
    -- and _table_suffix between '20220101' and '20220505'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
)
where regexp_contains(page_referrer, r'(sort=)|(.*q=.*)|(.*rq=.*)|(.*nrq=.*)|(.*qa=.*)') = TRUE)

select
k1.true_date,
k1.week_of_year,
k1.month_of_year,
k1.device,
k1.type,
k1.keywords,
k1.content_group,
case when starts_with (k1.proposed_category, '51') then 'AGD'
WHEN STARTS_WITH (k1.proposed_category, "35") THEN "Audiobooki i Ebooki"
WHEN STARTS_WITH (k1.proposed_category, "39") THEN "Dom i ogród"
WHEN STARTS_WITH (k1.proposed_category, "42") THEN "Dziecko i mama"
WHEN STARTS_WITH (k1.proposed_category, "36") THEN "Elektronika"
WHEN STARTS_WITH (k1.proposed_category, "33") THEN "Filmy"
WHEN STARTS_WITH (k1.proposed_category, "34") THEN "Gry i programy"
WHEN STARTS_WITH (k1.proposed_category, "46") THEN "Kolekcje własne"
WHEN STARTS_WITH (k1.proposed_category, "31") THEN "Książki"
WHEN STARTS_WITH (k1.proposed_category, "43") THEN "Moda"
WHEN STARTS_WITH (k1.proposed_category, "32") THEN "Muzyka"
WHEN STARTS_WITH (k1.proposed_category, "20") THEN "Obcojęzyczne"
WHEN STARTS_WITH (k1.proposed_category, "44") THEN "Prasa"
WHEN STARTS_WITH (k1.proposed_category, "45") THEN "Przyjęcia i okazje"
WHEN STARTS_WITH (k1.proposed_category, "41") THEN "Sport"
WHEN STARTS_WITH (k1.proposed_category, "40") THEN "Szkolne i papiernicze"
WHEN STARTS_WITH (k1.proposed_category, "37") THEN "Zabawki"
WHEN STARTS_WITH (k1.proposed_category, "38") THEN "Zdrowie i uroda"
WHEN STARTS_WITH (k1.proposed_category, "48") THEN "Motoryzacja"
WHEN STARTS_WITH (k1.proposed_category, "undefined") THEN "--Bez wybranej branży--"
else "Niezmapowane kategorie" end proposed_category,
'search listing => karta produktu' type_funnel,
count(distinct k1.id) search,
count(distinct k2.id) conversion,

from krok1 k1 left join krok2 k2 on k1.true_date=k2.true_date and k1.device=k2.device and k1.id=k2.id and k1.page_location=k2.page_referrer

group by 1,2,3,4,5,6,7,8,9