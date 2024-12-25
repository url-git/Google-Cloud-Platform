
WITH views as (SELECT date,
  device.operatingSystem as system,
    case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Książki', 'Książki ', 'Książki  ', 'Książki   ') then 'Książki' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Zdrowie i uroda', 'Zdrowie i uroda ', 'Zdrowie i uroda  ', 'Zdrowie i uroda   ') then 'Zdrowie i uroda' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Zabawki', 'Zabawki ', 'Zabawki  ', 'Zabawki   ') then 'Zabawki' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Szkolne i papiernicze', 'Szkolne i papiernicze ', 'Szkolne i papiernicze  ', 'Szkolne i papiernicze   ') then 'Szkolne i papiernicze' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Sport i rekreacja', 'Sport i rekreacja ', 'Sport i rekreacja  ', 'Sport i rekreacja   ') then 'Sport i rekreacja' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Przyjęcia i okazje', 'Przyjęcia i okazje ', 'Przyjęcia i okazje  ', 'Przyjęcia i okazje   ') then 'Przyjęcia i okazje' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Prasa', 'Prasa ', 'Prasa  ', 'Prasa   ') then 'Prasa' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Podręczniki szkolne', 'Podręczniki szkolne ', 'Podręczniki szkolne  ', 'Podręczniki szkolne   ') then 'Podręczniki szkolne' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Obcojęzyczne', 'Obcojęzyczne ', 'Obcojęzyczne  ', 'Obcojęzyczne   ') then 'Obcojęzyczne' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Muzyka', 'Muzyka ', 'Muzyka  ', 'Muzyka   ') then 'Muzyka' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Motoryzacja', 'Motoryzacja ', 'Motoryzacja  ', 'Motoryzacja   ') then 'Motoryzacja' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Moda', 'Moda ', 'Moda  ', 'Moda   ') then 'Moda' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Kolekcje własne', 'Kolekcje własne ', 'Kolekcje własne  ', 'Kolekcje własne   ') then 'Kolekcje własne' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Gry i programy', 'Gry i programy ', 'Gry i programy  ', 'Gry i programy   ') then 'Gry i programy' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Filmy', 'Filmy ', 'Filmy  ', 'Filmy   ') then 'Filmy' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Elektronika', 'Elektronika ', 'Elektronika  ', 'Elektronika   ') then 'Elektronika' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Ebooki i mp3', 'Ebooki i mp3 ', 'Ebooki i mp3  ', 'Ebooki i mp3   ') then 'Ebooki i mp3' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Dziecko i mama', 'Dziecko i mama ', 'Dziecko i mama  ', 'Dziecko i mama   ') then 'Dziecko i mama' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Dom i ogród', 'Dom i ogród ', 'Dom i ogród  ', 'Dom i ogród   ') then 'Dom i ogród' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Artykuły dla zwierząt', 'Artykuły dla zwierząt ', 'Artykuły dla zwierząt  ', 'Artykuły dla zwierząt   ') then 'Artykuły dla zwierząt' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('AGD', 'AGD ', 'AGD  ', 'AGD   ') then 'AGD' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Instrumenty muzyczne', 'Instrumenty muzyczne ', 'Instrumenty muzyczne  ', 'Instrumenty muzyczne   ') then 'Instrumenty muzyczne' end)
  end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end   as category,
  RTRIM(split(v2ProductCategory, "/")[safe_offset(1)], " ") as subcategory,
  count(distinct concat(fullVisitorId,visitId)) as views
FROM
  `empik-ga360.304756.ga_sessions_20211105`,
  UNNEST(hits) AS hits,
  UNNEST(product) AS product
WHERE
      totals.visits = 1
  AND hits.eCommerceAction.action_type = '2'
  AND device.deviceCategory = 'mobile'
GROUP BY 1,2,3,4
ORDER BY 1,2,3,4
),

