with tabela1 as ((SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'PL' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000 as revenue
FROM `eobuwie-181013.3869171.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'CZ' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*0.1672 as revenue
FROM `eobuwie-181013.75385167.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all
(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'RO' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*0.9019 as revenue
FROM `eobuwie-181013.102283488.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'HU' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*0.013289 as revenue
FROM `eobuwie-181013.109784473.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'HR' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*0.59 as revenue
FROM `eobuwie-181013.220106830.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'UA' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*0.1451 as revenue
FROM `eobuwie-181013.117916521.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'RU' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*0.1451 as revenue
FROM `eobuwie-181013.123686680.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'BG' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*2.194 as revenue
FROM `eobuwie-181013.124360956.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'SK' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*4.2911 as revenue
FROM `eobuwie-181013.139597678.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'LT' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*4.2911 as revenue
FROM `eobuwie-181013.146034219.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'GR' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*4.2911 as revenue
FROM `eobuwie-181013.150943533.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'SE' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*0.4038 as revenue
FROM `eobuwie-181013.166613794.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'IT' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*4.2911 as revenue
FROM `eobuwie-181013.171059603.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'ES' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*4.2911 as revenue
FROM `eobuwie-181013.173712545.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'FR' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*4.2911 as revenue
FROM `eobuwie-181013.179902241.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'EU' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*4.2911 as revenue
FROM `eobuwie-181013.4743067.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'DE' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*4.2911 as revenue
FROM `eobuwie-181013.86125562.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'SI' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*4.2911 as revenue
FROM `eobuwie-181013.239978547.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)

union all

(SELECT  date, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU, hits.eCommerceAction.action_type,	'CH' as kraj,
count(*) as ilosc, count(distinct hits.transaction.transactionId) as unique_transactions, count (hits.transaction.transactionId) as transactions, sum(product.productRevenue)/1000000*4.2911 as revenue
FROM `eobuwie-181013.201751441.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='3' or hits.eCommerceAction.action_type='6')
group by 1,2,3,4)
),

tabela2 as (Select date,SKU, kraj, max(case when action_type='2' then ilosc END) as ilosc_odslon, max(case when action_type='6' then unique_transactions END) as unique_transactions,  max(case when action_type='6' then transactions END) as quantity,
max(case when action_type='6' then revenue END) as revenue, max(case when action_type='3' then ilosc END) as basket from tabela1
group by 1,2,3),

kategoria as ( Select v2ProductName, SKU, v2ProductCategory from
(
Select t1.v2ProductName, t1.SKU, row_number() over(partition by t1.SKU order by t2.v2ProductCategory desc) as rn, t2.v2ProductCategory from
(Select max(date) as date, product.v2ProductName, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU
FROM `eobuwie-181013.3869171.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 2,3) as t1
left join
(
Select date, product.v2ProductName, product.v2ProductCategory, coalesce(substr(regexp_extract(product.productSKU, "(.*-)"),1,length(regexp_extract(product.productSKU, "(.*-)"))-1),product.productSKU) as SKU
FROM `eobuwie-181013.3869171.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE
_TABLE_SUFFIX BETWEEN '20190101'
AND
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4
) as t2
on t1.date=t2.date and t1.v2ProductName=t2.v2ProductName and t1.SKU=t2.SKU)
where rn=1
)

Select date, tabela2.SKU, v2ProductName, v2ProductCategory, kraj, ilosc_odslon, unique_transactions, quantity, revenue, basket from tabela2 left join
kategoria
on tabela2.SKU=kategoria.SKU
limit 5