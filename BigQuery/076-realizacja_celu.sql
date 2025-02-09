SELECT
  *
FROM (
  SELECT
    true_date,
    week_of_year,
    month_of_year,
    device,
    SUM(cart) cart,
    SUM(delivery_payment) delivery_payment,
    SUM(purchase) purchase,
  FROM (
    WITH
      krok_1 AS (
      SELECT
        parse_DATE("%Y%m%d",
          event_date) true_date,
        FORMAT_DATE('%G%W',parse_DATE("%Y%m%d",
            event_date)) week_of_year,
        FORMAT_DATE('%Y%m',parse_DATE("%Y%m%d",
            event_date)) month_of_year,
        CASE
          WHEN device.category LIKE 'desktop' AND platform LIKE 'WEB' THEN 'WEB'
          WHEN device.category LIKE 'mobile'
        AND platform LIKE 'WEB' THEN 'MOB'
          WHEN device.category LIKE 'tablet' AND platform LIKE 'WEB' THEN 'MOB'
        ELSE
        'WEB'
      END
        device,
        CONCAT(user_pseudo_id, CAST((
            SELECT
              value.int_value
            FROM
              UNNEST(event_params)
            WHERE
              key = 'ga_session_id') AS STRING)) id,
        user_pseudo_id,
        event_timestamp
      FROM
        `empik-mobile-app.analytics_183670685.events_*`
      WHERE
        event_name = 'begin_checkout'
        AND platform = 'WEB'
        AND _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)) ),
      krok_2 AS (
      SELECT
        parse_DATE("%Y%m%d",
          event_date) true_date,
        FORMAT_DATE('%G%W',parse_DATE("%Y%m%d",
            event_date)) week_of_year,
        FORMAT_DATE('%Y%m',parse_DATE("%Y%m%d",
            event_date)) AS month_of_year,
        CASE
          WHEN device.category LIKE 'desktop' AND platform LIKE 'WEB' THEN 'WEB'
          WHEN device.category LIKE 'mobile'
        AND platform LIKE 'WEB' THEN 'MOB'
          WHEN device.category LIKE 'tablet' AND platform LIKE 'WEB' THEN 'MOB'
        ELSE
        'WEB'
      END
        device,
        CONCAT(user_pseudo_id, CAST((
            SELECT
              value.int_value
            FROM
              UNNEST(event_params)
            WHERE
              key = 'ga_session_id') AS STRING)) id,
        event_timestamp,
        user_pseudo_id
      FROM
        `empik-mobile-app.analytics_183670685.events_*`
      WHERE
        event_name = 'cart_summary_view'
        AND platform = 'WEB'
        AND _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)) ),
      krok_3 AS (
      SELECT
        parse_DATE("%Y%m%d",
          event_date) true_date,
        FORMAT_DATE('%G%W',parse_DATE("%Y%m%d",
            event_date)) week_of_year,
        FORMAT_DATE('%Y%m',parse_DATE("%Y%m%d",
            event_date)) AS month_of_year,
        CASE
          WHEN device.category LIKE 'desktop' AND platform LIKE 'WEB' THEN 'WEB'
          WHEN device.category LIKE 'mobile'
        AND platform LIKE 'WEB' THEN 'MOB'
          WHEN device.category LIKE 'tablet' AND platform LIKE 'WEB' THEN 'MOB'
        ELSE
        'WEB'
      END
        device,
        CONCAT(user_pseudo_id, CAST((
            SELECT
              value.int_value
            FROM
              UNNEST(event_params)
            WHERE
              key = 'ga_session_id') AS STRING)) id,
        event_timestamp,
        user_pseudo_id
      FROM
        `empik-mobile-app.analytics_183670685.events_*`
      WHERE
        event_name IN ('purchase',
          'ecommerce_purchase')
        AND platform = 'WEB'
        AND _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)) )
    SELECT
      k1.true_date,
      k1.week_of_year,
      k1.month_of_year,
      k1.device,
      COUNT(DISTINCT k1.id) cart,
      COUNT(DISTINCT k2.id) delivery_payment,
      COUNT(DISTINCT k3.id) purchase,
    FROM
      krok_1 k1
    LEFT JOIN
      krok_2 k2
    ON
      (k1.true_date = k2.true_date
        AND k1.id = k2.id
        AND k1.event_timestamp < k2.event_timestamp
        AND k1.device=k2.device)
    LEFT JOIN
      krok_3 k3
    ON
      (k2.true_date = k3.true_date
        AND k2.id = k3.id
        AND k2.event_timestamp < k3.event_timestamp
        AND k2.device=k3.device)
    GROUP BY
      1,
      2,
      3,
      4 )
  GROUP BY
    1,
    2,
    3,
    4



