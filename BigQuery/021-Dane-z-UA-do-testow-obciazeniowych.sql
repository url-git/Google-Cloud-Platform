with prep as (
SELECT
    date,
    hour,
    minute,
    project,
    country,
    contentGroup1,
    pageviews,
    hitsy,
    transactions,
    adds_to_basket,
    round(avg(pageviews) over (partition by contentGroup1),2) as average_page_views,
    round(max(pageviews) over (partition by contentGroup1),2) as max_pageviews,
    ntile(2) OVER(partition by contentgroup1 ORDER BY pageviews asc) AS Tile, -- funkcja NTILE(2), dzieli i przypisuje elementy do 2 "równych" zbiorów
    round(avg(transactions) over (partition by contentGroup1),2) as average_transactions,
    round(max(transactions) over (partition by contentGroup1),2) as max_transactions,
    round(avg(adds_to_basket) over (partition by contentGroup1),2) as avg_adds_to_baskets,
    round(max(adds_to_basket) over (partition by contentGroup1),2) as max_adds_to_baskets

from
(SELECT
    date,
    hour,
    minute,
    'eobuwie' as project,
    country,
    contentGroup1,
    count(distinct sessions) as sessions_at_this_minute,
    sum(if(type='PAGE',1,0)) as pageviews,
    count(type) as hitsy,
    count(distinct transactionId) as transactions,
    sum(if(action_type='3',1,0)) as adds_to_basket

from
(SELECT
    date,
    hits.hour,
    hits.minute,
    'PL' as country,
    concat(fullVisitorId,visitId) as sessions,
    hits.type,
    eCommerceAction.action_type,
    contentGroup.contentGroup1,
    transaction.transactionId
FROM `eobuwie-181013.3869171.ga_sessions_*`, unnest(hits) as hits
WHERE _TABLE_SUFFIX BETWEEN '20200915' and '20201015') as base
group by 1,2,3,4,5,6))

select
    project,
    country,
    contentGroup1,
    average_page_views,
    max_pageviews,
    (select min(pageviews) from prep where Tile=2 and contentGroup1=p.contentGroup1) as mean_pageviews,
    average_transactions,
    max_transactions,
    avg_adds_to_baskets,
    max_adds_to_baskets
from prep as p
group by 1,2,3,4,5,7,8,9,10
order by 1,2,3