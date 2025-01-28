select *, function_eu.channel_grouping_ga3_AWA91 (tsource, medium, null) as channel_grouping

from (

select
true_date,
iso_week_of_year,
month_of_year,
device,
miejsce_dodania_prod,
tsource,
medium,
userType,
status,
subscription,
karty_produktu,
category,
funnel,
cnt_listing_cart,
cnt_addtocart,
cnt_purchase

from (

with listing as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    concat(EXTRACT(ISOYEAR FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)) ), EXTRACT(ISOWEEK FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)))) iso_week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    trafficSource.source,
    trafficSource.medium,
    'Listing 🡆 addToCart 🡆 Purchase' funnel,
    'n/d' karty_produktu,
    'n/d' category,
    IF(totals.newVisits IS NOT NULL, "New Visitor", "Returning Visitor") userType,
    case when (SELECT value FROM hits.customDimensions WHERE index=51) in ('Zalogowany') then true else false end status,
    case when (SELECT value FROM hits.customDimensions WHERE index=22) in ('true') then 'EP'
    when ((SELECT value FROM hits.customDimensions WHERE index=2) in ('true') AND (SELECT value FROM hits.customDimensions WHERE index=22) in ('false')) then 'EPF'
    else 'other' end subscription,
    case when REGEXP_CONTAINS(page.pagePath, r'(.*q=.*)|(.*fromSearchQuery=.*)|(.*rq=.*)|(.*nrq=.*)|(.*qa=.*)')  = TRUE then 'Wyniki wyszukiwania'
    else 'MENU & TOP kategorie' end miejsce_dodania_prod


FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits
WHERE
    _table_suffix between '20220310' and '20220515'
    -- _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    and hits.contentGroup.contentGroup4 like 'Listingpage'
),

add_to_cart as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    concat(EXTRACT(ISOYEAR FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)) ), EXTRACT(ISOWEEK FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)))) iso_week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    trafficSource.source,
    trafficSource.medium,
    'n/d' karty_produktu,
    'Listing 🡆 addToCart 🡆 Purchase' funnel,
    'n/d' category,
    IF(totals.newVisits IS NOT NULL, "New Visitor", "Returning Visitor") userType,
    case when (SELECT value FROM hits.customDimensions WHERE index=51) in ('Zalogowany') then true else false end status,
    case when (SELECT value FROM hits.customDimensions WHERE index=22) in ('true') then 'EP'
    when ((SELECT value FROM hits.customDimensions WHERE index=2) in ('true') AND (SELECT value FROM hits.customDimensions WHERE index=22) in ('false')) then 'EPF'
    else 'other' end subscription,
    case when REGEXP_CONTAINS(page.pagePath, r'(.*q=.*)|(.*fromSearchQuery=.*)|(.*rq=.*)|(.*nrq=.*)|(.*qa=.*)')  = TRUE then 'Wyniki wyszukiwania'
    else 'MENU & TOP kategorie' end miejsce_dodania_prod


FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
    _table_suffix between '20220310' and '20220515'
    -- _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    and eventInfo.eventCategory = 'Ecommerce'
    and eventInfo.eventAction = 'Add to Cart'
    and (REGEXP_CONTAINS(eventInfo.eventLabel, r'^Kategoria - (Nowości|TOP 100|Zapowiedzi).*') = TRUE or
    REGEXP_CONTAINS(eventInfo.eventLabel, r'^Kategoria.*') = TRUE or REGEXP_CONTAINS(eventInfo.eventLabel, r'^Wyniki wyszukiwania.*') = TRUE)
),


purchase as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    concat(EXTRACT(ISOYEAR FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)) ), EXTRACT(ISOWEEK FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)))) iso_week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    trafficSource.source,
    trafficSource.medium,
    'Listing 🡆 addToCart 🡆 Purchase' funnel,
    'n/d' karty_produktu,
    'n/d' category,
    IF(totals.newVisits IS NOT NULL, "New Visitor", "Returning Visitor") userType,
    case when (SELECT value FROM hits.customDimensions WHERE index=51) in ('Zalogowany') then true else false end status,
    case when (SELECT value FROM hits.customDimensions WHERE index=22) in ('true') then 'EP'
    when ((SELECT value FROM hits.customDimensions WHERE index=2) in ('true') AND (SELECT value FROM hits.customDimensions WHERE index=22) in ('false')) then 'EPF'
    else 'other' end subscription

FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits
WHERE
    _table_suffix between '20220310' and '20220515'
    -- _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    and eventInfo.eventCategory = 'Ecommerce'
    and eventInfo.eventAction = 'Purchase'
)

select
l.true_date,
l.iso_week_of_year,
l.month_of_year,
l.device,
l.funnel,
l.miejsce_dodania_prod,
l.source tsource,
l.medium medium,
l.userType,
l.status,
l.subscription,
l.karty_produktu,
l.category,
count (distinct l.id) cnt_listing_cart,
count (distinct a.id) cnt_addtocart,
count (distinct p.id) cnt_purchase

from listing l
left join add_to_cart a on l.true_date=a.true_date and l.id=a.id and l.device=a.device and l.userType=a.userType and l.status=a.status and l.subscription=a.subscription
and l.miejsce_dodania_prod=a.miejsce_dodania_prod and l.source=a.source and l.medium=a.medium

left join purchase p on a.true_date=p.true_date and a.id=p.id and a.device=p.device and a.userType=p.userType and a.status=p.status and a.subscription=p.subscription
and a.source=p.source and a.medium=p.medium
group by 1,2,3,4,5,6,7,8,9,10,11,12,13)


union all

