WITH
  searches AS (
  SELECT
    date,
    device.deviceCategory,
    page.pagePath AS page,
    page.searchKeyword AS skeyword,
    page.searchCategory scategory,
    (SELECT value FROM hits.customDimensions WHERE index=29) AS Solaris_newSearch,
    (SELECT value FROM hits.customDimensions WHERE index=36) AS sol_mat,
    (SELECT value FROM hits.customDimensions WHERE index=37) AS proposedCategory,
    (SELECT value FROM hits.customDimensions WHERE index=4) AS popularity,
    (SELECT value FROM hits.customDimensions WHERE index=5) AS stopword,
    isEntrance AS entrance,
    REPLACE(REGEXP_EXTRACT(page.pagePath, r'q=([^?&#]*)'), '+', ' ') AS query, #replace usuwa znak + np. smiki,+warzywa,+zestaw
    CONCAT(fullVisitorId,visitId) AS id
  FROM
    `empik-ga360.304756.ga_sessions_*`,
    UNNEST(hits) AS hits
  WHERE
    REGEXP_CONTAINS(page.pagePath, r'(.*q=.*)') = TRUE
    AND page.searchKeyword IS NOT NULL
    AND _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
  --  AND _table_suffix between '20210430' and '20210503'
  GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13),

  clicks AS (
  SELECT
    date,
    device.deviceCategory,
    page.pagePath AS page,
    productSKU AS item_id,
    v2ProductCategory AS category,
    CONCAT(fullVisitorId,visitId) AS id
  FROM
    `empik-ga360.304756.ga_sessions_*`,
    UNNEST(hits) AS hits,
    UNNEST(product) AS product
  WHERE
    eventInfo.eventCategory = 'Ecommerce'
    AND eventInfo.eventAction = 'Add to Cart'
    AND REGEXP_CONTAINS(eventInfo.eventLabel, r'(^Wyniki wyszukiwania.*)') = TRUE # np. Wyniki wyszukiwania / harry potter
    AND _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
 --   AND _table_suffix between '20210430' and '20210503'
  GROUP BY 1,2,3,4,5,6),

  purchases AS (
  SELECT
    date,
    device.deviceCategory,
    productSKU AS item_id,
    v2ProductCategory as category,
    productRevenue / 1000000 AS item_revenue,
    CONCAT(fullVisitorId,visitId) AS id
  FROM
    `empik-ga360.304756.ga_sessions_*`,
    UNNEST(hits) AS hits,
    UNNEST(product) AS product
  WHERE
    eventInfo.eventCategory = 'Ecommerce'
    AND eventInfo.eventAction = 'Purchase'
    AND _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
-- AND _table_suffix between '20210430' and '20210503'
  ORDER BY 1,2,3,4,5,6)

SELECT
  s.date,
  s.deviceCategory,
  s.entrance,
  s.page,
  s.skeyword,
  s.scategory,
  s.proposedCategory,
  s.query,
  s.Solaris_newSearch,
  s.sol_mat,
  s.popularity,
  s.stopword,
  c.item_id,
  p.category,
  COUNT(DISTINCT s.id) AS searches,
  COUNT(DISTINCT c.id) AS clicks,
  COUNT(DISTINCT p.id) AS orders,
  SUM(p.item_revenue) AS wartosc_zamowienia
FROM
  searches s LEFT JOIN clicks c
ON (s.date = c.date AND s.id = c.id AND s.page = c.page)
LEFT JOIN purchases p ON (c.date = p.date AND c.id = p.id AND c.item_id = p.item_id AND c.category = p.category)
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14
ORDER BY
  date, orders desc
limit 10