clicks as (
SELECT
  date,
  device.operatingSystem as system,
  case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Książki', 'Książki ', 'Książki  ', 'Książki   ') then 'Książki' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Zdrowie i uroda', 'Zdrowie i uroda ', 'Zdrowie i uroda  ', 'Zdrowie i uroda   ') then 'Zdrowie i uroda' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Zabawki', 'Zabawki ', 'Zabawki  ', 'Zabawki   ') then 'Zabawki' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Szkolne i papiernicze', 'Szkolne i papiernicze ', 'Szkolne i papiernicze  ', 'Szkolne i papiernicze   ') then 'Szkolne i papiernicze' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Sport i rekreacja', 'Sport i rekreacja ', 'Sport i rekreacja  ', 'Sport i rekreacja   ') then 'Sport i rekreacja' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Przyjęcia i okazje', 'Przyjęcia i okazje ', 'Przyjęcia i okazje  ', 'Przyjęcia i okazje   ') then 'Przyjęcia i okazje' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Prasa', 'Prasa ', 'Prasa  ', 'Prasa   ') then 'Prasa' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Podręczniki szkolne', 'Podręczniki szkolne ', 'Podręczniki szkolne  ', 'Podręczniki szkolne   ') then 'Podręczniki szkolne' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Obcojęzyczne', 'Obcojęzyczne ', 'Obcojęzyczne  ', 'Obcojęzyczne   ') then 'Obcojęzyczne' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Muzyka', 'Muzyka ', 'Muzyka  ', 'Muzyka   ') then 'Muzyka' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Motoryzacja', 'Motoryzacja ', 'Motoryzacja  ', 'Motoryzacja   ') then 'Motoryzacja' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Moda', 'Moda ', 'Moda  ', 'Moda   ') then 'Moda' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Kolekcje własne', 'Kolekcje własne ', 'Kolekcje własne  ', 'Kolekcje własne   ') then 'Kolekcje własne' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Gry i programy', 'Gry i programy ', 'Gry i programy  ', 'Gry i programy   ') then 'Gry i programy' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Filmy', 'Filmy ', 'Filmy  ', 'Filmy   ') then 'Filmy' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Elektronika', 'Elektronika ', 'Elektronika  ', 'Elektronika   ') then 'Elektronika' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Ebooki i mp3', 'Ebooki i mp3 ', 'Ebooki i mp3  ', 'Ebooki i mp3   ') then 'Ebooki i mp3' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Dziecko i mama', 'Dziecko i mama ', 'Dziecko i mama  ', 'Dziecko i mama   ') then 'Dziecko i mama' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Dom i ogród', 'Dom i ogród ', 'Dom i ogród  ', 'Dom i ogród   ') then 'Dom i ogród' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Artykuły dla zwierząt', 'Artykuły dla zwierząt ', 'Artykuły dla zwierząt  ', 'Artykuły dla zwierząt   ') then 'Artykuły dla zwierząt' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('AGD', 'AGD ', 'AGD  ', 'AGD   ') then 'AGD' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Instrumenty muzyczne', 'Instrumenty muzyczne ', 'Instrumenty muzyczne  ', 'Instrumenty muzyczne   ') then 'Instrumenty muzyczne' end)
  end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end   as category,
  RTRIM(split(v2ProductCategory, "/")[safe_offset(1)], " ") as subcategory,
  count(distinct concat(fullVisitorId,visitId)) as clicks
FROM
  `empik-ga360.304756.ga_sessions_20211105`,
  UNNEST(hits) AS hits,
  UNNEST(product) AS product
WHERE
      totals.visits = 1
  AND device.deviceCategory = 'mobile'
  and eventInfo.eventCategory = 'Ecommerce'
  and eventInfo.eventAction = 'Add to Cart'
  and eventInfo.eventLabel = 'karta produktu'
GROUP BY 1,2,3,4
ORDER BY 1,2,3,4
),


