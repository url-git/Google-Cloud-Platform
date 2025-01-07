with searches as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) true_date,
    concat(EXTRACT(ISOYEAR FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)) ), EXTRACT(ISOWEEK FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)))) iso_week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) month_of_year,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    count(distinct concat(fullvisitorid, cast(visitstarttime as string))) sessions,
    count(distinct fullvisitorid) users
  FROM
    `empik-ga360.304756.ga_sessions_*`,
    UNNEST(hits) AS hits
  WHERE
    REGEXP_CONTAINS(page.pagePath, r'(.*q=.*)|(.*rq=.*)|(.*nrq=.*)|(.*qa=.*)')  = TRUE
    AND page.searchKeyword IS NOT NULL
    -- and _table_suffix between '20200101' and '20211228'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    group by 1,2,3,4,5
),

views as (
SELECT
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) true_date,
    concat(EXTRACT(ISOYEAR FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)) ), EXTRACT(ISOWEEK FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)))) iso_week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) month_of_year,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    count(distinct concat(fullvisitorid, cast(visitstarttime as string))) sessions,
    count(distinct fullvisitorid) users
  FROM
    `empik-ga360.304756.ga_sessions_*`,
    UNNEST(hits) AS hits
  WHERE
    hits.eCommerceAction.action_type = '2'
    AND eventInfo.eventCategory = 'Ecommerce'
    AND eventInfo.eventAction = 'Product Detail View'
    -- Karta produktu, dla poprzedzających stron (referrer), które pochodzą z search (zmienna JS: document.referrer)
    AND REGEXP_CONTAINS((SELECT value FROM hits.CustomDimensions WHERE index=12), r'(.*q=.*)|(.*rq=.*)|(.*nrq=.*)|(.*qa=.*)')
    -- and _table_suffix between '20200101' and '20211228'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    group by 1,2,3,4,5
),

clicks as (
SELECT
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) true_date,
    concat(EXTRACT(ISOYEAR FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)) ), EXTRACT(ISOWEEK FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)))) iso_week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) month_of_year,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    count(distinct concat(fullvisitorid, cast(visitstarttime as string))) sessions,
    count(distinct fullvisitorid) users
  FROM
    `empik-ga360.304756.ga_sessions_*`,
    UNNEST(hits) AS hits
  WHERE
    eventInfo.eventCategory = 'Ecommerce'
    AND eventInfo.eventAction = 'Add to Cart'
    AND eventInfo.eventLabel = 'karta produktu'
    -- and _table_suffix between '20200101' and '20211228'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    group by 1,2,3,4,5
),

purchases as (
SELECT
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    sum(totals.totalTransactionRevenue/1000000) as all_revenue,
    sum(totals.transactions) all_transactions
  FROM
    `empik-ga360.304756.ga_sessions_*`
  WHERE
    -- _table_suffix between '20200101' and '20211228'
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    group by 1,2,3,4,5
)

SELECT
    s.true_date,
    s.iso_week_of_year,
    s.month_of_year,
    s.device,
    sum(s.sessions) s_searches,
    sum(s.users) u_searches,
    sum(v.sessions) s_views,
    sum(v.users) u_views,
    sum(c.sessions) s_addtocart,
    sum(c.users) u_addtocart,
    sum(p.all_revenue) all_revenue,
    sum(p.all_transactions) all_transactions

FROM searches s LEFT JOIN views v ON (s.true_date = v.true_date AND s.id = v.id and s.device = v.device)
LEFT JOIN clicks c ON (v.true_date = c.true_date AND v.id = c.id and v.device = c.device)
LEFT JOIN purchases p ON (c.true_date = p.true_date AND c.id = p.id and c.device = p.device)
GROUP BY 1,2,3,4
ORDER BY 1 desc