select
true_date,
iso_week_of_year,
month_of_year,
device,
miejsce_dodania_prod,
tsource,
medium,
userType,
status,
subscription,
karty_produktu,
category,
funnel,
cnt_listing_cart,
cnt_addtocart,
cnt_purchase

from (

with cart as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    concat(EXTRACT(ISOYEAR FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)) ), EXTRACT(ISOWEEK FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)))) iso_week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    'n/d' miejsce_dodania_prod,
    trafficSource.source,
    trafficSource.medium,
    'Cart 🡆 addToCart 🡆 Purchase' funnel,
    IF(totals.newVisits IS NOT NULL, "New Visitor", "Returning Visitor") userType,
    case when (SELECT value FROM hits.customDimensions WHERE index=51) in ('Zalogowany') then true else false end status,
    case when (SELECT value FROM hits.customDimensions WHERE index=22) in ('true') then 'EP'
    when ((SELECT value FROM hits.customDimensions WHERE index=2) in ('true') AND (SELECT value FROM hits.customDimensions WHERE index=22) in ('false')) then 'EPF'
    else 'other' end subscription,
    split(split(page.pagePath, ',')[safe_offset(2)], '-')[safe_offset(0)] category,
    case when max((SELECT value FROM hits.customDimensions WHERE index=102)) like 'oldDesktop' then 'Karta produktu stary desktop'
    when max((SELECT value FROM hits.customDimensions WHERE index=102)) like 'mobile' then 'Karta m-site'
    when max((SELECT value FROM hits.customDimensions WHERE index=102)) like 'newDesktop' then 'Karta produktu nowy desktop' else 'other' end karty_produktu

FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits
WHERE
    _table_suffix between '20220310' and '20220515'
    -- _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    and REGEXP_CONTAINS(hits.contentGroup.contentGroup4, r'(Productpage)|(ProductPage)')

group by 1,2,3,4,5,6,7,8,9,10,11,12,13
),

add_to_cart as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    concat(EXTRACT(ISOYEAR FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)) ), EXTRACT(ISOWEEK FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)))) iso_week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    'n/d' miejsce_dodania_prod,
    trafficSource.source,
    trafficSource.medium,
    'Cart 🡆 addToCart 🡆 Purchase' funnel,
    IF(totals.newVisits IS NOT NULL, "New Visitor", "Returning Visitor") userType,
    case when (SELECT value FROM hits.customDimensions WHERE index=51) in ('Zalogowany') then true else false end status,
    case when (SELECT value FROM hits.customDimensions WHERE index=22) in ('true') then 'EP'
    when ((SELECT value FROM hits.customDimensions WHERE index=2) in ('true') AND (SELECT value FROM hits.customDimensions WHERE index=22) in ('false')) then 'EPF'
    else 'other' end subscription,
    split(split(page.pagePath, ',')[safe_offset(2)], '-')[safe_offset(0)] category,
    case when max((SELECT value FROM hits.customDimensions WHERE index=102)) like 'oldDesktop' then 'Karta produktu stary desktop'
    when max((SELECT value FROM hits.customDimensions WHERE index=102)) like 'mobile' then 'Karta m-site'
    when max((SELECT value FROM hits.customDimensions WHERE index=102)) like 'newDesktop' then 'Karta produktu nowy desktop' else 'other' end karty_produktu,

FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits
WHERE
    _table_suffix between '20220310' and '20220515'
    -- _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    and eventInfo.eventCategory = 'Ecommerce'
    and eventInfo.eventAction = 'Add to Cart'
    and eventInfo.eventLabel = 'karta produktu'
group by 1,2,3,4,5,6,7,8,9,10,11,12,13
),

purchase as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    concat(EXTRACT(ISOYEAR FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)) ), EXTRACT(ISOWEEK FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)))) iso_week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    'n/d' miejsce_dodania_prod,
    trafficSource.source,
    trafficSource.medium,
    'Cart 🡆 addToCart 🡆 Purchase' funnel,
    IF(totals.newVisits IS NOT NULL, "New Visitor", "Returning Visitor") userType,
    case when (SELECT value FROM hits.customDimensions WHERE index=51) in ('Zalogowany') then true else false end status,
    case when (SELECT value FROM hits.customDimensions WHERE index=22) in ('true') then 'EP'
    when ((SELECT value FROM hits.customDimensions WHERE index=2) in ('true') AND (SELECT value FROM hits.customDimensions WHERE index=22) in ('false')) then 'EPF'
    else 'other' end subscription

FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits
WHERE
    _table_suffix between '20220310' and '20220515'
    -- _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    and eventInfo.eventCategory = 'Ecommerce'
    and eventInfo.eventAction = 'Purchase'
)

select
c.true_date,
c.iso_week_of_year,
c.month_of_year,
c.device,
c.funnel,
c.miejsce_dodania_prod,
c.source tsource,
c.medium,
c.userType,
c.status,
c.subscription,
c.karty_produktu,
c.category,
count(distinct c.id) cnt_listing_cart,
count(distinct a.id) cnt_addtocart,
count(distinct p.id) cnt_purchase


from cart c left join add_to_cart a on c.true_date=a.true_date and c.device=a.device and c.userType=a.userType and c.id=a.id
and c.status=a.status and c.subscription=a.subscription and c.karty_produktu=a.karty_produktu and c.category=a.category and c.source=a.source and c.medium=a.medium

left join purchase p on a.true_date=p.true_date and a.device=p.device and a.userType=p.userType and a.id=p.id
and a.status=p.status and a.subscription=p.subscription and a.source=p.source and a.medium=p.medium

group by 1,2,3,4,5,6,7,8,9,10,11,12,13))
order by true_date desc