-- APP
UNION ALL




  SELECT
    true_date,
    week_of_year,
    month_of_year,
    device,
    SUM(cart) cart,
    SUM(delivery_payment) delivery_payment,
    SUM(purchase) purchase,
  FROM (
    WITH
      krok_1 AS (
      SELECT
        parse_DATE("%Y%m%d",
          event_date) true_date,
        FORMAT_DATE('%G%W',parse_DATE("%Y%m%d",
            event_date)) week_of_year,
        FORMAT_DATE('%Y%m',parse_DATE("%Y%m%d",
            event_date)) month_of_year,
        'APP' device,
        CONCAT(user_pseudo_id, CAST((
            SELECT
              value.int_value
            FROM
              UNNEST(event_params)
            WHERE
              key = 'ga_session_id') AS STRING)) id,
        event_timestamp,
        user_pseudo_id
      FROM
        `empik-mobile-app.analytics_183670685.events_*`
      WHERE
        event_name = 'begin_checkout'
        AND platform <> 'WEB'
        AND _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)) ),
      krok_2 AS (
      SELECT
        parse_DATE("%Y%m%d",
          event_date) true_date,
        FORMAT_DATE('%G%W',parse_DATE("%Y%m%d",
            event_date)) week_of_year,
        FORMAT_DATE('%Y%m',parse_DATE("%Y%m%d",
            event_date)) AS month_of_year,
        'APP' device,
        CONCAT(user_pseudo_id, CAST((
            SELECT
              value.int_value
            FROM
              UNNEST(event_params)
            WHERE
              key = 'ga_session_id') AS STRING)) id,
        event_timestamp,
        user_pseudo_id
      FROM
        `empik-mobile-app.analytics_183670685.events_*`
      WHERE
        event_name = 'cart_summary_view'
        AND platform <> 'WEB'
        AND _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)) ),
      krok_3 AS (
      SELECT
        parse_DATE("%Y%m%d",
          event_date) true_date,
        FORMAT_DATE('%G%W',parse_DATE("%Y%m%d",
            event_date)) week_of_year,
        FORMAT_DATE('%Y%m',parse_DATE("%Y%m%d",
            event_date)) AS month_of_year,
        'APP' device,
        CONCAT(user_pseudo_id, CAST((
            SELECT
              value.int_value
            FROM
              UNNEST(event_params)
            WHERE
              key = 'ga_session_id') AS STRING)) id,
        event_timestamp,
        user_pseudo_id
      FROM
        `empik-mobile-app.analytics_183670685.events_*`
      WHERE
        event_name IN ('purchase',
          'ecommerce_purchase')
        AND platform <> 'WEB'
        AND _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)) )
    SELECT
      k1.true_date,
      k1.week_of_year,
      k1.month_of_year,
      k1.device,
      COUNT(DISTINCT k1.id) cart,
      COUNT(DISTINCT k2.id) delivery_payment,
      COUNT(DISTINCT k3.id) purchase,
    FROM
      krok_1 k1
    LEFT JOIN
      krok_2 k2
    ON
      (k1.true_date = k2.true_date
        AND k1.id = k2.id
        AND k1.event_timestamp < k2.event_timestamp)
    LEFT JOIN
      krok_3 k3
    ON
      (k2.true_date = k3.true_date
        AND k2.id = k3.id
        AND k2.event_timestamp < k3.event_timestamp)
    GROUP BY
      1,
      2,
      3,
      4 )
  GROUP BY
    1,
    2,
    3,
    4)
ORDER BY
  1 DESC