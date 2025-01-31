select * from (

-- banner_pod_tina

select * from (
with ep_banner_pod_tina as (
select
    PARSE_DATE('%Y%m%d',CAST(date AS STRING)) as true_date,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    case when device.deviceCategory like 'mobile' then 'MOB' else 'WEB' end device,
    'banner_pod_tina' source,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    fullVisitorId
FROM
    `empik-ga360.304756.ga_sessions_*`, UNNEST(hits) AS hits
WHERE
    eventInfo.eventCategory = 'Banner pod Tina'
    AND REGEXP_CONTAINS(eventInfo.eventAction, 'Click')
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
),

ep_zakup_abonamentu as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    case when device.deviceCategory like 'mobile' then 'MOB' else 'WEB' end device,
    'banner_pod_tina' source,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    fullVisitorId
FROM
    `empik-ga360.304756.ga_sessions_*`, UNNEST(hits) AS hits
WHERE
    eventInfo.eventCategory = 'Empik Premium'
    AND REGEXP_CONTAINS(eventInfo.eventAction, 'zakup abonamentu.*')
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
)

select
ep_t.true_date,
ep_t.week_of_year,
ep_t.month_of_year,
ep_t.device,
ep_t.source acquisition_source,
count (distinct ep_t.id) acquisition_count,
count (distinct ep_z.id) subscription_purchase

from ep_banner_pod_tina ep_t left join ep_zakup_abonamentu ep_z on ep_t.true_date=ep_z.true_date and ep_t.fullVisitorId=ep_z.fullVisitorId and ep_t.device=ep_z.device
group by 1,2,3,4,5)

union all

-- 'dropdown_menu'

select * from (
with ep_dropdown_menu as (
select
    PARSE_DATE('%Y%m%d',CAST(date AS STRING)) as true_date,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    case when device.deviceCategory like 'mobile' then 'MOB' else 'WEB' end device,
    'dropdown_menu' source,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    fullVisitorId
FROM
    `empik-ga360.304756.ga_sessions_*`, UNNEST(hits) AS hits
WHERE
    eventInfo.eventCategory = 'Empik Premium'
    AND REGEXP_CONTAINS(eventInfo.eventAction, 'Dropdown Menu')
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
),

ep_zakup_abonamentu as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    case when device.deviceCategory like 'mobile' then 'MOB' else 'WEB' end device,
    'dropdown_menu' source,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    fullVisitorId
FROM
    `empik-ga360.304756.ga_sessions_*`, UNNEST(hits) AS hits
WHERE
    eventInfo.eventCategory = 'Empik Premium'
    AND REGEXP_CONTAINS(eventInfo.eventAction, 'zakup abonamentu.*')
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
)

select
ep_d.true_date,
ep_d.week_of_year,
ep_d.month_of_year,
ep_d.device,
ep_d.source acquisition_source,
count (distinct ep_d.id) acquisition_count,
count (distinct ep_z.id) subscription_purchase

from ep_dropdown_menu ep_d left join ep_zakup_abonamentu ep_z on ep_d.true_date=ep_z.true_date and ep_d.fullVisitorId=ep_z.fullVisitorId and ep_d.device=ep_z.device
group by 1,2,3,4,5)

union all

-- 'header_top_menu'
select * from (
with ep_header_top_menu as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    case when device.deviceCategory like 'mobile' then 'MOB' else 'WEB' end device,
    'header_top_menu' source,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    fullVisitorId
FROM
    `empik-ga360.304756.ga_sessions_*`,
    UNNEST(hits) AS hits
WHERE
    eventInfo.eventCategory = 'Empik Premium'
    AND REGEXP_CONTAINS(eventInfo.eventAction, 'Header - Top Menu')
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
),

ep_zakup_abonamentu as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    case when device.deviceCategory like 'mobile' then 'MOB' else 'WEB' end device,
    'header_top_menu' source,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    fullVisitorId
FROM
    `empik-ga360.304756.ga_sessions_*`,
    UNNEST(hits) AS hits
WHERE
    eventInfo.eventCategory = 'Empik Premium'
    AND REGEXP_CONTAINS(eventInfo.eventAction, 'zakup abonamentu.*')
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
)

