select
    PARSE_DATE('%Y%m%d', CAST(alls.date AS STRING)) as true_date,
    concat(EXTRACT(ISOYEAR FROM PARSE_DATE('%Y%m%d', CAST(alls.date AS STRING))), EXTRACT(ISOWEEK FROM PARSE_DATE('%Y%m%d', CAST(alls.date AS STRING)))) iso_week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",alls.date)) as month_of_year,
    case when deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    alls.domena,
    if(path='/' or path='www.empik.com/index.jsp' ,'brand','nonbrand') as organic_kind,
    sum(visits) as sessions,
    sum(transactions) as transactions, sum(revenue)/1000000 as revenue

from

(SELECT date, concat(base.fullvisitorID,base.VisitId) sesja, 'empik.com' as domena, entry.path, device.deviceCategory,
totals.visits as visits, totals.transactions as transactions,  sum(totals.totalTransactionRevenue) as revenue

FROM `empik-ga360.304756.ga_sessions_*` as base
join
(SELECT concat(fullvisitorID,VisitId) as sesja, hits.page.pagePath as path,'empik.com' as domena,
FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits

where _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and lower(trafficSource.medium) like '%organic%'
and hitnumber = (
SELECT
MIN(hitnumber)
FROM
`empik-ga360.304756.ga_sessions_*` ts,
UNNEST(hits)
WHERE
type = 'PAGE'
and ts.VisitId=VisitID and ts.fullvisitorID=fullvisitorID
)
group by 1,2,3)
entry on entry.domena='empik.com' and concat(base.fullvisitorID,base.VisitId)=entry.sesja

where _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and lower(trafficSource.medium) like '%organic%'

group by 1,2,3,4,5,6,7) alls

group by 1,2,3,4,5,6
order by 1 desc
limit 5