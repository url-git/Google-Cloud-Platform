with v1 as (

select
true_date,
week_of_year,
month_of_year,
device,
typ_koszyka_category,
count(distinct v1) v1

from (

select
true_date,
week_of_year,
month_of_year,
device,
item_category,
typ_koszyka,

case when
item_category in ('Książki', 'Szkolne i papiernicze', 'Muzyka', 'Gry i programy', 'Audiobooki i Ebooki', 'Prasa', 'Filmy', 'Książki obcojęzyczne')
and typ_koszyka = 'mieszane' then 'edito_mieszane'
when
item_category in ('Książki', 'Szkolne i papiernicze', 'Muzyka', 'Gry i programy', 'Audiobooki i Ebooki', 'Prasa', 'Filmy', 'Książki obcojęzyczne')
and typ_koszyka = 'multi_merchant' then 'edito_multi_merchant'
when
item_category in ('Książki', 'Szkolne i papiernicze', 'Muzyka', 'Gry i programy', 'Audiobooki i Ebooki', 'Prasa', 'Filmy', 'Książki obcojęzyczne')
and typ_koszyka = 'single_merchant' then 'edito_single_merchant'
when
item_category in ('Książki', 'Szkolne i papiernicze', 'Muzyka', 'Gry i programy', 'Audiobooki i Ebooki', 'Prasa', 'Filmy', 'Książki obcojęzyczne')
and typ_koszyka = 'empik' then 'edito_empik'
when
item_category in ('Książki', 'Szkolne i papiernicze', 'Muzyka', 'Gry i programy', 'Audiobooki i Ebooki', 'Prasa', 'Filmy', 'Książki obcojęzyczne')
and typ_koszyka = 'premium' then 'edito_premium'

when
item_category in ('Zabawki', 'Dom i ogród', 'Elektronika', 'Zdrowie i uroda', 'Sport', 'AGD', 'Dziecko i mama', 'PREMIUM', 'Moda', 'Motoryzacja', 'Przyjęcia i okazje', 'Delikatesy', 'Kolekcje własne')
and typ_koszyka = 'mieszane' then 'non_edito_mieszane'
when
item_category in ('Zabawki', 'Dom i ogród', 'Elektronika', 'Zdrowie i uroda', 'Sport', 'AGD', 'Dziecko i mama', 'PREMIUM', 'Moda', 'Motoryzacja', 'Przyjęcia i okazje', 'Delikatesy', 'Kolekcje własne')
and typ_koszyka = 'multi_merchant' then 'non_edito_multi_merchant'
when
item_category in ('Zabawki', 'Dom i ogród', 'Elektronika', 'Zdrowie i uroda', 'Sport', 'AGD', 'Dziecko i mama', 'PREMIUM', 'Moda', 'Motoryzacja', 'Przyjęcia i okazje', 'Delikatesy', 'Kolekcje własne')
and typ_koszyka = 'single_merchant' then 'non_edito_single_merchant'
when
item_category in ('Zabawki', 'Dom i ogród', 'Elektronika', 'Zdrowie i uroda', 'Sport', 'AGD', 'Dziecko i mama', 'PREMIUM', 'Moda', 'Motoryzacja', 'Przyjęcia i okazje', 'Delikatesy', 'Kolekcje własne')
and typ_koszyka = 'empik' then 'non_edito_empik'
when
item_category in ('Zabawki', 'Dom i ogród', 'Elektronika', 'Zdrowie i uroda', 'Sport', 'AGD', 'Dziecko i mama', 'PREMIUM', 'Moda', 'Motoryzacja', 'Przyjęcia i okazje', 'Delikatesy', 'Kolekcje własne')
and typ_koszyka = 'premium' then 'non_edito_premium'

end typ_koszyka_category,

id v1,

from (

SELECT
  parse_DATE("%Y%m%d",event_date) true_date,
  FORMAT_DATE('%G%W',parse_DATE("%Y%m%d",event_date)) week_of_year,
  FORMAT_DATE('%Y%m',parse_DATE("%Y%m%d",event_date)) month_of_year,
  case when device.category like 'desktop' and platform like 'WEB' then 'DESKTOP_WEB'
  when device.category like 'mobile' and platform like 'WEB' then 'DESKTOP_MOB'
  when device.category like 'tablet' and platform like 'WEB' then 'DESKTOP_MOB'
  else 'DESKTOP_WEB' end device,
  CONCAT(user_pseudo_id, CAST((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS STRING)) id,
  user_pseudo_id,
  event_timestamp,
  items.item_category,
  (SELECT value.string_value FROM unnest(event_params) WHERE key = 'merchant_list2') typ_koszyka,
FROM
  `empik-mobile-app.analytics_183670685.events_*`, unnest(items) as items
WHERE
  event_name = 'begin_checkout'
  AND platform = 'WEB'
  AND (SELECT value.string_value FROM unnest(event_params) WHERE key = 'merchant_list2') is not null
  -- AND _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
  and REGEXP_EXTRACT(_table_suffix, '[0-9]+') BETWEEN '20221215' AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
)) group by 1,2,3,4,5),


v2 as (

select
true_date,
week_of_year,
month_of_year,
device,
typ_koszyka_category,
count(distinct v2) v2

from (

select
true_date,
week_of_year,
month_of_year,
device,
item_category,
typ_koszyka,

case when
item_category in ('Książki', 'Szkolne i papiernicze', 'Muzyka', 'Gry i programy', 'Audiobooki i Ebooki', 'Prasa', 'Filmy', 'Książki obcojęzyczne')
and typ_koszyka = 'mieszane' then 'edito_mieszane'
when
item_category in ('Książki', 'Szkolne i papiernicze', 'Muzyka', 'Gry i programy', 'Audiobooki i Ebooki', 'Prasa', 'Filmy', 'Książki obcojęzyczne')
and typ_koszyka = 'multi_merchant' then 'edito_multi_merchant'
when
item_category in ('Książki', 'Szkolne i papiernicze', 'Muzyka', 'Gry i programy', 'Audiobooki i Ebooki', 'Prasa', 'Filmy', 'Książki obcojęzyczne')
and typ_koszyka = 'single_merchant' then 'edito_single_merchant'
when
item_category in ('Książki', 'Szkolne i papiernicze', 'Muzyka', 'Gry i programy', 'Audiobooki i Ebooki', 'Prasa', 'Filmy', 'Książki obcojęzyczne')
and typ_koszyka = 'empik' then 'edito_empik'
when
item_category in ('Książki', 'Szkolne i papiernicze', 'Muzyka', 'Gry i programy', 'Audiobooki i Ebooki', 'Prasa', 'Filmy', 'Książki obcojęzyczne')
and typ_koszyka = 'premium' then 'edito_premium'

when
item_category in ('Zabawki', 'Dom i ogród', 'Elektronika', 'Zdrowie i uroda', 'Sport', 'AGD', 'Dziecko i mama', 'PREMIUM', 'Moda', 'Motoryzacja', 'Przyjęcia i okazje', 'Delikatesy', 'Kolekcje własne')
and typ_koszyka = 'mieszane' then 'non_edito_mieszane'
when
item_category in ('Zabawki', 'Dom i ogród', 'Elektronika', 'Zdrowie i uroda', 'Sport', 'AGD', 'Dziecko i mama', 'PREMIUM', 'Moda', 'Motoryzacja', 'Przyjęcia i okazje', 'Delikatesy', 'Kolekcje własne')
and typ_koszyka = 'multi_merchant' then 'non_edito_multi_merchant'
when
item_category in ('Zabawki', 'Dom i ogród', 'Elektronika', 'Zdrowie i uroda', 'Sport', 'AGD', 'Dziecko i mama', 'PREMIUM', 'Moda', 'Motoryzacja', 'Przyjęcia i okazje', 'Delikatesy', 'Kolekcje własne')
and typ_koszyka = 'single_merchant' then 'non_edito_single_merchant'
when
item_category in ('Zabawki', 'Dom i ogród', 'Elektronika', 'Zdrowie i uroda', 'Sport', 'AGD', 'Dziecko i mama', 'PREMIUM', 'Moda', 'Motoryzacja', 'Przyjęcia i okazje', 'Delikatesy', 'Kolekcje własne')
and typ_koszyka = 'empik' then 'non_edito_empik'
when
item_category in ('Zabawki', 'Dom i ogród', 'Elektronika', 'Zdrowie i uroda', 'Sport', 'AGD', 'Dziecko i mama', 'PREMIUM', 'Moda', 'Motoryzacja', 'Przyjęcia i okazje', 'Delikatesy', 'Kolekcje własne')
and typ_koszyka = 'premium' then 'non_edito_premium'

end typ_koszyka_category,

id v2,

from (

SELECT
  parse_DATE("%Y%m%d",event_date) true_date,
  FORMAT_DATE('%G%W',parse_DATE("%Y%m%d",event_date)) week_of_year,
  FORMAT_DATE('%Y%m',parse_DATE("%Y%m%d",event_date)) month_of_year,
  case when device.category like 'desktop' and platform like 'WEB' then 'DESKTOP_WEB'
  when device.category like 'mobile' and platform like 'WEB' then 'DESKTOP_MOB'
  when device.category like 'tablet' and platform like 'WEB' then 'DESKTOP_MOB'
  else 'DESKTOP_WEB' end device,
  CONCAT(user_pseudo_id, CAST((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS STRING)) id,
  user_pseudo_id,
  event_timestamp,
  items.item_category,
  (SELECT value.string_value FROM unnest(event_params) WHERE key = 'merchant_list2') typ_koszyka,
FROM
  `empik-mobile-app.analytics_183670685.events_*`, unnest(items) as items
WHERE
  event_name = 'add_payment_info'
  AND platform = 'WEB'
  AND (SELECT value.string_value FROM unnest(event_params) WHERE key = 'merchant_list2') is not null
  -- AND _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
  and REGEXP_EXTRACT(_table_suffix, '[0-9]+') BETWEEN '20221215' AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())



)) group by 1,2,3,4,5),


v3 as (

select
true_date,
week_of_year,
month_of_year,
device,
typ_koszyka_category,
count(distinct v3) v3

from (

select
true_date,
week_of_year,
month_of_year,
device,
item_category,
typ_koszyka,

case when
item_category in ('Książki', 'Szkolne i papiernicze', 'Muzyka', 'Gry i programy', 'Audiobooki i Ebooki', 'Prasa', 'Filmy', 'Książki obcojęzyczne')
and typ_koszyka = 'mieszane' then 'edito_mieszane'
when
item_category in ('Książki', 'Szkolne i papiernicze', 'Muzyka', 'Gry i programy', 'Audiobooki i Ebooki', 'Prasa', 'Filmy', 'Książki obcojęzyczne')
and typ_koszyka = 'multi_merchant' then 'edito_multi_merchant'
when
item_category in ('Książki', 'Szkolne i papiernicze', 'Muzyka', 'Gry i programy', 'Audiobooki i Ebooki', 'Prasa', 'Filmy', 'Książki obcojęzyczne')
and typ_koszyka = 'single_merchant' then 'edito_single_merchant'
when
item_category in ('Książki', 'Szkolne i papiernicze', 'Muzyka', 'Gry i programy', 'Audiobooki i Ebooki', 'Prasa', 'Filmy', 'Książki obcojęzyczne')
and typ_koszyka = 'empik' then 'edito_empik'
when
item_category in ('Książki', 'Szkolne i papiernicze', 'Muzyka', 'Gry i programy', 'Audiobooki i Ebooki', 'Prasa', 'Filmy', 'Książki obcojęzyczne')
and typ_koszyka = 'premium' then 'edito_premium'

when
item_category in ('Zabawki', 'Dom i ogród', 'Elektronika', 'Zdrowie i uroda', 'Sport', 'AGD', 'Dziecko i mama', 'PREMIUM', 'Moda', 'Motoryzacja', 'Przyjęcia i okazje', 'Delikatesy', 'Kolekcje własne')
and typ_koszyka = 'mieszane' then 'non_edito_mieszane'
when
item_category in ('Zabawki', 'Dom i ogród', 'Elektronika', 'Zdrowie i uroda', 'Sport', 'AGD', 'Dziecko i mama', 'PREMIUM', 'Moda', 'Motoryzacja', 'Przyjęcia i okazje', 'Delikatesy', 'Kolekcje własne')
and typ_koszyka = 'multi_merchant' then 'non_edito_multi_merchant'
when
item_category in ('Zabawki', 'Dom i ogród', 'Elektronika', 'Zdrowie i uroda', 'Sport', 'AGD', 'Dziecko i mama', 'PREMIUM', 'Moda', 'Motoryzacja', 'Przyjęcia i okazje', 'Delikatesy', 'Kolekcje własne')
and typ_koszyka = 'single_merchant' then 'non_edito_single_merchant'
when
item_category in ('Zabawki', 'Dom i ogród', 'Elektronika', 'Zdrowie i uroda', 'Sport', 'AGD', 'Dziecko i mama', 'PREMIUM', 'Moda', 'Motoryzacja', 'Przyjęcia i okazje', 'Delikatesy', 'Kolekcje własne')
and typ_koszyka = 'empik' then 'non_edito_empik'
when
item_category in ('Zabawki', 'Dom i ogród', 'Elektronika', 'Zdrowie i uroda', 'Sport', 'AGD', 'Dziecko i mama', 'PREMIUM', 'Moda', 'Motoryzacja', 'Przyjęcia i okazje', 'Delikatesy', 'Kolekcje własne')
and typ_koszyka = 'premium' then 'non_edito_premium'

end typ_koszyka_category,

id v3,

from (

SELECT
  parse_DATE("%Y%m%d",event_date) true_date,
  FORMAT_DATE('%G%W',parse_DATE("%Y%m%d",event_date)) week_of_year,
  FORMAT_DATE('%Y%m',parse_DATE("%Y%m%d",event_date)) month_of_year,
  case when device.category like 'desktop' and platform like 'WEB' then 'DESKTOP_WEB'
  when device.category like 'mobile' and platform like 'WEB' then 'DESKTOP_MOB'
  when device.category like 'tablet' and platform like 'WEB' then 'DESKTOP_MOB'
  else 'DESKTOP_WEB' end device,
  CONCAT(user_pseudo_id, CAST((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS STRING)) id,
  user_pseudo_id,
  event_timestamp,
  items.item_category,
  (SELECT value.string_value FROM unnest(event_params) WHERE key = 'merchant_list2') typ_koszyka,
FROM
  `empik-mobile-app.analytics_183670685.events_*`, unnest(items) as items
WHERE
  event_name = 'purchase'
  AND platform = 'WEB'
  AND (SELECT value.string_value FROM unnest(event_params) WHERE key = 'merchant_list2') is not null
  -- AND _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
  and REGEXP_EXTRACT(_table_suffix, '[0-9]+') BETWEEN '20221215' AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
)) group by 1,2,3,4,5)


SELECT
  v1.true_date,
  v1.week_of_year,
  v1.month_of_year,
  v1.device,
  v1.typ_koszyka_category,
  sum(v1.v1) cart,
  sum(v2.v2) delivery_payment,
  sum(v3.v3) purchase,
FROM v1 LEFT JOIN v2 ON v1.true_date = v2.true_date AND v1.device=v2.device AND v1.typ_koszyka_category=v2.typ_koszyka_category
LEFT JOIN v3 ON v2.true_date = v3.true_date AND v2.device=v3.device AND v2.typ_koszyka_category=v3.typ_koszyka_category
GROUP BY 1,2,3,4,5