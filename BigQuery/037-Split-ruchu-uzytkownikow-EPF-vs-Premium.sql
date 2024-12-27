with moje_premium_niezalogowany as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    count(distinct concat(fullvisitorid, cast(visitstarttime as string))) s_moje_premium_niezalogowany,
    count(distinct fullvisitorid) u_moje_premium_niezalogowany
    FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits
WHERE
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    -- _table_suffix between '20201201' and '20211214'
    -- and page.pagePath IN  ('www.empik.com/moje-premium')
    AND REGEXP_CONTAINS(page.pagePath, '(www.empik.com/moje-premium.*)') = TRUE
    and (SELECT value FROM hits.customDimensions WHERE index=51) = ('Niezalogowany')
group by 1,2,3,4
),

premium_free as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    count(distinct concat(fullvisitorid, cast(visitstarttime as string))) s_premium_free,
    count(distinct fullvisitorid) u_premium_free
    FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits
WHERE
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    -- _table_suffix between '20201201' and '20211214'
    -- and page.pagePath IN  ('www.empik.com/moje-premium')
    AND REGEXP_CONTAINS(page.pagePath, '(www.empik.com/moje-premium.*)') = TRUE
    and (SELECT value FROM hits.customDimensions WHERE index=51) = 'Zalogowany'
    and ((SELECT value FROM hits.customDimensions WHERE index=2) = 'true' AND (SELECT value FROM hits.customDimensions WHERE index=22) = 'false')
group by 1,2,3,4
),

moje_premium as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    count(distinct concat(fullvisitorid, cast(visitstarttime as string))) s_moje_premium,
    count(distinct fullvisitorid) u_moje_premium
    FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits
WHERE
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    -- _table_suffix between '20201201' and '20211214'
    -- and page.pagePath IN  ('www.empik.com/moje-premium')
    AND REGEXP_CONTAINS(page.pagePath, '(www.empik.com/moje-premium.*)') = TRUE
    and (SELECT value FROM hits.customDimensions WHERE index=51) = 'Zalogowany'
    and (SELECT value FROM hits.customDimensions WHERE index=22) = 'true'
group by 1,2,3,4
),

moj_empik as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    format_date('%Y%U',parse_date("%Y%m%d",date)) as week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) as month_of_year,
    count(distinct concat(fullvisitorid, cast(visitstarttime as string))) s_moj_empik,
    count(distinct fullvisitorid) u_moj_empik
    FROM `empik-ga360.304756.ga_sessions_*`, unnest(hits) as hits
WHERE
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    -- _table_suffix between '20201201' and '20211214'
    -- and page.pagePath IN  ('www.empik.com/moje-premium')
    AND REGEXP_CONTAINS(page.pagePath, '(www.empik.com/moje-premium.*)') = TRUE
    and (SELECT value FROM hits.customDimensions WHERE index=51) = 'Zalogowany'
    and (SELECT value FROM hits.customDimensions WHERE index=2) = 'true'
group by 1,2,3,4
)

select
    mpn.true_date,
    mpn.week_of_year,
    mpn.month_of_year,
    mpn.device,
    mpn.s_moje_premium_niezalogowany,
    mpn.u_moje_premium_niezalogowany,
    pf.s_premium_free,
    pf.u_premium_free,
    mp.s_moje_premium,
    mp.u_moje_premium,
    me.s_moj_empik,
    me.u_moj_empik

from moje_premium_niezalogowany mpn left join premium_free pf on mpn.true_date=pf.true_date and mpn.device=pf.device
LEFT JOIN moje_premium mp on mp.true_date=pf.true_date and mp.device=pf.device
LEFT JOIN moj_empik me on me.true_date=pf.true_date and me.device=pf.device
order by 1 desc