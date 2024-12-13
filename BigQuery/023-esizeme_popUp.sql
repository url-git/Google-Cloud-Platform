with tabela1 as (
select
    date,
    sum(visits) sesje,
    sum(newVisits) nowi_uzytkownicy,
    sum(pageviews) odslony,
    count(distinct fullVisitorId) uzytkownicy,
    coalesce(sum(bounces),0) bounced_sesions

from (
select
    date,
    totals.visits,
    totals.transactions,
    totals.newVisits,
    totals.pageviews,
    totals.totalTransactionRevenue,
    totals.bounces,
    fullVisitorId,
    visitId

FROM `eobuwie-181013.3869171.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
where
_TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 360 DAY)) AND FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and hits.eventInfo.eventCategory='esizeme'
and hits.eventInfo.eventLabel='Wyświetlenie skanu na karcie produktu'
and totals.bounces is null
group by 1,2,3,4,5,6,7,8,9)
group by 1),



tabela2 as (
Select
date,
count(distinct transactionId) as transakcje,
sum(przychod) as przychod,
sum(przychod_z_produktu) as przychod_z_produktu

from

(Select
t1.date,
t2.transactionId,
transactionRevenue/1000000 as przychod,
sum(przychod_z_produktu/1000000) as przychod_z_produktu

from
(Select
    product.productSKU,
    fullVisitorId,
    visitId,
    date
    FROM `eobuwie-181013.3869171.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product where
    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY)) AND FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    and hits.eventInfo.eventCategory='esizeme'
    and hits.eventInfo.eventLabel='Wyświetlenie skanu na karcie produktu'
group by 1,2,3,4) as t1

left join
(Select
    coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU,
    hits.transaction.transactionId,
    hits.transaction.transactionRevenue,
    fullVisitorId,
    visitId,
    product.productRevenue as przychod_z_produktu

FROM `eobuwie-181013.3869171.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
where
_TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 360 DAY)) AND FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and hits.transaction.transactionId is not null) as t2

on t1.productSKU=t2.SKU and t1.fullVisitorId=t2.fullVisitorId and t1.visitId=t2.visitId
group by 1,2,3)
group by 1)

Select
    tabela1.*,
    tabela2.transakcje,
    tabela2.przychod,
    tabela2.przychod_z_produktu
from tabela1
left join tabela2 on tabela1.date=tabela2.date
order by 1 desc
limit 5