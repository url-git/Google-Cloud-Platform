select * from (
with promotion_views_and_clicks as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'mobile' then 'mobile'
    when device.category like 'tablet' then 'mobile'
    else 'desktop' end device,
    (select value.string_value from unnest(user_properties) where key = 'ab') segment,
    (select value.string_value from unnest(event_params) where key = 'params_key1') interaction_type,
    (select value.string_value from unnest(event_params) where key = 'params_key2') engine,
    split((select value.string_value from unnest(event_params) where key = 'params_key5'),'|')[safe_offset(1)] box_name,
    -- (select value.string_value from unnest(event_params) where key = 'params_key6') promo_brand,
    (select value.string_value from unnest(event_params) where key = 'params_key7') content_group,
    countif((select value.string_value from unnest(event_params) where key = 'params_key1') = 'load') load,
    countif((select value.string_value from unnest(event_params) where key = 'params_key1') = 'view') view,
    countif((select value.string_value from unnest(event_params) where key = 'params_key1') = 'click') click,
    -- (select value.string_value from unnest(event_params) where key = 'page_location') url,
    -- split((select value.string_value from unnest(event_params) where key = 'params_key4'), ',') products,
from
    `empik-mobile-app.analytics_183670685.events_*`
where
    -- and _table_suffix between '20220124' and '20220129'
    regexp_extract(_table_suffix, '[0-9]+') between '20220228' and format_date('%Y%m%d', current_date())
    -- _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    and event_name = 'recommendation_tracking'
    and (select value.string_value from unnest(user_properties) where key = 'ab') is not null
group by 1,2,3,4,5,6,7,8,9
),

select_promotion as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'mobile' then 'mobile'
    when device.category like 'tablet' then 'mobile'
    else 'desktop' end device,
    event_timestamp,
    concat(user_pseudo_id, (select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    (select value.string_value from unnest(user_properties) where key = 'ab') segment,
    split((select value.string_value from unnest(event_params) where key = 'params_key5'),'|')[safe_offset(1)] box_name,
    -- (select value.string_value from unnest(event_params) where key = 'params_key6') promo_brand,
    (select value.string_value from unnest(event_params) where key = 'params_key7') content_group,
    (select value.string_value from unnest(event_params) where key = 'params_key1') interaction_type,
    (select value.string_value from unnest(event_params) where key = 'params_key2') engine

from
    `empik-mobile-app.analytics_183670685.events_*`
where
    -- and _table_suffix between '20220124' and '20220129'
    regexp_extract(_table_suffix, '[0-9]+') between '20220228' and format_date('%Y%m%d', current_date())
    -- _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    and event_name = 'recommendation_tracking'
    and (select value.string_value from unnest(event_params) where key = 'params_key1') = 'view'
    and (select value.string_value from unnest(user_properties) where key = 'ab') is not null
group by 1,2,3,4,5,6,7,8,9,10,11
),

last_promotion_click AS (
    SELECT
        a.*
    FROM select_promotion a
    LEFT OUTER JOIN select_promotion b
    ON (a.id = b.id AND a.event_timestamp < b.event_timestamp)
    WHERE b.id IS NULL),

ecommerce as (
select
    parse_date("%Y%m%d",event_date) true_date,
    format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
    format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
    case when device.category like 'mobile' then 'mobile'
    when device.category like 'tablet' then 'mobile'
    else 'desktop' end device,
    event_timestamp,
    concat(user_pseudo_id, (select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
    ecommerce.purchase_revenue value,
    count(distinct ecommerce.transaction_id) trans

from `empik-mobile-app.analytics_183670685.events_*`
where
    event_name like 'purchase'
    -- and _table_suffix between '20220124' and '20220129'
    and regexp_extract(_table_suffix, '[0-9]+') between '20220228' and format_date('%Y%m%d', current_date())
    -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
group by 1,2,3,4,5,6,7)

select
vc.true_date,
vc.week_of_year,
vc.month_of_year,
vc.device,
vc.segment,
-- vc.content_group,
vc.engine,
vc.box_name,
vc.load,
vc.view,
vc.click,
sum(e.trans) transactions,
sum(e.value) value

from promotion_views_and_clicks vc
left join last_promotion_click c on vc.true_date=c.true_date and vc.device=c.device and vc.box_name=c.box_name and vc.interaction_type=c.interaction_type
and vc.segment=c.segment and vc.engine=c.engine
left join ecommerce e on c.true_date=e.true_date and c.device=e.device and c.id=e.id and c.event_timestamp>e.event_timestamp
group by 1,2,3,4,5,6,7,8,9,10
)

where
    box_name is not null
order by
    transactions desc
limit 15