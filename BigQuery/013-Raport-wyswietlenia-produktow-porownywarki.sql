%%bigquery --project produkcja-instore

SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'HR' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `eobuwie-181013.220106830.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)



UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'CZ' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `eobuwie-181013.75385167.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)



UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'BG' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `eobuwie-181013.124360956.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)



UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'DE' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `eobuwie-181013.86125562.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)



UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'ES' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `eobuwie-181013.173712545.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)




UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'FR' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `eobuwie-181013.179902241.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)



UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'GR' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `eobuwie-181013.150943533.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)



UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'HU' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `eobuwie-181013.109784473.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)



UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'IT' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `eobuwie-181013.171059603.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)



UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'LT' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `eobuwie-181013.146034219.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)


UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'RO' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `eobuwie-181013.102283488.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)


UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'SI' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `eobuwie-181013.239978547.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)



UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'SK' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `eobuwie-181013.139597678.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)


UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'modivo.bg' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `modivo-237010.198150516.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)


UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'modivo.cz' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `modivo-237010.195419120.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)


UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'modivo.gr' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `modivo-237010.198189162.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)




UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'modivo.hr' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `modivo-237010.234756062.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)


UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'modivo.hu' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `modivo-237010.198211271.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)


UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'modivo.it' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `modivo-237010.198209158.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)


UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'modivo.lt' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `modivo-237010.198163047.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)


UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'modivo.ro' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `modivo-237010.197538241.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)





UNION ALL



SELECT date, sku,source,kraj, views, sold, revenuepln, IF(views_sum>0,koszt_pln*(views/views_sum),0) as koszt_per_sku

from

(

SELECT date, sku,source, kraj, views, sold, revenuepln, sum(views) over (partition by date,source,kraj) as views_sum, koszt_pln

from

(



SELECT date, sku, lower(if(source like ('%glami%'),'glami',source)) as source, kraj, sum(views) as views, sum(sold) as sold, sum(revenuepln) as revenuepln,



from(



SELECT base.date, base.kraj, base.source, SKU, sum(if(action_type='2',ilosc_eventow,0)) as views, sum(if(action_type='6',ilosc_eventow,0)) as sold, sum(revenue) as revenue, sum(revenue*cur.kurs) as revenuepln

from



(

SELECT  date, trafficsource.source, trafficsource.medium, trafficsource.campaign, product.productSKU as SKU, hits.eCommerceAction.action_type,      'modivo.sk' as kraj,

count(*) as ilosc_eventow, sum(product.productRevenue)/1000000 as revenue

FROM `modivo-237010.197305482.ga_sessions_*`, UNNEST(hits) AS hits, unnest(hits.product) as product WHERE

_TABLE_SUFFIX BETWEEN '20210601'

AND

FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

and (hits.eCommerceAction.action_type='2' or hits.eCommerceAction.action_type='6')

group by 1,2,3,4,5,6,7

) as base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur



on base.kraj=cur.kraj and base.date=cast(format_date('%Y%m%d',cur.date) as string)



left join (Select source,medium, campaign, kraj, kanal_ogolne, kanal_szczegolowe from `elevated-honor-235814.analizy.zgrupowanie_atrybucja`) as t2



on base.source=t2.source and base.medium=t2.medium and coalesce(base.campaign,'(not set)')=t2.campaign and base.kraj=t2.kraj



where kanal_ogolne='Porównywarki'





group by 1,2,3,4



)



group by 1,2,3,4

) as t left join (

SELECT data,rynek,porownywarka,waluta,koszt*kurs as koszt_pln FROM `elevated-honor-235814.koszty.cost_porownywarki` base left join (SELECT date,kraj,kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie`) as cur

on base.rynek=cur.kraj and base.data=cur.date) koszty on t.source=koszty.porownywarka and parse_date('%Y%m%d',t.date)=koszty.data and t.kraj=koszty.rynek

)
order by 7 desc
limit 5