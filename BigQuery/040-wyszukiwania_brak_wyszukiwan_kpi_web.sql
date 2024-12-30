select s.true_date, s.iso_week_of_year, s.month_of_year, s.device, s.search_sessions, s.serach_transaction, s.search_revenue, g.all_sessions, g.all_transaction, g.all_revenue,
g.all_sessions - s.search_sessions sesje_bez_wyszukiwan, g.all_transaction - s.serach_transaction transakcje_bez_wyszukiwan,
g.all_revenue - s.search_revenue revenue_bez_wyszukiwan

from

(select s.true_date, s.iso_week_of_year, s.month_of_year, s.device, sum(s.sessions) search_sessions, sum(q.all_transactions) serach_transaction, sum(q.all_revenue) search_revenue from

(SELECT
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    concat(EXTRACT(ISOYEAR FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)) ), EXTRACT(ISOWEEK FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)))) iso_week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    count(distinct concat(fullvisitorid, cast(visitstarttime as string))) sessions
  FROM
    `empik-ga360.304756.ga_sessions_*`,
    UNNEST(hits) AS hits
  WHERE
    REGEXP_CONTAINS(page.pagePath, r'(.*q=.*)|(.*fromSearchQuery=.*)|(.*rq=.*)|(.*nrq=.*)|(.*qa=.*)')  = TRUE
    AND page.searchKeyword IS NOT NULL
    -- and _table_suffix between '20200101' and '20220116'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
  GROUP BY
    1,2,3,4,5
) s

left join (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    concat(EXTRACT(ISOYEAR FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)) ), EXTRACT(ISOWEEK FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)))) iso_week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    (totals.totalTransactionRevenue/1000000) as all_revenue,
    (totals.transactions) all_transactions
FROM `empik-ga360.304756.ga_sessions_*`
WHERE
    -- _table_suffix between '20200101' and '20220116'
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
) q on s.true_date=q.true_date and s.device=q.device and s.id=q.id

group by 1,2,3,4) s

left join (select q.true_date, q.iso_week_of_year, q.month_of_year, q.device, sum(q.sessions) all_sessions, sum(q.all_transactions) all_transaction, sum(q.all_revenue) all_revenue from

(select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    concat(EXTRACT(ISOYEAR FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)) ), EXTRACT(ISOWEEK FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)))) iso_week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    (totals.totalTransactionRevenue/1000000) as all_revenue,
    (totals.transactions) all_transactions,
    (totals.visits) sessions,
FROM `empik-ga360.304756.ga_sessions_*`
WHERE
    -- _table_suffix between '20200101' and '20220116'
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7,8
) q
group by 1,2,3,4
) g on s.true_date=g.true_date and s.device=g.device
order by 1 desc