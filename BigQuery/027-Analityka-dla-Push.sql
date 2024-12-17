with app_push_robocza as
(SELECT
    event_date,
    TIMESTAMP_MICROS(event_timestamp) as event_timestamp, -- (np. 2022-10-28 01:26:41.975012 UTC)
    TIMESTAMP_ADD(TIMESTAMP_MICROS(event_timestamp), INTERVAL 48 HOUR) as end_window, -- Dwa dni do przodu (np. 2022-10-30 01:26:41.975012 UTC)
    device.operating_system,
    event_name,
    event_params.value.int_value,
    user_pseudo_id

FROM `produkcja-mobile.analytics_152051616.events_*`, unnest(event_params) as event_params
where event_name like '%notification_open%'
and event_params.key like 'ga_session_number'
and _TABLE_SUFFIX BETWEEN '20210514' AND FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
),



notyfikacje as
(SELECT
    event_date,
    format_date('%H', DATETIME(TIMESTAMP_MICROS(event_timestamp), 'Europe/Amsterdam')) hour, # (np. 03)
    case when geo.country="Poland" then 'PL'
    when geo.country="Romania" then 'RO'
    when geo.country="Bulgaria" then "BG"
    when geo.country="Hungary" then "HU"
    when geo.country="Ukraine" then "UA"
    when geo.country="Russia" then "UA"
    when geo.country="Slovakia" then "SK"
    when geo.country="Greece" then "GR"
    when geo.country="Lithuania" then "LT"
    when geo.country="Italy" then "IT"
    when geo.country="France" then "FR"
    when geo.country="Spain" then "ES"
    when geo.country="Germany" then "DE"
    when geo.country="Sweden" then "SE"
    when geo.country="Czechia" then "CZ"
    when geo.country="Switzerland" then "CH"
    when geo.country="Croatia" then "HR"
    when geo.country="Slovenia" then "SI"
    else "PL" END as kraj,
    device.operating_system,
    event_name,
    user_pseudo_id
FROM `produkcja-mobile.analytics_152051616.events_*`
where (event_name like '%notification_open%' or event_name like '%notification_receive%' or event_name like '%app_remove%')
and _TABLE_SUFFIX BETWEEN '20210514' AND FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6
),


app_push_dziennie as
(Select
    event_date,
    format_date('%H',DATETIME(TIMESTAMP_MICROS(event_timestamp), 'Europe/Amsterdam')) hour,
    event_name,
    user_pseudo_id,
    case when geo.country="Poland" then 'PL'
    when geo.country="Romania" then 'RO'
    when geo.country="Bulgaria" then "BG"
    when geo.country="Hungary" then "HU"
    when geo.country="Ukraine" then "UA"
    when geo.country="Russia" then "UA"
    when geo.country="Slovakia" then "SK"
    when geo.country="Greece" then "GR"
    when geo.country="Lithuania" then "LT"
    when geo.country="Italy" then "IT"
    when geo.country="France" then "FR"
    when geo.country="Spain" then "ES"
    when geo.country="Germany" then "DE"
    when geo.country="Sweden" then "SE"
    when geo.country="Czechia" then "CZ"
    when geo.country="Switzerland" then "CH"
    when geo.country="Croatia" then "HR"
    when geo.country="Slovenia" then "SI"
    else "PL" END as kraj,
    device.operating_system,
    key1.value.int_value,
    event_value_in_usd
from `produkcja-mobile.analytics_152051616.events_*`, unnest(event_params) as key1, UNNEST(event_params) as arr1
where (event_name like '%purchase%' and key1.key like 'ga_session_number')
and _TABLE_SUFFIX BETWEEN '20210514' AND FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))

# łączę ID sesji i ID użytkownika (zakup w którym był odpalony event notyfikacji)
and concat(key1.value.int_value,'spacja',user_pseudo_id) in (Select concat(int_value,'spacja',user_pseudo_id) from app_push_robocza)
group by 1,2,3,4,5,6,7,8),


