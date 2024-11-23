WITH app_push_robocza AS (
	SELECT
		event_date,
		TIMESTAMP_MICROS(event_timestamp) AS event_timestamp,
		TIMESTAMP_ADD(TIMESTAMP_MICROS(event_timestamp), INTERVAL 48 HOUR) AS end_window,
		device.operating_system,
		event_name,
		event_params.value.int_value,
		user_pseudo_id
	FROM
		`produkcja-mobile.analytics_152051616.events_*`,
		UNNEST(event_params) AS event_params
	WHERE
		event_name LIKE '%notification_open%'
		AND event_params.key LIKE 'ga_session_number'
		AND _TABLE_SUFFIX BETWEEN '20210301' AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
),

notyfikacje AS (
    SELECT
        event_date,
        FORMAT_DATE('%H', DATETIME(TIMESTAMP_MICROS(event_timestamp), 'Europe/Amsterdam')) AS hour,
        CASE
            WHEN geo.country = "Poland" THEN 'PL'
            WHEN geo.country = "Romania" THEN 'RO'
            WHEN geo.country = "Bulgaria" THEN 'BG'
            WHEN geo.country = "Hungary" THEN 'HU'
            WHEN geo.country = "Ukraine" THEN 'UA'
            WHEN geo.country = "Russia" THEN 'UA'
            WHEN geo.country = "Slovakia" THEN 'SK'
            WHEN geo.country = "Greece" THEN 'GR'
            WHEN geo.country = "Lithuania" THEN 'LT'
            WHEN geo.country = "Italy" THEN 'IT'
            WHEN geo.country = "France" THEN 'FR'
            WHEN geo.country = "Spain" THEN 'ES'
            WHEN geo.country = "Germany" THEN 'DE'
            WHEN geo.country = "Sweden" THEN 'SE'
            WHEN geo.country = "Czechia" THEN 'CZ'
            WHEN geo.country = "Switzerland" THEN 'CH'
            WHEN geo.country = "Croatia" THEN 'HR'
            WHEN geo.country = "Slovenia" THEN 'SI'
            ELSE 'PL'
        END AS kraj,
        device.operating_system,
        event_name,
        user_pseudo_id
    FROM
        `produkcja-mobile.analytics_152051616.events_*`
    WHERE
        event_name LIKE '%notification_open%'
        OR event_name LIKE '%notification_receive%'
        OR event_name LIKE '%app_remove%'
        AND _TABLE_SUFFIX BETWEEN '20210301' AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    GROUP BY
        1, 2, 3, 4, 5, 6
),

app_push_dziennie AS (
    SELECT
        event_date,
        FORMAT_DATE('%H', DATETIME(TIMESTAMP_MICROS(event_timestamp), 'Europe/Amsterdam')) AS hour,
        event_name,
        user_pseudo_id,
        CASE
            WHEN geo.country = "Poland" THEN 'PL'
            WHEN geo.country = "Romania" THEN 'RO'
            WHEN geo.country = "Bulgaria" THEN 'BG'
            WHEN geo.country = "Hungary" THEN 'HU'
            WHEN geo.country = "Ukraine" THEN 'UA'
            WHEN geo.country = "Russia" THEN 'UA'
            WHEN geo.country = "Slovakia" THEN 'SK'
            WHEN geo.country = "Greece" THEN 'GR'
            WHEN geo.country = "Lithuania" THEN 'LT'
            WHEN geo.country = "Italy" THEN 'IT'
            WHEN geo.country = "France" THEN 'FR'
            WHEN geo.country = "Spain" THEN 'ES'
            WHEN geo.country = "Germany" THEN 'DE'
            WHEN geo.country = "Sweden" THEN 'SE'
            WHEN geo.country = "Czechia" THEN 'CZ'
            WHEN geo.country = "Switzerland" THEN 'CH'
            WHEN geo.country = "Croatia" THEN 'HR'
            WHEN geo.country = "Slovenia" THEN 'SI'
            ELSE 'PL'
        END AS kraj,
        device.operating_system,
        key1.value.int_value, 
        event_value_in_usd
    FROM
        `produkcja-mobile.analytics_152051616.events_*`,
        UNNEST(event_params) AS key1,
        UNNEST(event_params) AS arr1
    WHERE
        event_name LIKE '%purchase%'
        AND key1.key LIKE 'ga_session_number'
        AND _TABLE_SUFFIX BETWEEN '20210301' AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
        AND CONCAT(key1.value.int_value, 'spacja', user_pseudo_id) IN (
            SELECT CONCAT(int_value, 'spacja', user_pseudo_id)
            FROM app_push_robocza
        )
    GROUP BY
        1, 2, 3, 4, 5, 6, 7, 8
),

