select *

from (

select * except(id, purchase_revenue, transaction_id, row_num, max_popular, min_popular, purchase_revenue_keywords, purchase_transaction_keywords, row_num2)

from (

select *,
purchase_revenue / max_popular purchase_revenue_keywords,
min_popular / max_popular purchase_transaction_keywords,
purchase_revenue / max_popular2 purchase_revenue_keywords2,
min_popular / max_popular2 purchase_transaction_keywords2,
from (


select *,
LAST_VALUE(row_num) OVER (partition by id ORDER BY id) AS max_popular,
FIRST_VALUE(row_num) OVER (partition by id ORDER BY id) AS min_popular,
LAST_VALUE(row_num2) OVER (partition by id ORDER BY id) AS max_popular2,
FIRST_VALUE(row_num2) OVER (partition by id ORDER BY id) AS min_popular2


from (

with search_keywords as (
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
    ifnull(traffic_source.source,'(not set)') tsource,
    ifnull(traffic_source.medium,'(not set)') medium,
    case when (SELECT value.string_value FROM unnest(event_params) WHERE key = 'search_term') is null
    then cast ((SELECT value.int_value FROM unnest(event_params) WHERE key = 'search_term') as string)
    else (SELECT value.string_value FROM unnest(event_params) WHERE key = 'search_term') end keywords,
    ifnull((SELECT value.string_value FROM unnest(event_params) WHERE key = 'content_group'), 'no data') content_group,
    cast ((SELECT value.int_value FROM unnest(event_params) WHERE key = 'searchFacetProposedCategory') as string) proposed_category,

    case when (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'logged') is null
    then (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'status')
    else (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'logged') end status, # logged = false / status = Zalogowany

    case when (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'subscription_logged') is null
    then (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'ep')
    else (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'subscription_logged') end ep, # subscription_logged = false / ep = true

    case when (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'me_logged') is null
    then (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'me')
    else (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'me_logged') end me, # me_logged = false / me = true
    count(*) cnt_search

from `empik-mobile-app.analytics_183670685.events_*`
where
    -- _table_suffix between '20210101' and '20220530'
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    and platform like 'WEB'
    and event_name = 'search'
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14),

ecommerce_web as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'desktop' and platform like 'WEB' then 'WEB'
    when device.category like 'mobile' and platform like 'WEB' then 'MOB'
    when device.category like 'tablet' and platform like 'WEB' then 'MOB'
    else 'WEB' end device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    ifnull(traffic_source.source,'(not set)') tsource,
    ifnull(traffic_source.medium,'(not set)') medium,

    case when (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'logged') is null
    then (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'status')
    else (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'logged') end status, # logged = false / status = Zalogowany

    case when (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'subscription_logged') is null
    then (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'ep')
    else (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'subscription_logged') end ep, # subscription_logged = false / ep = true

    case when (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'me_logged') is null
    then (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'me')
    else (SELECT value.string_value FROM unnest(user_properties) WHERE key = 'me_logged') end me, # me_logged = false / me = true
    ecommerce.purchase_revenue,
    ecommerce.transaction_id,
    count(distinct ecommerce.transaction_id) purchase

from `empik-mobile-app.analytics_183670685.events_*`
where
    -- _table_suffix between '20210101' and '20220530'
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    and event_name like 'purchase'
    and platform like 'WEB'
group by 1,2,3,4,5,6,7,8,9,10,11,12
)

select
s.true_date,
s.week_of_year,
s.month_of_year,
s.device,
concat(s.tsource, ' / ', s.medium) source_medium,
function_us.channel_grouping_ga4_AWA51 (s.tsource, s.medium, null) as channel_grouping,
s.keywords,
s.content_group,
s.cnt_search,
case when s.status in ('Zalogowany', 'true') then 'true' when s.status in ('Niezalogowany', 'false') then 'false' else 'no data' end czy_zalogowany,
case when s.ep = 'true' then 'EP' when s.me = 'true' and s.ep = 'false' then 'EPF' else 'ecom' end subscription,
case when starts_with (proposed_category, '51') then 'AGD'
WHEN STARTS_WITH (proposed_category, "35") THEN "Audiobooki i Ebooki"
WHEN STARTS_WITH (proposed_category, "39") THEN "Dom i ogród"
WHEN STARTS_WITH (proposed_category, "42") THEN "Dziecko i mama"
WHEN STARTS_WITH (proposed_category, "36") THEN "Elektronika"
WHEN STARTS_WITH (proposed_category, "33") THEN "Filmy"
WHEN STARTS_WITH (proposed_category, "34") THEN "Gry i programy"
WHEN STARTS_WITH (proposed_category, "46") THEN "Kolekcje własne"
WHEN STARTS_WITH (proposed_category, "31") THEN "Książki"
WHEN STARTS_WITH (proposed_category, "43") THEN "Moda"
WHEN STARTS_WITH (proposed_category, "32") THEN "Muzyka"
WHEN STARTS_WITH (proposed_category, "20") THEN "Obcojęzyczne"
WHEN STARTS_WITH (proposed_category, "44") THEN "Prasa"
WHEN STARTS_WITH (proposed_category, "45") THEN "Przyjęcia i okazje"
WHEN STARTS_WITH (proposed_category, "41") THEN "Sport"
WHEN STARTS_WITH (proposed_category, "40") THEN "Szkolne i papiernicze"
WHEN STARTS_WITH (proposed_category, "37") THEN "Zabawki"
WHEN STARTS_WITH (proposed_category, "38") THEN "Zdrowie i uroda"
WHEN STARTS_WITH (proposed_category, "48") THEN "Motoryzacja"
WHEN STARTS_WITH (proposed_category, "undefined") THEN "--Bez wybranej branży--"
else "Niezmapowane kategorie" end proposed_category,
s.id,
e.purchase_revenue,
e.transaction_id,
ROW_NUMBER () OVER (partition by e.transaction_id ORDER BY e.transaction_id) AS row_num,
case when purchase_revenue is null then null else ROW_NUMBER () OVER (partition by e.transaction_id ORDER BY e.transaction_id) end row_num2


from search_keywords s
left join ecommerce_web e on s.true_date=e.true_date and s.device=e.device and s.id=e.id
and s.tsource=e.tsource and s.medium=e.medium
where
regexp_contains(page_location, r'qtype=facetForm') = FALSE )
where keywords is not null))

