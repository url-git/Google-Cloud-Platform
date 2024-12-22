WITH
  searches AS (
  SELECT
    date,
    device.deviceCategory,
    isEntrance AS entrance,
    page.pagePath AS page,
    page.searchKeyword as skeyword,
    page.searchCategory scategory,
    (SELECT value FROM hits.customDimensions WHERE index=29) AS Solaris_newSearch,
    (SELECT value FROM hits.customDimensions WHERE index=36) AS sol_mat,
    (SELECT value FROM hits.customDimensions where index=37) as proposedCategory,
    (SELECT value FROM hits.customDimensions where index=4) as popularity,
    (SELECT value FROM hits.customDimensions where index=5) as stopword,
    REPLACE(REGEXP_EXTRACT(page.pagePath, r'q=([^?&#]*)'), '+', ' ') AS query,
    CONCAT(fullVisitorId,visitId) AS id
  FROM
    `empik-ga360.304756.ga_sessions_*`,
    UNNEST(hits) AS hits
  WHERE
    REGEXP_CONTAINS(page.pagePath, r'(.*q=.*)')  = TRUE
    AND page.searchKeyword IS NOT NULL
    -- _table_suffix between '20190101' and '20211208'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
  GROUP BY
    1,2,3,4,5,6,7,8,9,10,11,12,13),

  views AS (
   SELECT
    date,
    device.deviceCategory,
    SPLIT(page.pagePath, ',')[safe_offset(1)] AS item_id,
    v2ProductCategory as category,
    SPLIT((SELECT value FROM hits.CustomDimensions WHERE index=12), '://')[safe_OFFSET(1)] AS referrer, # Usuwam https://
    CONCAT(fullVisitorId,visitId) AS id,
  FROM
    `empik-ga360.304756.ga_sessions_*`,
    UNNEST(hits) AS hits,
    UNNEST(product) AS product
  WHERE
    hits.eCommerceAction.action_type = '2'
    AND eventInfo.eventCategory = 'Ecommerce'
    AND eventInfo.eventAction = 'Product Detail View'
    AND REGEXP_CONTAINS((SELECT value FROM hits.CustomDimensions WHERE index=12), r'(.*q=.*)') # Mam karty produktu, dla poprzedzających stron (referrer) pochodzących z Search
    -- _table_suffix between '20190101' and '20211208'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
  GROUP BY
    1,2,3,4,5,6),

  clicks AS (
    SELECT
    date,
    device.deviceCategory,
    SPLIT(page.pagePath, ',')[safe_OFFSET(1)] AS item_id,
    v2ProductCategory as category,
    CONCAT(fullVisitorId,visitId) AS id
  FROM
    `empik-ga360.304756.ga_sessions_*`,
    UNNEST(hits) AS hits,
    UNNEST(product) AS product
  WHERE
    eventInfo.eventCategory = 'Ecommerce'
    AND eventInfo.eventAction = 'Add to Cart'
    AND eventInfo.eventLabel = 'karta produktu'
    -- _table_suffix between '20190101' and '20211208'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
  GROUP BY 1,2,3,4,5),

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
    -- _table_suffix between '20190101' and '20211208'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
  ORDER BY 1,2,3,4,5,6)

SELECT
  s.date,
  s.deviceCategory,
  s.page,
  s.entrance,
  s.query,
  s.skeyword,
  s.scategory,
  s.proposedCategory,
  s.Solaris_newSearch,
  s.sol_mat,
  s.popularity,
  s.stopword,
  v.item_id,
  p.category,
  COUNT(DISTINCT s.id) AS searches,
  COUNT(DISTINCT v.id) AS views,
  COUNT(DISTINCT c.id) AS clicks,
  COUNT(DISTINCT p.id) AS orders,
  SUM(p.item_revenue) AS wartosc_zamowienia
FROM searches s LEFT JOIN views v ON (s.date = v.date AND s.id = v.id AND s.page = v.referrer)
LEFT JOIN clicks c ON (v.date = c.date AND v.id = c.id AND v.item_id = c.item_id AND v.category = c.category)
LEFT JOIN purchases p ON (c.date = p.date AND c.id = p.id AND c.item_id = p.item_id AND c.category = p.category)
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14
ORDER BY 1 desc
limit 10