select

true_date,
week_of_year,
month_of_year,
miejsce_dodania_prod,
device,
userType,
status,
subscription,
category,
totalEvents_listing,
prev7_totalEvents_listing,
uniqueEvents_listing,
prev7_uniqueEvents_listing,
totalEvents_addtocart,
prev7_totalEvents_addtocart,
uniqueEvents_addtocart,
prev7_uniqueEvents_addtocart


from (
select
true_date,
week_of_year,
month_of_year,
id_listing,
id_add,
miejsce_dodania_prod,
device,
userType,
status,
subscription,
category,
totalEvents_listing,
lead(totalEvents_listing, 7) over (partition by device, miejsce_dodania_prod, userType, status, subscription, category, id_listing order by true_date desc) prev7_totalEvents_listing,
uniqueEvents_listing,
lead(uniqueEvents_listing, 7) over (partition by device, miejsce_dodania_prod, userType, status, subscription, category, id_listing order by true_date desc) prev7_uniqueEvents_listing,
totalEvents_addtocart,
lead(totalEvents_addtocart, 7) over (partition by device, miejsce_dodania_prod, userType, status, subscription, category, id_listing order by true_date desc) prev7_totalEvents_addtocart,
uniqueEvents_addtocart,
lead(uniqueEvents_addtocart, 7) over (partition by device, miejsce_dodania_prod, userType, status, subscription, category, id_listing order by true_date desc) prev7_uniqueEvents_addtocart,


from (

with listing as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    IF(totals.newVisits IS NOT NULL, "New Visitor", "Returning Visitor") userType,
    case when (SELECT value FROM hits.customDimensions WHERE index=51) in ('Zalogowany') then true else false end status,
    case when (SELECT value FROM hits.customDimensions WHERE index=22) in ('true') then 'EP'
    when ((SELECT value FROM hits.customDimensions WHERE index=2) in ('true') AND (SELECT value FROM hits.customDimensions WHERE index=22) in ('false')) then 'EPF'
    else 'other' end subscription,
    COUNT(hits.eventInfo.eventCategory) totalEvents,
    COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
    COALESCE(hits.eventInfo.eventAction,''),
    COALESCE(hits.eventInfo.eventLabel, ''),
    COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents

FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits
WHERE
    _table_suffix between '20220208' and '20220208'
    -- _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    and eventInfo.eventCategory = 'Ecommerce'
    and eventInfo.eventAction = 'Impression View'
group by 1,2,3,4,5,6,7,8
),

add_to_cart as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    IF(totals.newVisits IS NOT NULL, "New Visitor", "Returning Visitor") userType,
    case when (SELECT value FROM hits.customDimensions WHERE index=51) in ('Zalogowany') then true else false end status,
    case when (SELECT value FROM hits.customDimensions WHERE index=22) in ('true') then 'EP'
    when ((SELECT value FROM hits.customDimensions WHERE index=2) in ('true') AND (SELECT value FROM hits.customDimensions WHERE index=22) in ('false')) then 'EPF'
    else 'other' end subscription,
    split(v2ProductCategory, '/')[safe_offset(0)] as category,
    case when REGEXP_CONTAINS(eventInfo.eventLabel, r'^Kategoria - (Nowości|TOP 100|Zapowiedzi).*') = TRUE then 'TOP kategorie'
    when REGEXP_CONTAINS(eventInfo.eventLabel, r'^Kategoria.*') = TRUE then 'MENU kategorie'
    when REGEXP_CONTAINS(eventInfo.eventLabel, r'^Wyniki wyszukiwania.*') = TRUE then 'Wyniki wyszukiwania'
    else 'other' end miejsce_dodania_prod,
    COUNT(hits.eventInfo.eventCategory) totalEvents,
    COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
    COALESCE(hits.eventInfo.eventAction,''),
    COALESCE(hits.eventInfo.eventLabel, ''),
    COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents

FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
    _table_suffix between '20220208' and '20220208'
    -- _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    and eventInfo.eventCategory = 'Ecommerce'
    and eventInfo.eventAction = 'Add to Cart'
    and (REGEXP_CONTAINS(eventInfo.eventLabel, r'^Kategoria - (Nowości|TOP 100|Zapowiedzi).*') = TRUE or
    REGEXP_CONTAINS(eventInfo.eventLabel, r'^Kategoria.*') = TRUE or REGEXP_CONTAINS(eventInfo.eventLabel, r'^Wyniki wyszukiwania.*') = TRUE)
group by 1,2,3,4,5,6,7,8,9,10
)

select
l.true_date,
l.week_of_year,
l.month_of_year,
l.device,
l.userType,
l.status,
l.subscription,
a.category,
l.id id_listing,
a.id id_add,
a.miejsce_dodania_prod,
l.totalEvents totalEvents_listing,
l.uniqueEvents uniqueEvents_listing,
a.totalEvents totalEvents_addtocart,
a.uniqueEvents uniqueEvents_addtocart,

from listing l left join add_to_cart a on l.true_date=a.true_date and l.id=a.id and l.device=a.device and l.userType=a.userType
and l.status=a.status and l.subscription=a.subscription
))

where id_add is not null
order by true_date desc

limit 5