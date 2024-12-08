with a as (SELECT
    extract(date from cast(event_time as DATETIME)) as date,
    app_name,
    event_name,
    coalesce(media_source, af_prt) media_source,
    platform sys_operacyjny,
    contributor_1_af_prt,
    contributor_2_af_prt,
    contributor_3_af_prt
FROM `eobuwie-181013.01_AppsFlyer_EOB.mobile_devices_events`
where partition_time > '2021-06-01'
and contributor_1_af_prt like 'multichanelnetw' or contributor_2_af_prt like 'multichanelnetw' or contributor_3_af_prt like 'multichanelnetw'
and event_name like 'af_purchase'

union all

SELECT
    extract(date from cast(event_time as DATETIME)) as date,
    app_name,
    event_name,
    coalesce(media_source, af_prt) media_source,
    platform sys_operacyjny,
    contributor_1_af_prt,
    contributor_2_af_prt,
    contributor_3_af_prt
FROM `eobuwie-181013.01_AppsFlyer_MOD.mobile_devices_events`
where partition_time > '2021-06-01'
and contributor_1_af_prt like 'multichanelnetw' or contributor_2_af_prt like 'multichanelnetw' or contributor_3_af_prt like 'multichanelnetw'
and event_name = 'af_purchase')

select *
from a
order by 1,2 desc
limit 5