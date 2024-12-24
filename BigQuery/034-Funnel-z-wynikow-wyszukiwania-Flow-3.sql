WITH
  searches AS (
  SELECT
    date,
    device.deviceCategory,
    page.pagePath AS page,
    page.searchKeyword AS skeyword,
    (SELECT value FROM hits.customDimensions WHERE INDEX=29) AS Solaris_newSearch,
    (SELECT value FROM hits.customDimensions WHERE INDEX=36) AS sol_mat,
    (SELECT value FROM hits.customDimensions WHERE INDEX=5) AS stopword,
    SPLIT(page.pagePath,',')[SAFE_OFFSET(1)] AS item_id, // https://www.empik.com/wybor,p1281412225,ksiazka-p
    CONCAT(fullVisitorId,visitId) AS id
  FROM
    `empik-ga360.304756.ga_sessions_*`,
    UNNEST(hits) AS hits
  WHERE
    REGEXP_CONTAINS(page.pagePath, r'(.*fromSearchQuery=.*)') = TRUE
    AND page.searchKeyword IS NOT NULL
    -- _table_suffix between '20190101' and '20211208'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))),

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
    AND REGEXP_CONTAINS(page.pagePath, r'(.*fromSearchQuery=.*)') = TRUE
    -- _table_suffix between '20190101' and '20211208'
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))),

  purchases AS (
  SELECT
    date,
    device.deviceCategory,
    productSKU AS item_id,
    v2ProductCategory AS category,
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
    and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)))

SELECT
  s.date,
  s.deviceCategory,
  s.page,
  s.skeyword,
  s.item_id,
  s.Solaris_newSearch,
  s.sol_mat,
  s.stopword,
  p.category,
  COUNT(DISTINCT s.id) AS perfectmatch,
  COUNT(DISTINCT c.id) AS clicks,
  COUNT(DISTINCT p.id) AS orders,
  SUM(p.item_revenue) AS wartosc_zamowienia
FROM searches s
LEFT JOIN clicks c ON (s.date = c.date AND s.id = c.id AND s.page = c.page AND s.item_id = c.item_id)
LEFT JOIN purchases p ON (c.date = p.date AND c.id = p.id AND c.item_id = p.item_id AND c.item_id = P.item_id AND c.category = p.category)
GROUP BY 1,2,3,4,5,6,7,8,9
order by 1 desc
limit 10