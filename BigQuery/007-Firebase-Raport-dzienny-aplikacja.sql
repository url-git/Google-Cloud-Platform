WITH tabela1 AS (
    SELECT
        t1.event_date,
        SUM(liczba_sesji) AS liczba_sesji,
        SUM(przychod) AS przychod,
        SUM(liczba_transakcji) AS liczba_transakcji,
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
            ELSE "other"
        END AS kraj,
        'aplikacja'
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
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    AND event_name LIKE 'session_start'
                GROUP BY
                    1, 2, 3, 4, 5, 6
            )
        )
        GROUP BY
            2, 3
    ) AS t1
    LEFT JOIN (
        SELECT
            event_date,
            COUNT(event_name) AS liczba_transakcji,
            SUM(double_value) AS przychod,
            country
        FROM (
            SELECT
                event_date,
                event_name,
                double_value * kurs AS double_value,
                currency,
                country,
                user_pseudo_id
            FROM (
                SELECT
                    event_date,
                    event_name,
                    user_pseudo_id,
                    event_value_in_usd,
                    geo.country,
                    event_timestamp,
                    event_params.value.double_value,
                    event_params.value.string_value,
                    LEAD(event_params.value.string_value) OVER (
                        PARTITION BY user_pseudo_id, event_timestamp
                        ORDER BY event_params.value.double_value DESC
                    ) AS currency
                FROM
                    `produkcja-mobile.analytics_152051616.events_*`,
                    UNNEST(event_params) AS event_params
                WHERE
                    _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
                    AND event_name LIKE 'ecommerce_purchase'
                    AND (event_params.value.double_value IS NOT NULL OR
                         event_params.value.string_value IN ('SEK', 'HUF', 'RON', 'PLN', 'UAH', 'CZK', 'RUB', 'EUR', 'BGN'))
                GROUP BY
                    1, 2, 3, 4, 5, 6, 7, 8
            )
            LEFT JOIN (
                SELECT * FROM `elevated-honor-235814.analizy.kursy`
            ) AS t2
            ON t1.currency = t2.kraj
            GROUP BY
                1, 2, 3, 4, 5, 6
        )
        WHERE double_value IS NOT NULL
        GROUP BY 1, 4
    ) AS t2
    ON t1.event_date = t2.event_date AND t1.country = t2.country
    GROUP BY
        1, 5, 6
),

tabela2 AS (
    SELECT
        CASE
            WHEN country = "Poland" THEN 'PL'
            WHEN country = "Romania" THEN 'RO'
            WHEN country = "Bulgaria" THEN 'BG'
            WHEN country = "Hungary" THEN 'HU'
            WHEN country = "Ukraine" THEN 'UA'
            WHEN country = "Russia" THEN 'RU'
            WHEN country = "Slovakia" THEN 'SK'
            WHEN country = "Greece" THEN 'GR'
            WHEN country = "Lithuania" THEN 'LT'
            WHEN country = "Italy" THEN 'IT'
            WHEN country = "France" THEN 'FR'
            WHEN country = "Spain" THEN 'ES'
            WHEN country = "Germany" THEN 'DE'
            WHEN country = "Sweden" THEN 'SE'
            WHEN country = "Czechia" THEN 'CZ'
            ELSE "other"
        END AS kraj,
        event_date,
        COUNT(*) AS liczba_instalacji
    FROM (
        SELECT
            geo.country,
            event_name,
            event_date
        FROM
            `produkcja-mobile.analytics_152051616.events_*`
        WHERE
            _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
            AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
            AND event_name LIKE 'first_open'
    )
    GROUP BY
        1, 2
)

SELECT
    tabela1.*,
    tabela2.liczba_instalacji
FROM
    tabela1
LEFT JOIN
    tabela2
ON
    tabela1.event_date = tabela2.event_date AND tabela1.kraj = tabela2.kraj
ORDER BY
    1 DESC
LIMIT 5;