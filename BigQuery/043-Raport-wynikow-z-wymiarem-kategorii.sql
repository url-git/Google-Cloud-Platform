with t1 as (
select
    productSku,
    replace(pierwsza_kategoria, '"', '') pierwsza_kategoria,
    replace(druga_kategoria, '"', '') druga_kategoria,
    replace(trzecia_kategoria, '"', '') trzecia_kategoria,
    replace(czwarta_kategoria, '"', '') czwarta_kategoria
from (

SELECT
productSku, json_extract(category, '$.0') as pierwsza_kategoria, json_extract(category, '$.1') as druga_kategoria,
json_extract(category, '$.2') as trzecia_kategoria,json_extract(category, '$.3') as czwarta_kategoria, wyswietlenia, rank

from (
SELECT
productSku, category, wyswietlenia, RANK() OVER(PARTITION BY productSku ORDER BY wyswietlenia DESC) AS rank
from (
SELECT
product.productSku as productSku, TO_JSON_STRING(split(product.v2ProductCategory,'/')) as category, count(*) as wyswietlenia
FROM
    `empik-ga360.304756.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product
WHERE
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    and eCommerceAction.action_type='2'
group by 1,2))
where rank = 1)),

t2 as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) true_date,
    concat(EXTRACT(ISOYEAR FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING))), EXTRACT(ISOWEEK FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)))) iso_week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) month_of_year,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    product.productSku,
    count(*) show_details
FROM
    `empik-ga360.304756.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product
WHERE
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    and eCommerceAction.action_type='2'
group by 1,2,3,4,5
),

t3 as (
select
    PARSE_DATE('%Y%m%d', CAST(date AS STRING)) true_date,
    concat(EXTRACT(ISOYEAR FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING))), EXTRACT(ISOWEEK FROM PARSE_DATE('%Y%m%d', CAST(date AS STRING)))) iso_week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",date)) month_of_year,
    case when device.deviceCategory like 'mobile' then 'mobile' else 'desktop' end device,
    product.productSku,
    sum(product.productQuantity) quantity,
    sum(product.productRevenue/1000000) revenue
FROM
    `empik-ga360.304756.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product
WHERE
    _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    and eCommerceAction.action_type='6'
group by 1,2,3,4,5
)

select t2.true_date, t2.iso_week_of_year, t2.month_of_year, t1.pierwsza_kategoria,
t1.druga_kategoria, t1.trzecia_kategoria, t1.czwarta_kategoria, sum(t2.show_details) show_details,
sum(t3.quantity) quantity, sum(t3.revenue) revenue
from t2 full outer join t3 on
t2.true_date =t3.true_date  and t2.device=t3.device and t2.productSku=t3.productSku

left join t1 on t1.productSku = t2.productSku
group by 1,2,3,4,5,6,7
limit 10