okno_konwersji AS (
    SELECT
        event_date,
        TIMESTAMP_MICROS(s.event_timestamp) AS start_timestamp,
        FORMAT_DATE('%H', DATETIME(TIMESTAMP_MICROS(s.event_timestamp), 'Europe/Amsterdam')) AS hour,
        event_name,
        s.user_pseudo_id,
        CASE
            WHEN geo.country = "Poland" THEN 'PL'
            WHEN geo.country = "Romania" THEN 'RO'
            WHEN geo.country = "Bulgaria" THEN 'BG'
            WHEN geo.country = "Hungary" THEN 'HU'
            WHEN geo.country = "Ukraine" THEN 'UA'
            WHEN geo.country = "Russia" THEN 'UA'
            WHEN geo.country = "Slovakia" THEN 'SK'
            WHEN geo.country = "Greece" THEN 'GR'
            WHEN geo.country = "Lithuania" THEN 'LT'
            WHEN geo.country = "Italy" THEN 'IT'
            WHEN geo.country = "France" THEN 'FR'
            WHEN geo.country = "Spain" THEN 'ES'
            WHEN geo.country = "Germany" THEN 'DE'
            WHEN geo.country = "Sweden" THEN 'SE'
            WHEN geo.country = "Czechia" THEN 'CZ'
            WHEN geo.country = "Switzerland" THEN 'CH'
            WHEN geo.country = "Croatia" THEN 'HR'
            WHEN geo.country = "Slovenia" THEN 'SI'
            ELSE 'PL'
        END AS kraj,
        device.operating_system,
        event_value_in_usd
    FROM
        `produkcja-mobile.analytics_152051616.events_*` s
    INNER JOIN (
        SELECT
            user_pseudo_id,
            event_timestamp,
            end_window
        FROM
            app_push_robocza
        GROUP BY 1, 2, 3
    ) AS cr_window
    ON
        s.user_pseudo_id = cr_window.user_pseudo_id
        AND TIMESTAMP_MICROS(s.event_timestamp) >= cr_window.event_timestamp
        AND TIMESTAMP_MICROS(s.event_timestamp) < cr_window.end_window
    WHERE
        event_name LIKE '%purchase%'
        AND _TABLE_SUFFIX BETWEEN '20210301' AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    GROUP BY
        1, 2, 3, 4, 5, 6, 7, 8
),

app_push AS (
    SELECT
        event_date,
        hour,
        operating_system,
        app_push_dziennie.kraj AS kraj,
        COUNT(*) AS transakcje,
        SUM(event_value_in_usd * t2.kurs) AS przychod
    FROM
        app_push_dziennie
    LEFT JOIN (
        SELECT
            CAST(FORMAT_DATE('%Y%m%d', date) AS STRING) AS date,
            kraj,
            kurs
        FROM
            `elevated-honor-235814.analizy.kursy_wszystkie`
        WHERE
            kraj = 'USD'
    ) AS t2
    ON
        app_push_dziennie.event_date = t2.date
    GROUP BY
        1, 2, 3, 4
),

konwersja48 AS (
    SELECT
        event_date,
        hour,
        operating_system,
        okno_konwersji.kraj AS kraj,
        COUNT(*) AS transakcje,
        SUM(event_value_in_usd * t2.kurs) AS przychod
    FROM
        okno_konwersji
    LEFT JOIN (
        SELECT
            CAST(FORMAT_DATE('%Y%m%d', date) AS STRING) AS date,
            kraj,
            kurs
        FROM
            `elevated-honor-235814.analizy.kursy_wszystkie`
        WHERE
            kraj = 'USD'
    ) AS t2
    ON
        okno_konwersji.event_date = t2.date
    GROUP BY
        1, 2, 3, 4
),

nots AS (
    SELECT
        n.event_date,
        n.hour,
        n.kraj,
        n.operating_system
    FROM
        notyfikacje n
    GROUP BY
        1, 2, 3, 4
)

SELECT
    n.event_date,
    n.hour,
    n.kraj AS country,
    n.operating_system,
    nor.notification_receive,
    nop.notification_open,
    ap.transakcje AS transactions,
    ap.przychod AS revenuePLN,
    cw.transakcje AS transactions48,
    cw.przychod AS revenue48,
    apr.app_remove
FROM
    nots n
LEFT JOIN (
    SELECT
        event_date,
        hour,
        kraj,
        operating_system,
        COUNT(*) AS notification_open
    FROM
        notyfikacje
    WHERE
        event_name = 'notification_open'
    GROUP BY
        1, 2, 3, 4
) AS nop
    ON n.event_date = nop.event_date
    AND n.kraj = nop.kraj
    AND n.operating_system = nop.operating_system
    AND n.hour = nop.hour
LEFT JOIN (
    SELECT
        event_date,
        hour,
        kraj,
        operating_system,
        COUNT(*) AS notification_receive
    FROM
        notyfikacje
    WHERE
        event_name = 'notification_receive'
    GROUP BY
        1, 2, 3, 4
) AS nor
    ON n.event_date = nor.event_date
    AND n.kraj = nor.kraj
    AND n.operating_system = nor.operating_system
    AND n.hour = nor.hour
LEFT JOIN (
    SELECT
        event_date,
        hour,
        kraj,
        operating_system,
        COUNT(*) AS app_remove
    FROM
        notyfikacje
    WHERE
        event_name = 'app_remove'
    GROUP BY
        1, 2, 3, 4
) AS apr
    ON n.event_date = apr.event_date
    AND n.kraj = apr.kraj
    AND n.operating_system = apr.operating_system
    AND n.hour = apr.hour
LEFT JOIN app_push ap
    ON n.event_date = ap.event_date
    AND n.kraj = ap.kraj
    AND n.operating_system = ap.operating_system
    AND n.hour = ap.hour
LEFT JOIN konwersja48 cw
    ON n.event_date = cw.event_date
    AND n.kraj = cw.kraj
    AND n.operating_system = cw.operating_system
    AND cw.hour = ap.hour
ORDER BY
    n.event_date,
    n.hour,
    n.kraj
LIMIT
    5;
