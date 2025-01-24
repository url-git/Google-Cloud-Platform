with lp as (select *
    from (
    select
        event_date, week_of_year, month_of_year, user_pseudo_id, session_id, concat(user_pseudo_id, session_id) id,
        case when REGEXP_CONTAINS(page_location, r'(https://www.empik.com/twoje-konto/zamowienie/platnosc.*|https://www.empik.com/twoje-zamowienie/platnosc.*)') = TRUE then 'old'
        when REGEXP_CONTAINS(page_location, r'(https://www.empik.com/zamowienia/platnosc/.*)') = TRUE then 'new' end form

    from (
    select
        parse_date("%Y%m%d",event_date) event_date,
        format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
        format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
        user_pseudo_id,
        (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
        (select value.string_value from unnest(event_params) where key = 'page_location') page_location

    from
        `empik-mobile-app.analytics_183670685.events_*`
    where
        _table_suffix between '20220201' and '20220214'
        -- _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    ))
    where
        form is not null
),

re_payment1 as (
    select
        parse_date("%Y%m%d",event_date) event_date,
        format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
        format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
        user_pseudo_id,
        (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
        concat(user_pseudo_id, (select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
        (select value.string_value from unnest(event_params) where key = 'form') form

    from
        `empik-mobile-app.analytics_183670685.events_*`
    where
        event_name = 're_payment1'
        and _table_suffix between '20220201' and '20220214'
        -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
),

re_payment2 as (
    select
        parse_date("%Y%m%d",event_date) event_date,
        format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
        format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
        user_pseudo_id,
        (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
        concat(user_pseudo_id, (select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
        (select value.string_value from unnest(event_params) where key = 'form') form

    from
        `empik-mobile-app.analytics_183670685.events_*`
    where
        event_name = 're_payment2'
        and _table_suffix between '20220201' and '20220214'
        -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    ),

    re_payment3 as (
    select
        parse_date("%Y%m%d",event_date) event_date,
        format_date('%G%W',parse_date("%Y%m%d",event_date)) week_of_year,
        format_date('%Y%m',parse_date("%Y%m%d",event_date)) as month_of_year,
        user_pseudo_id,
        (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
        concat(user_pseudo_id, (select value.int_value from unnest(event_params) where key = 'ga_session_id')) id,
        (select value.string_value from unnest(event_params) where key = 'form') form

    from
        `empik-mobile-app.analytics_183670685.events_*`
    where
        event_name = 're_payment3'
        and _table_suffix between '20220201' and '20220214'
        -- and _table_suffix = FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY))
    )

    select
        lp.event_date true_date, lp.week_of_year, lp.month_of_year, lp.form lp_form,
        count (distinct lp.id) lp,
        count (distinct r1.id) step1,
        count (distinct r2.id) step2,
        count (distinct r3.id) step3,
    from lp left join re_payment1 r1 on lp.event_date=r1.event_date and lp.id=r1.id and lp.form=r1.form
    left join re_payment2 r2 on r1.event_date=r2.event_date and r1.id=r2.id
    left join re_payment3 r3 on r2.event_date=r3.event_date and r2.id=r3.id

group by 1,2,3,4
order by 1 desc