okno_konwersji as (
Select
    event_date,
    TIMESTAMP_MICROS(s.event_timestamp) as start_timestamp, # (np. 2022-10-28 01:26:41.975012 UTC)
    format_date('%H',DATETIME(TIMESTAMP_MICROS(s.event_timestamp), 'Europe/Amsterdam')) hour, # (np. 03)
    event_name,
    s.user_pseudo_id,
    case when geo.country="Poland" then 'PL'
    when geo.country="Romania" then 'RO'
    when geo.country="Bulgaria" then "BG"
    when geo.country="Hungary" then "HU"
    when geo.country="Ukraine" then "UA"
    when geo.country="Russia" then "UA"
    when geo.country="Slovakia" then "SK"
    when geo.country="Greece" then "GR"
    when geo.country="Lithuania" then "LT"
    when geo.country="Italy" then "IT"
    when geo.country="France" then "FR"
    when geo.country="Spain" then "ES"
    when geo.country="Germany" then "DE"
    when geo.country="Sweden" then "SE"
    when geo.country="Czechia" then "CZ"
    when geo.country="Switzerland" then "CH"
    when geo.country="Croatia" then "HR"
    when geo.country="Slovenia" then "SI"
    else "PL" END as kraj,
    device.operating_system,
    event_value_in_usd
from `produkcja-mobile.analytics_152051616.events_*` s

inner join

(Select
    user_pseudo_id,
    event_timestamp, # odpalenie eventu od push
    end_window # odpalenie eventu od push + 2D
from app_push_robocza group by 1,2,3) as cr_window # Dane app_push

on s.user_pseudo_id=cr_window.user_pseudo_id
and TIMESTAMP_MICROS(s.event_timestamp)>=cr_window.event_timestamp and TIMESTAMP_MICROS(s.event_timestamp)<cr_window.end_window # Wszystkie transakcje w oknie 2D od push

where
    (event_name like '%purchase%')
    and _TABLE_SUFFIX BETWEEN '20210514' AND FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
group by 1,2,3,4,5,6,7,8
),



app_push as ( # Wyniki KPI pochodzące z sesji w których był odpalony push
Select
    event_date,
    hour,
    operating_system,
    app_push_dziennie.kraj as kraj,
    count(*) as transakcje,
    sum(event_value_in_usd*t2.kurs) as przychod,

from app_push_dziennie
left join
(SELECT cast(format_date('%Y%m%d',date) as STRING) as date, kraj, kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie` where kraj='USD') as t2
on app_push_dziennie.event_date=t2.date
group by 1,2,3,4),


konwersja48 as ( # Wyniki KPI pochodzące z sesji w których był odpalony push w oknie 2D
Select
    event_date,
    hour,
    operating_system,
    okno_konwersji.kraj as kraj,
    count(*) as transakcje,
    sum(event_value_in_usd*t2.kurs) as przychod

from okno_konwersji
left join (SELECT cast(format_date('%Y%m%d',date) as STRING) as date, kraj, kurs FROM `elevated-honor-235814.analizy.kursy_wszystkie` where kraj='USD') as t2
on okno_konwersji.event_date=t2.date
group by 1,2,3,4),


nots as # Dane pochodzące od trzech eventów
(select
    n.event_date,
    n.hour,
    n.kraj,
    n.operating_system
from notyfikacje n # '%notification_open%' and '%notification_receive%' and '%app_remove%'
group by 1,2,3,4
)


select # Końcowa tabela
    n.event_date,
    n.hour,
    n.kraj as country,
    n.operating_system,

    nor.notification_receive, # notification_receive

    nop.notification_open, # notification_open

    ap.transakcje as transactions, # Wyniki KPI pochodzące z sesji w których był odpalony push
    ap.przychod as revenuePLN, # Wyniki KPI pochodzące z sesji w których był odpalony push

    cw.transakcje as transactions48, # Wyniki KPI pochodzące z sesji w których był odpalony push w oknie 2D
    cw.przychod as revenue48, # Wyniki KPI pochodzące z sesji w których był odpalony push w oknie 2D

    apr.app_remove # app_remove

from nots n

left join
(select event_date, hour, kraj, operating_system, count(*) as notification_open
from notyfikacje
where event_name='notification_open'
group by 1,2,3,4
) as nop on n.event_date=nop.event_date and n.kraj=nop.kraj and n.operating_system=nop.operating_system and n.hour=nop.hour

left join
(select event_date, hour, kraj, operating_system, count(*) as notification_receive
from notyfikacje
where event_name='notification_receive'
group by 1,2,3,4
) as nor on n.event_date=nor.event_date and n.kraj=nor.kraj and n.operating_system=nor.operating_system and n.hour=nor.hour

left join
(select event_date, hour, kraj, operating_system, count(*) as app_remove
from notyfikacje
where event_name='app_remove'
group by 1,2,3,4
) as apr on n.event_date=apr.event_date and n.kraj=apr.kraj and n.operating_system=apr.operating_system and n.hour=apr.hour


left join # Wyniki KPI pochodzące z sesji w których był odpalony push
app_push ap on n.event_date=ap.event_date and n.kraj=ap.kraj and n.operating_system=ap.operating_system and n.hour=ap.hour

left join # Wyniki KPI pochodzące z sesji w których był odpalony push w oknie 2D
konwersja48 cw on n.event_date=cw.event_date and n.kraj=cw.kraj and n.operating_system=cw.operating_system and cw.hour=ap.hour


order by event_date, n.hour, n.kraj
LIMIT 5