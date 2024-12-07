with prep as (select
app_name,
format_date('%Y%m',extract(date from cast(event_time as DATETIME))) month_of_year,
case
when country_code like 'GR' then 'GR'
when country_code like 'UA' then 'UA'
when country_code like 'SK' then 'SK'
when country_code like 'CZ' then 'CZ'
when country_code like 'BG' then 'BG'
when country_code like 'PL' then 'PL'
when country_code like 'HU' then 'HU'
when country_code like 'RO' then 'RO'
when country_code like 'IT' then 'IT'
when country_code like 'DE' then 'DE'
when country_code like 'ES' then 'ES'
when country_code like 'FR' then 'FR'
when country_code like 'SE' then 'SE'
when country_code like 'RU' then 'RU'
when country_code like 'CH' then 'CH'
when country_code like 'LT' then 'LT'
else 'PL' END as country,
case when regexp_contains(media_source, r'(?i)(Owned_media|User_invite|homefooterpl|organic|Social_facebook|succespagepl)') then 'organic'
when af_channel like 'af_web_smartscript' then 'organic'
when af_channel like '%mweb_banner%' then 'organic'
when regexp_contains(campaign, r'(?i)(Owned_media)') then 'organic'
else 'paid' end split,
coalesce(media_source, af_prt) source,
count(*) instalacje
from `eobuwie-181013.01_AppsFlyer_MOD.mobile_devices_events`
where event_name like 'install'
group by 1,2,3,4,5

union all

select
app_name,
format_date('%Y%m',extract(date from cast(event_time as DATETIME))) month_of_year,
case
when country_code like 'GR' then 'GR'
when country_code like 'UA' then 'UA'
when country_code like 'SK' then 'SK'
when country_code like 'CZ' then 'CZ'
when country_code like 'BG' then 'BG'
when country_code like 'PL' then 'PL'
when country_code like 'HU' then 'HU'
when country_code like 'RO' then 'RO'
when country_code like 'IT' then 'IT'
when country_code like 'DE' then 'DE'
when country_code like 'ES' then 'ES'
when country_code like 'FR' then 'FR'
when country_code like 'SE' then 'SE'
when country_code like 'RU' then 'RU'
when country_code like 'CH' then 'CH'
when country_code like 'LT' then 'LT'
else 'PL' END as country,
case when regexp_contains(media_source, r'(?i)(BF LP|App10promo|af_banner|Owned_media|af_smartbanner|organic)') then 'organic'
when af_channel like 'af_web_banner' then 'organic'
when af_channel like '%mweb_banner%' then 'organic'
else 'paid' end split,
coalesce(media_source, af_prt) source,
count(*) instalacje

from `eobuwie-181013.01_AppsFlyer_EOB.mobile_devices_events`
where event_name like 'install'
group by 1,2,3,4,5)

select app_name, month_of_year, country, split, sum(instalacje) install
from prep
where source != 'multichanelnetw'
group by 1,2,3,4
order by 1, 2 desc, 4 desc, 5 desc
limit 5