SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Modivo' as brand,
                    'PL' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `modivo-237010.191117789.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Modivo' as brand,
                    'CZ' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `modivo-237010.195419120.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Modivo' as brand,
                    'SK' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `modivo-237010.197305482.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Modivo' as brand,
                    'BG' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `modivo-237010.198150516.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Modivo' as brand,
                    'DE' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `modivo-237010.198154225.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Modivo' as brand,
                    'LT' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `modivo-237010.198163047.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Modivo' as brand,
                    'GR' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `modivo-237010.198189162.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Modivo' as brand,
                    'HU' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `modivo-237010.198211271.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Modivo' as brand,
                    'RO' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `modivo-237010.197538241.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Modivo' as brand,
                    'IT' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `modivo-237010.198209158.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Modivo' as brand,
                    'FR' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `modivo-237010.198167855.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Modivo' as brand,
                    'HR' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `modivo-237010.234756062.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'BG' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.124360956.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'CH' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.201751441.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'CZ' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.75385167.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'SK' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.139597678.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'LT' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.146034219.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'GR' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.150943533.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'IT' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.171059603.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'ES' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.173712545.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'FR' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.179902241.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'DE' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.86125562.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'EU' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.4743067.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'HR' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.220106830.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'HU' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.109784473.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'PL' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.3869171.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'RO' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.102283488.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'SE' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.166613794.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'UA' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.117916521.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Eobuwie' as brand,
                    'RU' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `eobuwie-181013.123686680.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
                union all
SELECT
                    parse_date('%Y%m%d',date) as date,
                    'Gino Rossi' as brand,
                    'PL' as kraj,
                    count(distinct transaction.transactionId) as unikalne_transakcje,
                    count(transaction.transactionId) as transakcje,
                    IF(count(transaction.transactionId)/count(distinct transaction.transactionId)>1.03,1,0) as flaga
                FROM `gino-rossi-marketing.173879632.ga_sessions_*`, unnest(hits)
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    and transaction.transactionId is not null
                group by 1,2,3
limit 5