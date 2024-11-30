SELECT
    PARSE_DATE("%Y%m%d", t1.date) AS date,
    t1.transaction_ID,
    t1.Seesion_ID AS visit_ID,
    t1.user_pseudo_id,
    t1.source_fire,
    t2.source_AF,
    t1.medium_fire,
    t2.medium_AF,
    t2.campaign_AF,
    t2.installTime,
    t2.purchaseTime,
    t2.uniqueID,
    t2.deviceCategory,
    t2.brand,
    t2.country,
    IFNULL(t3.hostname, t2.country) AS domain,
    t2.project_gcp
FROM (
    SELECT
        event_date AS date,
        event_name,
        (SELECT value.string_value
         FROM UNNEST(event_params)
         WHERE key = "transaction_id") AS transaction_ID,
        (SELECT value.int_value
         FROM UNNEST(event_params)
         WHERE key = "ga_session_id") AS Seesion_ID,
        traffic_source.name AS source_name_fire,
        traffic_source.medium AS medium_fire,
        traffic_source.source AS source_fire,
        user_pseudo_id
    FROM `mod-mobile-app-production.analytics_212969813.events_*`
    WHERE event_name LIKE ("%purchase%")
      AND _TABLE_SUFFIX BETWEEN '20190101' AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    GROUP BY 1, 2, 3, 4, 5, 6, 7, 8

    UNION ALL

    SELECT
        event_date AS date,
        event_name,
        (SELECT value.string_value
         FROM UNNEST(event_params)
         WHERE key = "transaction_id") AS transaction_ID,
        (SELECT value.int_value
         FROM UNNEST(event_params)
         WHERE key = "ga_session_id") AS Seesion_ID,
        traffic_source.name AS source_name_fire,
        traffic_source.medium AS medium_fire,
        traffic_source.source AS source_fire,
        user_pseudo_id
    FROM `produkcja-mobile.analytics_152051616.events_*`
    WHERE event_name LIKE ("%purchase%")
      AND _TABLE_SUFFIX BETWEEN '20190101' AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    GROUP BY 1, 2, 3, 4, 5, 6, 7, 8
) AS t1
LEFT JOIN (
    SELECT
        EXTRACT(DATE FROM CAST(event_time AS DATETIME)) AS date,
        REPLACE(JSON_EXTRACT(event_value, "$.af_order_id"), '"', '') AS transactionId,
        media_source AS source_AF,
        'no_data' AS medium_AF,
        campaign AS campaign_AF,
        install_time_selected_timezone AS installTime,
        event_time_selected_timezone AS purchaseTime,
        appsflyer_id AS uniqueID,
        'no_data' AS visitid,
        'app' AS deviceCategory,
        'Eobuwie' AS brand,
        country_code AS country,
        'no_data' AS domain,
        CONCAT('eobuwie-181013', '01_AppsFlyer_EOB') AS project_gcp
    FROM `eobuwie-181013.01_AppsFlyer_EOB.mobile_devices_events`
    WHERE partition_time > PARSE_DATE("%Y%m%d", '20190101')
      AND partition_time < DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)
      AND event_name LIKE 'af_purchase'
      AND is_retargeting = FALSE
    GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12

    UNION ALL

    SELECT
        EXTRACT(DATE FROM CAST(event_time AS DATETIME)) AS date,
        REPLACE(JSON_EXTRACT(event_value, "$.af_order_id"), '"', '') AS transactionId,
        media_source AS source_AF,
        'no_data' AS medium_AF,
        campaign AS campaign_AF,
        install_time_selected_timezone AS installTime,
        event_time_selected_timezone AS purchaseTime,
        appsflyer_id AS uniqueID,
        'no_data' AS visitid,
        'app' AS deviceCategory,
        'Modivo' AS brand,
        country_code AS country,
        'no_data' AS domain,
        CONCAT('eobuwie-181013', '01_AppsFlyer_MOD') AS project_gcp
    FROM `eobuwie-181013.01_AppsFlyer_MOD.mobile_devices_events`
    WHERE partition_time > PARSE_DATE("%Y%m%d", '20190101')
      AND partition_time < DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)
      AND event_name LIKE 'af_purchase'
      AND is_retargeting = FALSE
    GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
) AS t2
ON t1.transaction_ID = t2.transactionId
LEFT JOIN `elevated-honor-235814.dmaliszewski.tables_s` AS t3
ON t2.country = t3.country
LIMIT 5;