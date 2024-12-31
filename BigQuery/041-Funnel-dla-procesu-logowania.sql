WITH sesje_koszyk as (
SELECT
  date,
  device.deviceCategory as device,
  count(distinct concat(fullVisitorId,visitId)) as sesji_koszyk
FROM
  `empik-ga360.304756.ga_sessions_*`,
  UNNEST(hits) AS hits
WHERE
  totals.visits = 1
  and type = 'PAGE'
  and page.pagePath IN  ('www.empik.com/koszyk', 'www.empik.com/cart', 'www.empik.com/cart/','www.empik.com/cart/index.jsp')
--   and _table_suffix between '20200101' and '20211130'
  and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
GROUP BY 1,2
ORDER BY 1,2
),

#Dostawa i płatność

dostawa_platnosc as (
SELECT
  date,
  device,
  sum(case when s0 IN  ('www.empik.com/koszyk', 'www.empik.com/cart', 'www.empik.com/cart/','www.empik.com/cart/index.jsp')  then sessions else 0 end) as po_koszyku,
  sum(case when s0 IN('www.empik.com/koszyk/logowanie?continue=/koszyk/dostawa-i-platnosc','www.empik.com/koszyk/logowanie?continue=/cart/delivery-and-payment') then sessions else 0 end) as po_logowaniu,
  sum(case when s0 IN ('www.empik.com/koszyk/rejestracja?continue=/koszyk/dostawa-i-platnosc','www.empik.com/koszyk/rejestracja?continue=/cart/delivery-and-payment') then sessions else 0 end) as po_rejestracji
FROM
(

SELECT
  date,
  device,
  s0, s1,
  count(distinct id) as sessions
FROM
(
SELECT
  date,
  device.deviceCategory as device,
  concat(fullVisitorId,visitId) as id,
  hitNumber,
  page.pagePath as s0,
  LEAD(page.pagePath,1) OVER (PARTITION BY concat(fullVisitorId,visitId) ORDER BY hitNumber) AS s1,
  LEAD(page.pagePath,2) OVER (PARTITION BY fullVisitorId, visitStartTime ORDER BY hitNumber) AS s2
--  LEAD(page.pagePath,3) OVER (PARTITION BY fullVisitorId, visitStartTime ORDER BY hitNumber) AS s3,
--  LEAD(page.pagePath,4) OVER (PARTITION BY fullVisitorId, visitStartTime ORDER BY hitNumber) AS s4

FROM
  `empik-ga360.304756.ga_sessions_*`,
  UNNEST(hits) AS hits
WHERE
  totals.visits = 1
  and type = 'PAGE'
--   and _table_suffix between '20200101' and '20211130'
  and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
ORDER BY 1,2,3,4,5,6

)
WHERE
  s1 IN ('www.empik.com/koszyk/dostawa-i-platnosc','www.empik.com/cart/delivery-and-payment','www.empik.com/cart/delivery-and-payment?userConnectedToPremiumFree=true', 'www.empik.com/koszyk/dostawa-i-platnosc?userConnectedToPremiumFree=true')

GROUP BY 1,2,3,4
)
GROUP BY 1,2
),

goscie as (
SELECT
  date,
  device,
  count(distinct id) as gosc
FROM
(
SELECT
  date,
  device.deviceCategory as device,
  concat(fullVisitorId,visitId) as id,
  page.pagePath as s0,
  hitNumber,
  LEAD(page.pagePath,1) OVER (PARTITION BY concat(fullVisitorId,visitId) ORDER BY hitNumber) AS s1,
  LEAD(page.pagePath,2) OVER (PARTITION BY fullVisitorId, visitStartTime ORDER BY hitNumber) AS s2
--  LEAD(page.pagePath,3) OVER (PARTITION BY fullVisitorId, visitStartTime ORDER BY hitNumber) AS s3,
--  LEAD(page.pagePath,4) OVER (PARTITION BY fullVisitorId, visitStartTime ORDER BY hitNumber) AS s4
FROM
  `empik-ga360.304756.ga_sessions_*`,
  UNNEST(hits) AS hits
WHERE
  totals.visits = 1
  and type = 'PAGE'
--   and _table_suffix between '20200101' and '20211130'
  and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
ORDER BY 1,2,3,4,5,6,7

)
WHERE
  s2 IN ('www.empik.com/gosc/koszyk/dostawa-i-platnosc','www.empik.com/cart/guest/delivery-and-payment')
  and s1 IN ('www.empik.com/koszyk/logowanie?continue=/koszyk/dostawa-i-platnosc','www.empik.com/koszyk/logowanie?continue=/cart/delivery-and-payment')
  and s0 IN  ('www.empik.com/koszyk', 'www.empik.com/cart', 'www.empik.com/cart/','www.empik.com/cart/index.jsp')
GROUP BY 1,2
),

