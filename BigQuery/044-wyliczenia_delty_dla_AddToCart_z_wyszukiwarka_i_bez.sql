with search_data as (select
s.year, s.month_number, s.device, sum(s.search_session) search_session, sum(s.addtocart_session) addtocart_session,
sum(g.all_session) all_session, sum(g.addtocart_all_session) addtocart_all_session,
sum(g.all_session) - sum(s.search_session) no_search_session, sum(g.addtocart_all_session) - sum(s.addtocart_session) no_search_addtocart
from

(select s.year, s.month_number, s.device, sum(s.sessions) search_session, sum(q.sessions) addtocart_session from

(
    SELECT
    cast(left(date,4) as int) as year,
    format_date('%m',parse_date("%Y%m%d",date)) month_number,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    count(distinct concat(fullvisitorid, cast(visitstarttime as string))) sessions
    FROM
    `empik-ga360.304756.ga_sessions_*`,
    UNNEST(hits) AS hits
    WHERE
    REGEXP_CONTAINS(page.pagePath, r'(.*q=.*)|(.*fromSearchQuery=.*)|(.*rq=.*)|(.*nrq=.*)|(.*qa=.*)')  = TRUE
    AND page.searchKeyword IS NOT NULL
    and _table_suffix between '20190101' and '20211231'

    -- and _table_suffix between FORMAT_DATE("%Y%m%d", DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 1 MONTH))
    -- and FORMAT_DATE("%Y%m%d", last_day(date_sub(current_date(), interval 1 month)))
  GROUP BY
    1,2,3,4
) s

left join (
    SELECT
    cast(left(date,4) as int) as year,
    format_date('%m',parse_date("%Y%m%d",date)) month_number,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    count(distinct concat(fullvisitorid, cast(visitstarttime as string))) sessions
    FROM
    `empik-ga360.304756.ga_sessions_*`,
    UNNEST(hits) AS hits
    WHERE
    eventInfo.eventCategory = 'Ecommerce'
    AND eventInfo.eventAction = 'Add to Cart'

    and _table_suffix between '20190101' and '20211231'

    -- and _table_suffix between FORMAT_DATE("%Y%m%d", DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 1 MONTH))
    -- and FORMAT_DATE("%Y%m%d", last_day(date_sub(current_date(), interval 1 month)))

    GROUP BY
    1,2,3,4
) q on s.year=q.year and s.month_number=q.month_number and s.device=q.device and s.id=q.id
group by 1,2,3
) s

left join

(select a.year, a.month_number, a.device, sum(a.sessions) all_session, sum(c.sessions) addtocart_all_session from
(
    SELECT
    cast(left(date,4) as int) as year,
    format_date('%m',parse_date("%Y%m%d",date)) month_number,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    totals.visits sessions
    FROM
    `empik-ga360.304756.ga_sessions_*`
    where _table_suffix between '20190101' and '20211231'

    -- and _table_suffix between FORMAT_DATE("%Y%m%d", DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 1 MONTH))
    -- and FORMAT_DATE("%Y%m%d", last_day(date_sub(current_date(), interval 1 month)))

) a

left join (
    SELECT
    cast(left(date,4) as int) as year,
    format_date('%m',parse_date("%Y%m%d",date)) month_number,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    concat(fullvisitorid, cast(visitstarttime as string)) id,
    count(distinct concat(fullvisitorid, cast(visitstarttime as string))) sessions
    FROM
    `empik-ga360.304756.ga_sessions_*`,
    UNNEST(hits) AS hits
    WHERE
    eventInfo.eventCategory = 'Ecommerce'
    AND eventInfo.eventAction = 'Add to Cart'

    and _table_suffix between '20190101' and '20211231'

    -- and _table_suffix between FORMAT_DATE("%Y%m%d", DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 1 MONTH))
    -- and FORMAT_DATE("%Y%m%d", last_day(date_sub(current_date(), interval 1 month)))

    GROUP BY
    1,2,3,4
) c on a.year=c.year and a.month_number=c.month_number and a.device=c.device and a.id=c.id
group by 1,2,3
) g on s.year=g.year and s.month_number=g.month_number and s.device=g.device
group by 1,2,3
),

