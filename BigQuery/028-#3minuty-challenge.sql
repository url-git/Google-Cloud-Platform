with t as (
Select
event_name,
(Select cast(event_params.value.int_value as string) from unnest(event_params) as event_params where event_params.key='location_id') as POS,
(Select event_params.value.string_value from unnest(event_params) as event_params where event_params.key='result') as rezultat, #  "exit" - "no_discount" - "-20%" - "-30%" - "-50%" - "-40%" - "1zl"
(Select event_params.value.string_value from unnest(event_params) as event_params where event_params.key='decision') as decyzja # "czas_start" - "exit"
FROM `produkcja-instore.analytics_157065756.events_*`

where _TABLE_SUFFIX BETWEEN '20210527' AND FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
AND event_name in ('challenge_3min_show_landing_page', 'challenge_3min_first_step', 'challenge_3min_stopwatch'))

Select
event_name,
case when POS="2" then "Zielona Góra - CH Focus Mall"
when POS="3" then "Wrocław - CH Magnolia Park"
when POS="6" then "Poznań - CH Posnania"
when POS="7" then "Lubin - CH Cuprum Arena"
when POS="8" then "Warszawa - CH Atrium Promenada"
when POS="9" then "Kielce - CH Korona"
when POS="10" then "Wyspy esize.me"
when POS="11" then "Bydgoszcz - CH Zielone Arkady"
when POS="12" then "Rzeszów - Galeria Rzeszów"
when POS="13" then "Katowice - CH Libero"
when POS="14" then "Opole - CH Karolinka"
when POS="15" then "Olsztyn - Galeria Warmińska"
when POS="16" then "Warszawa - CH Wars Sawa Junior"
when POS="17" then "Gdańsk - CH Forumk"
when POS="18" then "Foot Truck"
when POS="19" then "Janki - CH Janki"
when POS="22" then "Nowy Kisielin - Magazyn"
when POS="23" then "Poznań - CH Stary Browar"
when POS="24" then "Lublin - CH Vivo!"
when POS="25" then "Bielsko-Biała - CH Sfera"
when POS="27" then "Gdynia - CH Riviera"
when POS="29" then "Katowice - CH Silesia"
when POS="30" then "Toruń - Atrium Copernicus"
when POS="35" then "Częstochowa - CH Galeria Jurajska"
when POS="37" then "Warszawa - Galeria Północna"
when POS="38" then "Warszawa - Westfield Arkadia"
when POS="39" then "Warszawa - Galeria Mokotów"
when POS="43" then "Szczecin - CH Galaxy"
when POS="44" then "Warszawa - CH Młociny"
when POS="46" then "Wrocław - CH Wroclavia"
else "other" END as POS,
rezultat,
decyzja,
count(*) as odpalenie_eventu

from t
group by 1,2,3,4
order by 1,3,4
LIMIT 5