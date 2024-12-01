%%bigquery --project produkcja-instore

SELECT ga.date, PARSE_DATE('%Y%m%d', CAST(ga.date AS STRING)) as true_date, ga.kraj as country,
ga.biznes biznes, ga.sesje as visits, ga.przychod as totalTransactionRevenue, ga.transakcje as transactions,
ga.deviceCategory, currency.rate, ga.przychod*currency.rate as RevenuePLN

from (
(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'PL' as kraj, 'EOB' biznes
FROM `eobuwie-181013.3869171.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'RO' as kraj, 'EOB' biznes
FROM `eobuwie-181013.102283488.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'HU' as kraj, 'EOB' biznes
FROM `eobuwie-181013.109784473.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'UA' as kraj, 'EOB' biznes
FROM `eobuwie-181013.117916521.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'RU' as kraj, 'EOB' biznes
FROM `eobuwie-181013.123686680.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'BG' as kraj, 'EOB' biznes
FROM `eobuwie-181013.124360956.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'SK' as kraj, 'EOB' biznes
FROM `eobuwie-181013.139597678.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'LT' as kraj, 'EOB' biznes
FROM `eobuwie-181013.146034219.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'GR' as kraj, 'EOB' biznes
FROM `eobuwie-181013.150943533.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'SE' as kraj, 'EOB' biznes
FROM `eobuwie-181013.166613794.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'IT' as kraj, 'EOB' biznes
FROM `eobuwie-181013.171059603.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'ES' as kraj, 'EOB' biznes
FROM `eobuwie-181013.173712545.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'FR' as kraj, 'EOB' biznes
FROM `eobuwie-181013.179902241.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'DE' as kraj, 'EOB' biznes
FROM `eobuwie-181013.86125562.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'CZ' as kraj, 'EOB' biznes
FROM `eobuwie-181013.75385167.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'HR' as kraj, 'EOB' biznes
FROM `eobuwie-181013.220106830.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'PL' as kraj, 'MOD' biznes
FROM `modivo-237010.191117789.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'CZ' as kraj, 'MOD' biznes
FROM `modivo-237010.195419120.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'SK' as kraj, 'MOD' biznes
FROM `modivo-237010.197305482.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'RO' as kraj, 'MOD' biznes
FROM `modivo-237010.197538241.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'HU' as kraj, 'MOD' biznes
FROM `modivo-237010.198211271.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'BG' as kraj, 'MOD' biznes
FROM `modivo-237010.198150516.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'GR' as kraj, 'MOD' biznes
FROM `modivo-237010.198189162.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'LT' as kraj, 'MOD' biznes
FROM `modivo-237010.198163047.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'DE' as kraj, 'MOD' biznes
FROM `modivo-237010.198154225.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'FR' as kraj, 'MOD' biznes
FROM `modivo-237010.198167855.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'HR' as kraj, 'MOD' biznes
FROM `modivo-237010.234756062.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'UA' as kraj, 'MOD' biznes
FROM `modivo-237010.198191219.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'CH' as kraj, 'EOB' biznes
FROM `eobuwie-181013.201751441.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'SI' as kraj, 'EOB' biznes
FROM `eobuwie-181013.239978547.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'PL' as kraj, 'GINO' biznes
FROM `gino-rossi-marketing.173879632.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7)

union all

(SELECT date, sum(totals.visits) as sesje, sum(totals.totalTransactionRevenue/1000000) as przychod, sum(totals.transactions) as transakcje,
Device.deviceCategory, 'IT' as kraj, 'MOD' biznes
FROM `modivo-237010.198209158.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20200101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,5,6,7))) ga

left join

(SELECT date, kurs as rate, kraj from `elevated-honor-235814.analizy.kursy_wszystkie`) as currency
on ga.kraj=currency.kraj and PARSE_DATE('%Y%m%d', CAST(ga.date AS STRING))=currency.date
limit 5