after_guest as (

SELECT
  date,
  device,
  count(distinct id) as after_guest
FROM
(
SELECT
  date,
  device.deviceCategory as device,
  concat(fullVisitorId,visitId) as id,
  page.pagePath as s0,
  hitNumber,
  LEAD(page.pagePath,1) OVER (PARTITION BY concat(fullVisitorId,visitId) ORDER BY hitNumber) AS s1,
  LEAD(page.pagePath,2) OVER (PARTITION BY fullVisitorId, visitStartTime ORDER BY hitNumber) AS s2,
  LEAD(page.pagePath,3) OVER (PARTITION BY fullVisitorId, visitStartTime ORDER BY hitNumber) AS s3
--  LEAD(page.pagePath,4) OVER (PARTITION BY fullVisitorId, visitStartTime ORDER BY hitNumber) AS s4
FROM
  `empik-ga360.304756.ga_sessions_*`,
  UNNEST(hits) AS hits
WHERE
  totals.visits = 1
  and type = 'PAGE'
--   and _table_suffix between '20200101' and '20211130'
  and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
ORDER BY 1,2,3,4,5,6,7,8

)
WHERE
  s2 IN ('www.empik.com/gosc/koszyk/dostawa-i-platnosc','www.empik.com/cart/guest/delivery-and-payment')
  and s1 IN ('www.empik.com/koszyk/logowanie?continue=/koszyk/dostawa-i-platnosc','www.empik.com/koszyk/logowanie?continue=/cart/delivery-and-payment')
  and s0 IN  ('www.empik.com/koszyk', 'www.empik.com/cart', 'www.empik.com/cart/', 'www.empik.com/cart', 'www.empik.com/cart/', 'www.empik.com/cart/index.jsp')
  and s3 IN ('www.empik.com/koszyk/logowanie?continue=/koszyk&comesFromUnregisteredFlow=true','www.empik.com/koszyk/logowanie?continue=/koszyk/dostawa-i-platnosc','www.empik.com/koszyk/logowanie?continue=/cart/delivery-and-payment','www.empik.com/koszyk/logowanie?continue=/koszyk','www.empik.com/koszyk/logowanie?continue=%2Fkoszyk')
 -- and s3 = 'www.empik.com/koszyk/logowanie?continue=/koszyk&comesFromUnregisteredFlow=true'
GROUP BY 1,2

),