union all

select * except(id, purchase_revenue, transaction_id, row_num, max_popular, min_popular, purchase_revenue_keywords, purchase_transaction_keywords, row_num2)

from (

select *,
purchase_revenue / max_popular purchase_revenue_keywords,
min_popular / max_popular purchase_transaction_keywords,
purchase_revenue / max_popular2 purchase_revenue_keywords2,
min_popular / max_popular2 purchase_transaction_keywords2,

from (

select *,
LAST_VALUE(row_num) OVER (partition by id ORDER BY id) AS max_popular,
FIRST_VALUE(row_num) OVER (partition by id ORDER BY id) AS min_popular,
LAST_VALUE(row_num2) OVER (partition by id ORDER BY id) AS max_popular2,
FIRST_VALUE(row_num2) OVER (partition by id ORDER BY id) AS min_popular2


from (

with search_keywords as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    'APP' device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    ifnull(traffic_source.source,'(not set)') tsource,
    ifnull(traffic_source.medium,'(not set)') medium,
    case when (SELECT value.string_value FROM unnest(event_params) WHERE key = 'search_term') is null
    then cast ((SELECT value.int_value FROM unnest(event_params) WHERE key = 'search_term') as string)
    else (SELECT value.string_value FROM unnest(event_params) WHERE key = 'search_term') end keywords,
    ifnull((SELECT value.string_value FROM unnest(event_params) WHERE key = 'content_group'), 'no data') content_group,
    'Brak danych' proposed_category,
    ifnull(max((SELECT value.string_value FROM unnest(user_properties) WHERE key = 'logged')), 'no data') status,
    ifnull(max((SELECT value.string_value FROM unnest(user_properties) WHERE key = 'me_logged')), 'no data') me,
    ifnull(max((SELECT value.string_value FROM unnest(user_properties) WHERE key = 'subscription_logged')), 'no data') ep,
    count(*) cnt_search

from `empik-mobile-app.analytics_183670685.events_*`
where
    -- _table_suffix between '20210101' and '20220530'
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    and platform <> 'WEB'
    and event_name in ('search')
group by 1,2,3,4,5,6,7,8,9,10),

ecommerce_web as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    'APP' device,
    concat(user_pseudo_id,(select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    ifnull(traffic_source.source,'(not set)') tsource,
    ifnull(traffic_source.medium,'(not set)') medium,
    ifnull(max((SELECT value.string_value FROM unnest(user_properties) WHERE key = 'logged')), 'no data') status,
    ifnull(max((SELECT value.string_value FROM unnest(user_properties) WHERE key = 'me_logged')), 'no data') me,
    ifnull(max((SELECT value.string_value FROM unnest(user_properties) WHERE key = 'subscription_logged')), 'no data') ep,
    case when (select value.double_value from unnest(event_params) where key = "value") is null
    then (select value.int_value from unnest(event_params) where key = "value")
    else (select value.double_value from unnest(event_params) where key = "value") end purchase_revenue,
    (SELECT value.string_value FROM unnest(event_params) WHERE key = 'order_id') transaction_id,
    count(distinct (SELECT value.string_value FROM unnest(event_params) WHERE key = 'order_id')) purchase

from `empik-mobile-app.analytics_183670685.events_*`
where
    -- _table_suffix between '20210101' and '20220530'
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    and platform <> 'WEB'
    and event_name in ('purchase', 'ecommerce_purchase')
group by 1,2,3,4,5,6,7,11,12
)

select
s.true_date,
s.week_of_year,
s.month_of_year,
s.device,
concat(s.tsource, ' / ', s.medium) source_medium,
function_us.channel_grouping_ga4_AWA51 (s.tsource, s.medium, null) as channel_grouping,
s.keywords,
s.content_group,
s.cnt_search,
case when s.status = '1' then 'true' when s.status = '0' then 'false' else 'false' end czy_zalogowany,
case when s.ep = '1' then 'EP' when s.me = '1' and s.ep = '0' then 'EPF' else 'ecom' end subscription,
proposed_category,
s.id,
e.purchase_revenue,
e.transaction_id,
ROW_NUMBER () OVER (partition by e.transaction_id ORDER BY e.transaction_id) AS row_num,
case when purchase_revenue is null then null else ROW_NUMBER () OVER (partition by e.transaction_id ORDER BY e.transaction_id) end row_num2

from search_keywords s
left join ecommerce_web e on s.true_date=e.true_date and s.device=e.device and s.id=e.id
and s.tsource=e.tsource and s.medium=e.medium and s.status=e.status and s.ep=e.ep and s.me=e.me))
where keywords is not null)
)

order by 1 desc