purchases as (
SELECT
  date,
  device.operatingSystem as system,
  case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Książki', 'Książki ', 'Książki  ', 'Książki   ') then 'Książki' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Zdrowie i uroda', 'Zdrowie i uroda ', 'Zdrowie i uroda  ', 'Zdrowie i uroda   ') then 'Zdrowie i uroda' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Zabawki', 'Zabawki ', 'Zabawki  ', 'Zabawki   ') then 'Zabawki' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Szkolne i papiernicze', 'Szkolne i papiernicze ', 'Szkolne i papiernicze  ', 'Szkolne i papiernicze   ') then 'Szkolne i papiernicze' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Sport i rekreacja', 'Sport i rekreacja ', 'Sport i rekreacja  ', 'Sport i rekreacja   ') then 'Sport i rekreacja' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Przyjęcia i okazje', 'Przyjęcia i okazje ', 'Przyjęcia i okazje  ', 'Przyjęcia i okazje   ') then 'Przyjęcia i okazje' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Prasa', 'Prasa ', 'Prasa  ', 'Prasa   ') then 'Prasa' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Podręczniki szkolne', 'Podręczniki szkolne ', 'Podręczniki szkolne  ', 'Podręczniki szkolne   ') then 'Podręczniki szkolne' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Obcojęzyczne', 'Obcojęzyczne ', 'Obcojęzyczne  ', 'Obcojęzyczne   ') then 'Obcojęzyczne' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Muzyka', 'Muzyka ', 'Muzyka  ', 'Muzyka   ') then 'Muzyka' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Motoryzacja', 'Motoryzacja ', 'Motoryzacja  ', 'Motoryzacja   ') then 'Motoryzacja' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Moda', 'Moda ', 'Moda  ', 'Moda   ') then 'Moda' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Kolekcje własne', 'Kolekcje własne ', 'Kolekcje własne  ', 'Kolekcje własne   ') then 'Kolekcje własne' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Gry i programy', 'Gry i programy ', 'Gry i programy  ', 'Gry i programy   ') then 'Gry i programy' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Filmy', 'Filmy ', 'Filmy  ', 'Filmy   ') then 'Filmy' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Elektronika', 'Elektronika ', 'Elektronika  ', 'Elektronika   ') then 'Elektronika' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Ebooki i mp3', 'Ebooki i mp3 ', 'Ebooki i mp3  ', 'Ebooki i mp3   ') then 'Ebooki i mp3' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Dziecko i mama', 'Dziecko i mama ', 'Dziecko i mama  ', 'Dziecko i mama   ') then 'Dziecko i mama' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Dom i ogród', 'Dom i ogród ', 'Dom i ogród  ', 'Dom i ogród   ') then 'Dom i ogród' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Artykuły dla zwierząt', 'Artykuły dla zwierząt ', 'Artykuły dla zwierząt  ', 'Artykuły dla zwierząt   ') then 'Artykuły dla zwierząt' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('AGD', 'AGD ', 'AGD  ', 'AGD   ') then 'AGD' else
    (case when split(v2ProductCategory, "/")[safe_offset(0)] in ('Instrumenty muzyczne', 'Instrumenty muzyczne ', 'Instrumenty muzyczne  ', 'Instrumenty muzyczne   ') then 'Instrumenty muzyczne' end)
  end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) end   as category,
  RTRIM(split(v2ProductCategory, "/")[safe_offset(1)], " ") as subcategory,
  count(distinct concat(fullVisitorId,visitId)) as orders
FROM
  `empik-ga360.304756.ga_sessions_20211105`,
  UNNEST(hits) AS hits,
  UNNEST(product) AS product
WHERE
      totals.visits = 1
  AND hits.eCommerceAction.action_type = '6'
  AND device.deviceCategory = 'mobile'
GROUP BY 1,2,3,4
ORDER BY 1,2,3,4
)

SELECT
  v.date,
  v.system,
  v.category,
  v.subcategory,
  views,
  clicks,
  orders
FROM views v left join clicks c on (v.date = c.date and v.system = c.system and v.category = c.category and v.subcategory = c.subcategory)
left join purchases p on (c.date = p.date and c.system = p.system and c.category = p.category and c.subcategory = p.subcategory)
GROUP BY 1,2,3,4,5,6,7
ORDER BY 7 desc
limit 1000