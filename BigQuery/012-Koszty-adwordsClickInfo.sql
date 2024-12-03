%%bigquery --project produkcja-instore

    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'modivo.pl'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `modivo-237010.191117789.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'modivo.cz'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `modivo-237010.195419120.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'modivo.sk'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `modivo-237010.197305482.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'modivo.bg'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `modivo-237010.198150516.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'modivo.de'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `modivo-237010.198154225.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'modivo.lt'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `modivo-237010.198163047.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'modivo.gr'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `modivo-237010.198189162.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'modivo.hu'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `modivo-237010.198211271.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'modivo.ro'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `modivo-237010.197538241.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'modivo.it'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `modivo-237010.198209158.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'modivo.fr'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `modivo-237010.198167855.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'modivo.hr'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `modivo-237010.234756062.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'modivo.ua'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `modivo-237010.198191219.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'BG'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.124360956.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'CH'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.201751441.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'CZ'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.75385167.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'SK'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.139597678.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'LT'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.146034219.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'GR'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.150943533.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'IT'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.171059603.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'ES'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.173712545.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'FR'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.179902241.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'DE'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.86125562.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'EU'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.4743067.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'HR'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.220106830.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'HU'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.109784473.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'PL'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.3869171.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'RO'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.102283488.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'SE'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.166613794.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'UA'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.117916521.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'RU'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.123686680.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all



    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'SI'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `eobuwie-181013.239978547.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20210601' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
union all




    SELECT campaign, campaignId, kraj
from
(SELECT date,trafficSource.campaign, totals.visits, trafficSource.adwordsClickInfo.campaignId, 'gino.pl'  as kraj,  RANK() OVER(PARTITION BY trafficSource.adwordsClickInfo.campaignId ORDER BY date DESC, totals.visits desc, rand() desc) AS rank
FROM `gino-rossi-marketing.173879632.ga_sessions_*` WHERE
_TABLE_SUFFIX BETWEEN '20190101' and
FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) and  trafficSource.adwordsClickInfo.campaignId is not null
group by 1,2,3,4,5
order by 2 asc, 1 desc
)
where
rank=1
group by 1,2,3
limit 5