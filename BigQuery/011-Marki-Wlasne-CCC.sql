SELECT base.date, productBrand, country, sum(quantity) as quantity, sum(revenue*currency.rate) as revenue_PLN, sum(revenue) as local_revenue

from(

(SELECT date, product.productBrand, 'PL' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.3869171.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'RO' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.102283488.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'HU' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.109784473.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'UA' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.117916521.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'RU' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.123686680.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'BG' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.124360956.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'SK' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.139597678.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'LT' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.146034219.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'GR' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.150943533.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'SE' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.166613794.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'IT' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.171059603.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'ES' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.173712545.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'FR' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.179902241.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'DE' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.86125562.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'CZ' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.75385167.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'HR' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.220106830.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'CH' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.201751441.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all


(SELECT date, product.productBrand, 'EU' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.4743067.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi', 'bassano', 'via ravia', 'ottimo', 'deezee', 'go soft') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3)



union all



(SELECT date, product.productBrand, 'SI' as country, sum(product.productQuantity) as quantity, sum(product.productRevenue/1000000) as revenue
FROM `eobuwie-181013.239978547.ga_sessions_*`, unnest(hits) as hits, unnest(hits.product) as product
WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
and (lower(product.productBrand) in ('lanetti', 'lasocki', 'jenny fairy', 'sprandi', 'clara barson', 'nelli blu', 'action boy', 'vapiano', 'magic lady', 'walky', 'cesare cave', 'nylon red', 'quazi','gino rossi') or lower(product.productBrand) like ('%lasocki%'))
and hits.eCommerceAction.action_type='6'
group by 1,2,3))




base left join (SELECT date,kurs as rate,kraj from `elevated-honor-235814.analizy.kursy_wszystkie`) as currency on base.country=currency.kraj and PARSE_DATE('%Y%m%d', CAST(base.date AS STRING))=currency.date

group by 1,2,3

order by date desc
limit 5