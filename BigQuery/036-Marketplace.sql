select
    event_date,
    week_of_year,
    month_of_year,
    czy_afiliacja,
    count(distinct wszyscy) wszyscy,
    count(distinct dane_firmy) dane_firmy,
    count(distinct dane_kontaktowe) dane_kontaktowe,
    count(distinct oferta_sprzedawcy) oferta_sprzedawcy,
    count(distinct dane_uzytkownika_konta) dane_uzytkownika_konta,
    count(distinct wyslanie_zgloszenia) wyslanie_zgloszenia

from (
select
    # parse_date('%Y%m%d',event_date) as session_date
    event_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) wszyscy,
    case when (select value.string_value from unnest(event_params) where key = 'merchant_affiliation') is not null then true else false end czy_afiliacja,
    case when (select value.string_value from unnest(event_params) where key = 'step_form') = 'Dane Firmy' then
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) else null end dane_firmy,
    case when (select value.string_value from unnest(event_params) where key = 'step_form') = 'Dane Kontaktowe' then
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) else null end dane_kontaktowe,
    case when (select value.string_value from unnest(event_params) where key = 'step_form') = 'Oferta Sprzedawcy' then
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) else null end oferta_sprzedawcy,
    case when (select value.string_value from unnest(event_params) where key = 'step_form') = 'Dane użytkownika konta' then
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) else null end dane_uzytkownika_konta,
    case when (select value.string_value from unnest(event_params) where key = 'step_form') = 'Wysłanie Zgłoszenia' then
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as STRING)) else null end wyslanie_zgloszenia,

from
    `empik-mobile-app.analytics_183670685.events_*`
where
    event_name = 'Markplace'
    -- and _table_suffix between '20220106' and '20220106'
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    and regexp_extract(_table_suffix, '[0-9]+') between '20220120' and format_date('%Y%m%d', current_date())
)
group by 1,2,3,4