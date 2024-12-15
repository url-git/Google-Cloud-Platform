select PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date, 'RO' as country, case when Device.deviceCategory like 'mobile' then 'mobile'
when Device.deviceCategory like 'tablet' then 'mobile'
else 'desktop' end endpoint,
format_date('%G',parse_date("%Y%m%d", date)) as iso_year,
format_date('%U',parse_date("%Y%m%d", date)) as week_of_the_year,
count(distinct concat(fullvisitorid, cast(visitstarttime as string))) -
count(distinct case when hits.ecommerceaction.action_type = '2' then concat(fullvisitorid, cast(visitstarttime as string)) else null end) no_shopping_activity, # brak aktywności zakupowej (brak wejścia na kartę produktową)

count(distinct case when hits.ecommerceaction.action_type = '2' then concat(fullvisitorid, cast(visitstarttime as string)) else null end) -
count(distinct case when hits.ecommerceaction.action_type = '3' then concat(fullvisitorid, cast(visitstarttime as string)) else null end) as no_cart_addition, # nie dodał produktu do koszyka (brak kliknięcia guzika na karcie produktu)

count(distinct case when hits.ecommerceaction.action_type = '3' then concat(fullvisitorid, cast(visitstarttime as string)) else null end) -
count(distinct case when hits.ecommerceaction.action_type = '5' then concat(fullvisitorid, cast(visitstarttime as string)) else null end) as cart_abandonment, # nie wszedł do checkout (płatność i wysyłka)

count(distinct case when hits.ecommerceaction.action_type = '5' then concat(fullvisitorid, cast(visitstarttime as string)) else null end) -
count(distinct case when hits.ecommerceaction.action_type = '6' then concat(fullvisitorid, cast(visitstarttime as string)) else null end) as checkout_abandonment # nie dokonał transakcji
FROM `modivo-237010.197538241.ga_sessions_*` s, unnest(s.hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20210910' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5

union all

select PARSE_DATE('%Y%m%d', CAST(date AS STRING)) as true_date, 'BG' as country, case when Device.deviceCategory like 'mobile' then 'mobile'
when Device.deviceCategory like 'tablet' then 'mobile'
else 'desktop' end endpoint,
format_date('%G',parse_date("%Y%m%d", date)) as iso_year,
format_date('%U',parse_date("%Y%m%d", date)) as week_of_the_year,
count(distinct concat(fullvisitorid, cast(visitstarttime as string))) -
count(distinct case when hits.ecommerceaction.action_type = '2' then concat(fullvisitorid, cast(visitstarttime as string)) else null end) no_shopping_activity,
count(distinct case when hits.ecommerceaction.action_type = '2' then concat(fullvisitorid, cast(visitstarttime as string)) else null end) -
count(distinct case when hits.ecommerceaction.action_type = '3' then concat(fullvisitorid, cast(visitstarttime as string)) else null end) as no_cart_addition,
count(distinct case when hits.ecommerceaction.action_type = '3' then concat(fullvisitorid, cast(visitstarttime as string)) else null end) -
count(distinct case when hits.ecommerceaction.action_type = '5' then concat(fullvisitorid, cast(visitstarttime as string)) else null end) as cart_abandonment,
count(distinct case when hits.ecommerceaction.action_type = '5' then concat(fullvisitorid, cast(visitstarttime as string)) else null end) -
count(distinct case when hits.ecommerceaction.action_type = '6' then concat(fullvisitorid, cast(visitstarttime as string)) else null end) as checkout_abandonment
FROM `modivo-237010.198150516.ga_sessions_*` s, unnest(s.hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20210910' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5
order by 1
limit 5