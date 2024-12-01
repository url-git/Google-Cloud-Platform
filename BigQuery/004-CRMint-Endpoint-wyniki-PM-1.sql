SELECT
    t1.event_date AS date,
    PARSE_DATE('%Y%m%d', CAST(t1.event_date AS STRING)) AS true_date,
    CASE
        WHEN t1.country = "Poland" THEN 'PL'
        WHEN t1.country = "Romania" THEN 'RO'
        WHEN t1.country = "Bulgaria" THEN 'BG'
        WHEN t1.country = "Hungary" THEN 'HU'
        WHEN t1.country = "Ukraine" THEN 'UA'
        WHEN t1.country = "Russia" THEN 'RU'
        WHEN t1.country = "Slovakia" THEN 'SK'
        WHEN t1.country = "Greece" THEN 'GR'
        WHEN t1.country = "Lithuania" THEN 'LT'
        WHEN t1.country = "Italy" THEN 'IT'
        WHEN t1.country = "France" THEN 'FR'
        WHEN t1.country = "Spain" THEN 'ES'
        WHEN t1.country = "Germany" THEN 'DE'
        WHEN t1.country = "Sweden" THEN 'SE'
        WHEN t1.country = "Czechia" THEN 'CZ'
        WHEN t1.country = "Switzerland" THEN 'CH'
        WHEN t1.country = "Croatia" THEN 'HR'
        ELSE 'Other'
    END AS country,
    SUM(liczba_sesji) AS visits,
    SUM(przychod) AS RevenuePLN,
    SUM(liczba_transakcji) AS Transactions
FROM (
    SELECT
        COUNT(event_name) AS liczba_sesji,
        event_date,
        country
    FROM (
        SELECT
            event_date,
            event_name,
            country
        FROM (
            SELECT
                event_date,
                event_name,
                event_timestamp,
                user_pseudo_id,
                event_value_in_usd,
                geo.country
            FROM
                `produkcja-mobile.analytics_152051616.events_*`,
                UNNEST(event_params) AS event_params
            WHERE
                _TABLE_SUFFIX BETWEEN '20200101' AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                AND event_name LIKE 'session_start'
            GROUP BY
                event_date, event_name, event_timestamp, user_pseudo_id, event_value_in_usd, geo.country
        )
    )
    GROUP BY
        event_date, country
) AS t1
LEFT JOIN (
    SELECT
        event_date,
        country,
        COUNT(*) AS liczba_transakcji,
        SUM(event_value_in_usd * t2.kurs) AS przychod
    FROM (
        SELECT
            event_date,
            event_name,
            user_pseudo_id,
            event_value_in_usd,
            geo.country,
            event_timestamp
        FROM
            `produkcja-mobile.analytics_152051616.events_*`
        WHERE
            _TABLE_SUFFIX BETWEEN '20200101' AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
            AND event_name LIKE '%purchase%'
    ) AS t1
    LEFT JOIN (
        SELECT *
        FROM
            `elevated-honor-235814.analizy.kursy_wszystkie`
        WHERE
            kraj = 'US'
    ) AS t2
    ON
        PARSE_DATE('%Y%m%d', CAST(t1.event_date AS STRING)) = t2.date
    GROUP BY
        event_date, country
    ORDER BY
        event_date
) AS t2
ON
    t1.event_date = t2.event_date AND t1.country = t2.country
GROUP BY
    t1.event_date, true_date, country
LIMIT 5;