login_after_guest as (

SELECT
  date,
  device,
  count(distinct id) as login_after_guest
FROM
(
SELECT
  date,
  device.deviceCategory as device,
  concat(fullVisitorId,visitId) as id,
  page.pagePath as s0,
  hitNumber,
  LEAD(page.pagePath,1) OVER (PARTITION BY concat(fullVisitorId,visitId) ORDER BY hitNumber) AS s1,
  LEAD(page.pagePath,2) OVER (PARTITION BY fullVisitorId, visitStartTime ORDER BY hitNumber) AS s2,
  LEAD(page.pagePath,3) OVER (PARTITION BY fullVisitorId, visitStartTime ORDER BY hitNumber) AS s3,
  LEAD(page.pagePath,4) OVER (PARTITION BY fullVisitorId, visitStartTime ORDER BY hitNumber) AS s4
FROM
  `empik-ga360.304756.ga_sessions_*`,
  UNNEST(hits) AS hits
WHERE
  totals.visits = 1
  and type = 'PAGE'
--   and _table_suffix between '20200101' and '20211130'
  and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
ORDER BY 1,2,3,4,5,6,7,8,9

)
WHERE

  s2 IN ('www.empik.com/gosc/koszyk/dostawa-i-platnosc','www.empik.com/cart/guest/delivery-and-payment')
  and s1 IN ('www.empik.com/koszyk/logowanie?continue=/koszyk/dostawa-i-platnosc','www.empik.com/koszyk/logowanie?continue=/cart/delivery-and-payment')
  and s0 IN  ('www.empik.com/koszyk', 'www.empik.com/cart', 'www.empik.com/cart/','www.empik.com/cart/index.jsp')
  and s3 IN ('www.empik.com/koszyk/logowanie?continue=/koszyk&comesFromUnregisteredFlow=true','www.empik.com/koszyk/logowanie?continue=/koszyk/dostawa-i-platnosc','www.empik.com/koszyk/logowanie?continue=/cart/delivery-and-payment','www.empik.com/koszyk/logowanie?continue=/koszyk','www.empik.com/koszyk/logowanie?continue=%2Fkoszyk')
  and s4 IN  ('www.empik.com/koszyk', 'www.empik.com/cart', 'www.empik.com/cart/','www.empik.com/cart/index.jsp')

GROUP BY 1,2

),

cofniecie_po_formularzu as (

SELECT
  date,
  device,
  count(distinct id) as cofniecie_po_formularzu
FROM
(
SELECT
  date,
  device.deviceCategory as device,
  concat(fullVisitorId,visitId) as id,
  page.pagePath as s0,
  hitNumber,
  LEAD(page.pagePath,1) OVER (PARTITION BY concat(fullVisitorId,visitId) ORDER BY hitNumber) AS s1,
  LEAD(page.pagePath,2) OVER (PARTITION BY fullVisitorId, visitStartTime ORDER BY hitNumber) AS s2,
  LEAD(page.pagePath,3) OVER (PARTITION BY fullVisitorId, visitStartTime ORDER BY hitNumber) AS s3
FROM
  `empik-ga360.304756.ga_sessions_*`,
  UNNEST(hits) AS hits
WHERE
  totals.visits = 1
  and type = 'PAGE'
--   and _table_suffix between '20200101' and '20211130'
  and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
ORDER BY 1,2,3,4,5,6,7,8

)
WHERE

  s2 IN ('www.empik.com/gosc/koszyk/dostawa-i-platnosc','www.empik.com/cart/guest/delivery-and-payment')
  and s1 IN ('www.empik.com/koszyk/logowanie?continue=/koszyk/dostawa-i-platnosc','www.empik.com/koszyk/logowanie?continue=/cart/delivery-and-payment')
  and s0 IN  ('www.empik.com/koszyk', 'www.empik.com/cart', 'www.empik.com/cart/','www.empik.com/cart/index.jsp')
  and s3 IN ('www.empik.com/koszyk/logowanie?continue=/koszyk/dostawa-i-platnosc','www.empik.com/koszyk/logowanie?continue=/cart/delivery-and-payment')

GROUP BY 1,2

)

SELECT
  sk.date,
  sk.device,
  sk.sesji_koszyk,
  dp.po_koszyku,
  dp.po_logowaniu,
  dp.po_rejestracji,
  g.gosc,
  ag.after_guest,
  lag.login_after_guest,
  cpf.cofniecie_po_formularzu
FROM sesje_koszyk sk left join dostawa_platnosc dp on (sk.date = dp.date and sk.device = dp.device)
  LEFT JOIN goscie g on (dp.date = g.date and dp.device = g.device)
  LEFT JOIN after_guest ag on (g.date = ag.date and g.device = ag.device)
  LEFT JOIN login_after_guest lag on (ag.date = lag.date and ag.device = lag.device)
  LEFT JOIN cofniecie_po_formularzu cpf ON (lag.date = cpf.date and lag.device = cpf.device)
GROUP by 1,2,3,4,5,6,7,8,9,10
order by 1 desc