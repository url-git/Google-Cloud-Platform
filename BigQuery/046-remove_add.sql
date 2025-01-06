with remove_from_cart as (
select true_date, week_of_year, month_of_year, device, typ_koszyka, sum(cnt) licznik_remove_from_cart from (

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
  (SELECT value.string_value FROM unnest(event_params) WHERE key = 'merchant_list2') typ_koszyka,
  count(*) cnt
FROM
  `empik-mobile-app.analytics_183670685.events_*`
WHERE
  event_name = 'remove_from_cart'
  AND platform = 'WEB'
  AND (SELECT value.string_value FROM unnest(event_params) WHERE key = 'merchant_list2') is not null
  AND REGEXP_CONTAINS((SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'content_group'), r'basket_list') = TRUE
  -- AND _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
  and REGEXP_EXTRACT(_table_suffix, '[0-9]+') BETWEEN '20221121' AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
group by 1,2,3,4,5,6,7,8
) group by 1,2,3,4,5
),

add_to_cart as (
select true_date, week_of_year, month_of_year, device, typ_koszyka, sum(cnt) licznik_add_to_cart from (

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
  (SELECT value.string_value FROM unnest(event_params) WHERE key = 'merchant_list2') typ_koszyka,
  count(*) cnt
FROM
  `empik-mobile-app.analytics_183670685.events_*`
WHERE
  event_name = 'add_to_cart'
  AND platform = 'WEB'
  AND (SELECT value.string_value FROM unnest(event_params) WHERE key = 'merchant_list2') is not null
  AND REGEXP_CONTAINS((SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'content_group'), r'basket_list') = TRUE
  -- AND _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY))
  and REGEXP_EXTRACT(_table_suffix, '[0-9]+') BETWEEN '20221121' AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
group by 1,2,3,4,5,6,7,8
) group by 1,2,3,4,5
)

select
  v1.true_date,
  v1.week_of_year,
  v1.month_of_year,
  v1.device,
  v1.typ_koszyka,
  sum(v1.licznik_remove_from_cart) licznik_remove_from_cart,
  sum(v2.licznik_add_to_cart) licznik_add_to_cart


from remove_from_cart v1 left join add_to_cart v2 on v1.true_date=v2.true_date and v1.device=v2.device AND v1.typ_koszyka=v2.typ_koszyka
group by 1,2,3,4,5