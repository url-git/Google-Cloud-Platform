with
all_dates as (SELECT
  date,
FROM UNNEST(GENERATE_DATE_ARRAY('2018-01-01', CURRENT_DATE())) date
ORDER BY date),

BGN_avg as (SELECT format_date('%Y%m',date) as ym,avg(close) as av from `elevated-honor-235814.currency_exchange_rates.bgn_pln` where close>0 group by 1),
EUR_avg as (SELECT format_date('%Y%m',date) as ym,avg(close) as av from `elevated-honor-235814.currency_exchange_rates.eur_pln` where close>0 group by 1),
CZK_avg as (SELECT format_date('%Y%m',date) as ym,avg(close) as av from `elevated-honor-235814.currency_exchange_rates.czk_pln` where close>0 group by 1),
CHF_avg as (SELECT format_date('%Y%m',date) as ym,avg(close) as av from `elevated-honor-235814.currency_exchange_rates.chf_pln` where close>0 group by 1),
HUF_avg as (SELECT format_date('%Y%m',date) as ym,avg(close) as av from `elevated-honor-235814.currency_exchange_rates.huf_pln` where close>0 group by 1),
RON_avg as (SELECT format_date('%Y%m',date) as ym,avg(close) as av from `elevated-honor-235814.currency_exchange_rates.ron_pln` where close>0 group by 1),
SEK_avg as (SELECT format_date('%Y%m',date) as ym,avg(close) as av from `elevated-honor-235814.currency_exchange_rates.sek_pln` where close>0 group by 1),
UAH_avg as (SELECT format_date('%Y%m',date) as ym,avg(close) as av from `elevated-honor-235814.currency_exchange_rates.uah_pln` where close>0 group by 1),
HRK_avg as (SELECT format_date('%Y%m',date) as ym,avg(close) as av from `elevated-honor-235814.currency_exchange_rates.hrk_pln` where close>0 group by 1),
USD_avg as (SELECT format_date('%Y%m',date) as ym,avg(close) as av from `elevated-honor-235814.currency_exchange_rates.usd_pln` where close>0 group by 1),


BGN as (SELECT all_dates.date,coalesce(c.close,a.av) as close from all_dates left join `elevated-honor-235814.currency_exchange_rates.bgn_pln` c on all_dates.date=c.date left join BGN_avg a on format_date('%Y%m',all_dates.date)=a.ym),
EUR as (SELECT all_dates.date,coalesce(c.close,a.av) as close from all_dates left join `elevated-honor-235814.currency_exchange_rates.eur_pln` c on all_dates.date=c.date left join EUR_avg a on format_date('%Y%m',all_dates.date)=a.ym),
CZK as (SELECT all_dates.date,coalesce(c.close,a.av) as close from all_dates left join `elevated-honor-235814.currency_exchange_rates.czk_pln` c on all_dates.date=c.date left join CZK_avg a on format_date('%Y%m',all_dates.date)=a.ym),
CHF as (SELECT all_dates.date,coalesce(c.close,a.av) as close from all_dates left join `elevated-honor-235814.currency_exchange_rates.chf_pln` c on all_dates.date=c.date left join CHF_avg a on format_date('%Y%m',all_dates.date)=a.ym),
HUF as (SELECT all_dates.date,coalesce(c.close,a.av) as close from all_dates left join `elevated-honor-235814.currency_exchange_rates.huf_pln` c on all_dates.date=c.date left join HUF_avg a on format_date('%Y%m',all_dates.date)=a.ym),
RON as (SELECT all_dates.date,coalesce(c.close,a.av) as close from all_dates left join `elevated-honor-235814.currency_exchange_rates.ron_pln` c on all_dates.date=c.date left join RON_avg a on format_date('%Y%m',all_dates.date)=a.ym),
SEK as (SELECT all_dates.date,coalesce(c.close,a.av) as close from all_dates left join `elevated-honor-235814.currency_exchange_rates.sek_pln` c on all_dates.date=c.date left join SEK_avg a on format_date('%Y%m',all_dates.date)=a.ym),
HRK as (SELECT all_dates.date,coalesce(c.close,a.av) as close from all_dates left join `elevated-honor-235814.currency_exchange_rates.hrk_pln` c on all_dates.date=c.date left join HRK_avg a on format_date('%Y%m',all_dates.date)=a.ym),
UAH as (SELECT all_dates.date,coalesce(c.close,a.av) as close from all_dates left join `elevated-honor-235814.currency_exchange_rates.uah_pln` c on all_dates.date=c.date left join UAH_avg a on format_date('%Y%m',all_dates.date)=a.ym),
USD as (SELECT all_dates.date,coalesce(c.close,a.av) as close from all_dates left join `elevated-honor-235814.currency_exchange_rates.usd_pln` c on all_dates.date=c.date left join USD_avg a on format_date('%Y%m',all_dates.date)=a.ym)


SELECT date, kraj, waluta.close as kurs from BGN as waluta, unnest(array['BG','BGN']) as kraj
union all
SELECT date, kraj, waluta.close as kurs from UAH as waluta, unnest(array['UA','UAH','RU','RUB']) as kraj
union all
SELECT date, kraj, waluta.close as kurs from CZK as waluta, unnest(array['CZ','CZK']) as kraj
union all
SELECT date, kraj, waluta.close as kurs from RON as waluta, unnest(array['RON','RO']) as kraj
union all
SELECT date, kraj, waluta.close as kurs from HUF as waluta, unnest(array['HU','HUF']) as kraj
union all
SELECT date, kraj, waluta.close as kurs from SEK as waluta, unnest(array['SE','SEK']) as kraj
union all
SELECT date, kraj, waluta.close as kurs from CHF as waluta, unnest(array['CH','CHF']) as kraj
union all
SELECT date, kraj, waluta.close as kurs from HRK as waluta, unnest(array['HRK','HR']) as kraj
union all
SELECT date, kraj, waluta.close as kurs from USD as waluta, unnest(array['USD','US']) as kraj
union all

SELECT all_dates.date, kraj, 1 as kurs from all_dates, unnest(array['PLN','PL','modivo.bg',
'modivo.ru','modivo.ua','modivo.cz','modivo.de','modivo.es','modivo.eu','modivo.gr','modivo.hu','modivo.lt','modivo.pl','modivo.ro','modivo.se','modivo.sk','modivo.it','modivo.fr','modivo.hr','gino.pl','APP_EOB']) as kraj
union all
SELECT date, kraj, waluta.close as kurs from EUR as waluta, unnest(array['EUR','EU','DE','ES','FR','IT','LT','SK','GR','SI']) as kraj
order by 1 desc
limit 5