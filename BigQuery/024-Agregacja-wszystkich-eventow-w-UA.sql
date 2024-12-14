SELECT date, 'RO' country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.102283488.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'PL' country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.3869171.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'HU' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.109784473.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'UA' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.117916521.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'RU' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.123686680.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'BG' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.124360956.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'SK' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.139597678.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'LT' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.146034219.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'GR' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.150943533.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'SE' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.166613794.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'IT' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.171059603.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'ES' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.173712545.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'FR' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.179902241.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'CZ' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.75385167.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'DE' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.86125562.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'CH' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.201751441.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'HR' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.220106830.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'EU' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.4743067.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7

union all
SELECT date, 'SI' as country, 'EOB' biznes, hits.eventInfo.eventCategory, hits.eventInfo.eventAction,
hits.eventInfo.eventLabel, device.deviceCategory,
COUNT(hits.eventInfo.eventCategory) totalEvents,
COUNT(DISTINCT CONCAT(fullvisitorid, CAST(visitstarttime AS string),
COALESCE(hits.eventInfo.eventAction,''),
COALESCE(hits.eventInfo.eventLabel, ''),
COALESCE(hits.eventInfo.eventCategory,''))) uniqueEvents
FROM `eobuwie-181013.239978547.ga_sessions_*`, unnest(hits) as hits
WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7