pivot as (
    select month_number,
    device,
    sum ( if (year = (extract(year from CURRENT_DATE())-3) , search_session,0)) search_session_ly_min2,
    sum ( if (year = (extract(year from CURRENT_DATE())-2) , search_session,0)) search_session_ly_min1,
    sum ( if (year = (extract(year from CURRENT_DATE())-1) , search_session,0)) search_session_ly,
    sum ( if (year = extract(year from CURRENT_DATE()) , search_session,0)) search_session_this_year,

    sum ( if (year = (extract(year from CURRENT_DATE())-3) , addtocart_session,0)) addtocart_session_ly_min2,
    sum ( if (year = (extract(year from CURRENT_DATE())-2) , addtocart_session,0)) addtocart_session_ly_min1,
    sum ( if (year = (extract(year from CURRENT_DATE())-1) , addtocart_session,0)) addtocart_session_ly,
    sum ( if (year = extract(year from CURRENT_DATE()) , addtocart_session,0)) addtocart_session_this_year,

    sum ( if (year = (extract(year from CURRENT_DATE())-3) , no_search_session,0)) no_search_session_ly_min2,
    sum ( if (year = (extract(year from CURRENT_DATE())-2) , no_search_session,0)) no_search_session_ly_min1,
    sum ( if (year = (extract(year from CURRENT_DATE())-1) , no_search_session,0)) no_search_session_ly,
    sum ( if (year = extract(year from CURRENT_DATE()) , no_search_session,0)) no_search_session_this_year,

    sum ( if (year = (extract(year from CURRENT_DATE())-3) , no_search_addtocart,0)) no_search_addtocart_ly_min2,
    sum ( if (year = (extract(year from CURRENT_DATE())-2) , no_search_addtocart,0)) no_search_addtocart_ly_min1,
    sum ( if (year = (extract(year from CURRENT_DATE())-1) , no_search_addtocart,0)) no_search_addtocart_ly,
    sum ( if (year = extract(year from CURRENT_DATE()) , no_search_addtocart,0)) no_search_addtocart_this_year,

    from search_data
    group by 1,2

),

delta AS (
  SELECT
    month_number,
    device,
    safe_divide(addtocart_session_ly_min2, search_session_ly_min2) cr_addtocart_session_ly_min2,
    safe_divide(addtocart_session_ly_min1, search_session_ly_min1) cr_addtocart_session_ly_min1,
    safe_divide(addtocart_session_ly, search_session_ly) cr_addtocart_session_ly,
    safe_divide(addtocart_session_this_year, search_session_this_year) cr_addtocart_session_this_year,
    safe_divide(no_search_addtocart_ly_min2, no_search_session_ly_min2) cr_no_search_session_ly_min2,
    safe_divide(no_search_addtocart_ly_min1, no_search_session_ly_min1) cr_no_search_session_ly_min1,
    safe_divide(no_search_addtocart_ly, no_search_session_ly) cr_no_search_session_ly,
    safe_divide(no_search_addtocart_this_year, no_search_session_this_year) cr_no_search_session_this_year,
  FROM
    PIVOT)

SELECT
  month_number,
  device,
  cr_addtocart_session_ly_min2,
  cr_addtocart_session_ly_min1,
  safe_divide(cr_addtocart_session_ly_min1 - cr_addtocart_session_ly_min2, cr_addtocart_session_ly_min2) diff_cr_addtocart_session_ly_min1,
  cr_addtocart_session_ly,
  safe_divide(cr_addtocart_session_ly - cr_addtocart_session_ly_min1, cr_addtocart_session_ly_min1) diff_cr_addtocart_session_ly,
  cr_addtocart_session_this_year,
  safe_divide(cr_addtocart_session_this_year - cr_addtocart_session_ly, cr_addtocart_session_ly) diff_cr_addtocart_session_this_year,
  cr_no_search_session_ly_min2,
  cr_no_search_session_ly_min1,
  safe_divide(cr_no_search_session_ly_min1 - cr_no_search_session_ly_min2, cr_no_search_session_ly_min2) diff_cr_no_search_session_ly_min1,
  cr_no_search_session_ly,
  safe_divide(cr_no_search_session_ly - cr_no_search_session_ly_min1, cr_no_search_session_ly_min1) diff_cr_no_search_session_ly,
  cr_no_search_session_this_year,
  safe_divide(cr_no_search_session_this_year - cr_no_search_session_ly, cr_no_search_session_ly) diff_no_search_session_this_year,
FROM
  delta
ORDER BY
  1 ASC