select
x.true_date,
x.week_of_year,
x.month_of_year,
x.device,
x.source acquisition_source,
count (distinct x.id) acquisition_count,
count (distinct y.id) subscription_purchase
from ep_header_top_menu x left join ep_zakup_abonamentu y on x.true_date=y.true_date and x.fullVisitorId=y.fullVisitorId and x.device=y.device
group by 1,2,3,4,5)

union all

-- 'akwizycyjny_url_premium'
select * from (
with premium as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    case when device.deviceCategory like 'mobile' then 'MOB' else 'WEB' end device,
    'akwizycyjny_url_premium' source,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    fullVisitorId
    FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits
WHERE
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    AND REGEXP_CONTAINS(page.pagePath, '(www.empik.com/premium$)') = TRUE
    and (SELECT value FROM hits.customDimensions WHERE index=22) in ('false')
),

ep_zakup_abonamentu as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    case when device.deviceCategory like 'mobile' then 'MOB' else 'WEB' end device,
    'akwizycyjny_url_premium' source,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    fullVisitorId
FROM
    `empik-ga360.304756.ga_sessions_*`, UNNEST(hits) AS hits
WHERE
    eventInfo.eventCategory = 'Empik Premium'
    AND REGEXP_CONTAINS(eventInfo.eventAction, 'zakup abonamentu.*')
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
)

select
x.true_date,
x.week_of_year,
x.month_of_year,
x.device,
x.source acquisition_source,
count (distinct x.id) acquisition_count,
count (distinct y.id) subscription_purchase

from premium x left join ep_zakup_abonamentu y on x.true_date=y.true_date and x.fullVisitorId=y.fullVisitorId and x.device=y.device
group by 1,2,3,4,5)

union all

-- 'akwizycyjny_url_moje-premium'
select * from (
with premium as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    case when device.deviceCategory like 'mobile' then 'MOB' else 'WEB' end device,
    'akwizycyjny_url_moje-premium' source,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    fullVisitorId
    FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits
WHERE
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    AND REGEXP_CONTAINS(page.pagePath, '(www.empik.com/moje-premium$)') = TRUE
    and (SELECT value FROM hits.customDimensions WHERE index=22) in ('false')
),

ep_zakup_abonamentu as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    case when device.deviceCategory like 'mobile' then 'MOB' else 'WEB' end device,
    'akwizycyjny_url_moje-premium' source,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    fullVisitorId
FROM
    `empik-ga360.304756.ga_sessions_*`, UNNEST(hits) AS hits
WHERE
    eventInfo.eventCategory = 'Empik Premium'
    AND REGEXP_CONTAINS(eventInfo.eventAction, 'zakup abonamentu.*')
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
)

select
x.true_date,
x.week_of_year,
x.month_of_year,
x.device,
x.source acquisition_source,
count (distinct x.id) acquisition_count,
count (distinct y.id) subscription_purchase

from premium x left join ep_zakup_abonamentu y on x.true_date=y.true_date and x.fullVisitorId=y.fullVisitorId and x.device=y.device
group by 1,2,3,4,5)

union all

-- 'koszyk / cart'
select * from (
with ep_checkout as (
select * from (
SELECT
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    case when device.deviceCategory like 'mobile' then 'MOB' else 'WEB' end device,
    'koszyk / cart' source,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    productSKU,
    fullVisitorId
    FROM `empik-ga360.304756.ga_sessions_*` s, unnest(s.hits) as hits, unnest(hits.product) as product
    where hits.eCommerceAction.action_type='5'
    and page.pagePath IN  ('www.empik.com/cart/index.jsp', 'www.empik.com/koszyk', 'www.empik.com/cart', 'www.empik.com/cart/')
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    )

        where productSKU = '16'
),

ep_purchase as (
select * from (
SELECT
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    case when device.deviceCategory like 'mobile' then 'MOB' else 'WEB' end device,
    'koszyk / cart' source,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    productSKU,
    fullVisitorId
    FROM `empik-ga360.304756.ga_sessions_*` s, unnest(s.hits) as hits, unnest(hits.product) as product
    where hits.eCommerceAction.action_type= '6'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    )

        where productSKU = '16'
)

select
x.true_date,
x.week_of_year,
x.month_of_year,
x.device,
x.source acquisition_source,
count (distinct x.id) acquisition_count,
count (distinct y.id) subscription_purchase
from ep_checkout x left join ep_purchase y on x.true_date=y.true_date and x.fullVisitorId=y.fullVisitorId and x.device=y.device
group by 1,2,3,4,5)) order by 1 desc