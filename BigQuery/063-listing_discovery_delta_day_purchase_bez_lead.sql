select *, function_eu.channel_grouping_ga3_AWA91 (tsource, medium, null) as channel_grouping

from (

select
true_date,
iso_week_of_year,
month_of_year,
miejsce_dodania_prod,
device,
source_listing tsource,
medium_listing medium,
userType,
status,
subscription,
cnt_listing u_listing,
cnt_add u_addtocart,
cnt_purchase u_purchase

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
    IF(totals.newVisits IS NOT NULL, "New Visitor", "Returning Visitor") userType,
    case when (SELECT value FROM hits.customDimensions WHERE index=51) in ('Zalogowany') then true else false end status,
    case when (SELECT value FROM hits.customDimensions WHERE index=22) in ('true') then 'EP'
    when ((SELECT value FROM hits.customDimensions WHERE index=2) in ('true') AND (SELECT value FROM hits.customDimensions WHERE index=22) in ('false')) then 'EPF'
    else 'other' end subscription,
    case when REGEXP_CONTAINS(page.pagePath, r'(.*q=.*)|(.*fromSearchQuery=.*)|(.*rq=.*)|(.*nrq=.*)|(.*qa=.*)')  = TRUE then 'Wyniki wyszukiwania'
    else 'MENU & TOP kategorie' end miejsce_dodania_prod


FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits
WHERE
    _table_suffix between '20210101' and '20220512'
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
    IF(totals.newVisits IS NOT NULL, "New Visitor", "Returning Visitor") userType,
    case when (SELECT value FROM hits.customDimensions WHERE index=51) in ('Zalogowany') then true else false end status,
    case when (SELECT value FROM hits.customDimensions WHERE index=22) in ('true') then 'EP'
    when ((SELECT value FROM hits.customDimensions WHERE index=2) in ('true') AND (SELECT value FROM hits.customDimensions WHERE index=22) in ('false')) then 'EPF'
    else 'other' end subscription,
    case when REGEXP_CONTAINS(page.pagePath, r'(.*q=.*)|(.*fromSearchQuery=.*)|(.*rq=.*)|(.*nrq=.*)|(.*qa=.*)')  = TRUE then 'Wyniki wyszukiwania'
    else 'MENU & TOP kategorie' end miejsce_dodania_prod


FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
    _table_suffix between '20210101' and '20220512'
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
    IF(totals.newVisits IS NOT NULL, "New Visitor", "Returning Visitor") userType,
    case when (SELECT value FROM hits.customDimensions WHERE index=51) in ('Zalogowany') then true else false end status,
    case when (SELECT value FROM hits.customDimensions WHERE index=22) in ('true') then 'EP'
    when ((SELECT value FROM hits.customDimensions WHERE index=2) in ('true') AND (SELECT value FROM hits.customDimensions WHERE index=22) in ('false')) then 'EPF'
    else 'other' end subscription

FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits
WHERE
    _table_suffix between '20210101' and '20220512'
    -- _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    and eventInfo.eventCategory = 'Ecommerce'
    and eventInfo.eventAction = 'Purchase'
)

select
l.true_date,
l.iso_week_of_year,
l.month_of_year,
l.device,
l.userType,
l.status,
l.subscription,
l.miejsce_dodania_prod,
l.source source_listing,
l.medium medium_listing,
count (distinct l.id) cnt_listing,
count (distinct a.id) cnt_add,
count (distinct p.id) cnt_purchase

from listing l
left join add_to_cart a on l.true_date=a.true_date and l.id=a.id and l.device=a.device and l.userType=a.userType and l.status=a.status and l.subscription=a.subscription
and l.miejsce_dodania_prod=a.miejsce_dodania_prod and l.source=a.source and l.medium=a.medium

left join purchase p on a.true_date=p.true_date and a.id=p.id and a.device=p.device and a.userType=p.userType and a.status=p.status and a.subscription=p.subscription
and a.source=p.source and a.medium=p.medium
group by 1,2,3,4,5,6,7,8,9,10
))
order by true_date desc