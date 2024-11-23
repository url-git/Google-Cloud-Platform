WITH www AS (
    SELECT
        true_date,
        CASE
            WHEN country LIKE ('%mod%') THEN 'modivo'
            WHEN country LIKE ('%gino%') THEN 'gino'
            ELSE 'eobuwie'
        END AS project,
        IF(country = 'RU', 'UA', country) AS country,
        deviceCategory,
        SUM(visits) AS sessions,
        SUM(RevenuePLN) AS RevenuePLN,
        SUM(transactions) AS transactions
    FROM
        `elevated-honor-235814.zgrupowane_ga.BasicMetrics_devices`
    WHERE
        true_date >= '2020-01-01'
    GROUP BY
        1, 2, 3, 4
),

app_eob AS (
    SELECT
        true_date,
        'eobuwie' AS project,
        IF(country LIKE '%other%', 'PL', country) AS country,
        'app' AS devicecategory,
        SUM(visits) AS sessions,
        SUM(Transactions) AS transactions,
        SUM(RevenuePLN) AS RevenuePLN
    FROM
        `elevated-honor-235814.zgrupowane_ga.app_basic_view`
    GROUP BY
        1, 2, 3, 4
),

app_modivo AS (
    SELECT
        true_date,
        IF(country = 'other modivo', 'modivo.pl', country) AS country,
        'modivo' AS project,
        'app' AS devicecategory,
        SUM(visits) AS sessions,
        SUM(Transactions) AS transactions,
        SUM(RevenuePLN) AS RevenuePLN
    FROM
        `elevated-honor-235814.zgrupowane_ga.app_basic_view_modivo`
    GROUP BY
        1, 2, 3, 4
),

merged AS (
    SELECT
        base.true_date,
        base.country,
        project,
        devicecategory,
        CASE
            WHEN base.true_date < '2020-09-04'
                 AND project = 'eobuwie'
                 AND LOWER(devicecategory) = 'mobile'
            THEN sessions - COALESCE(app_sessions, 0)
            ELSE sessions
        END AS sessions,
        CASE
            WHEN base.true_date < '2020-09-04'
                 AND project = 'eobuwie'
                 AND LOWER(devicecategory) = 'mobile'
            THEN transactions - COALESCE(app_transactions, 0)
            ELSE transactions
        END AS transactions,
        CASE
            WHEN base.true_date < '2020-09-04'
                 AND project = 'eobuwie'
                 AND LOWER(devicecategory) = 'mobile'
            THEN RevenuePLN - COALESCE(app_revenue, 0)
            ELSE RevenuePLN
        END AS RevenuePLN
    FROM (
        SELECT
            www.true_date,
            www.country,
            www.project,
            www.sessions,
            www.devicecategory,
            app_eob.sessions AS app_sessions,
            www.transactions,
            app_eob.Transactions AS app_transactions,
            www.RevenuePLN,
            app_eob.RevenuePLN AS app_revenue
        FROM
            www
        LEFT JOIN
            app_eob
        ON
            www.true_date = app_eob.true_date
            AND www.country = app_eob.country
            AND www.project = 'eobuwie'
            AND LOWER(www.devicecategory) = 'mobile'
    ) base
)

SELECT
    true_date,
    country,
    project,
    devicecategory,
    SUM(sessions) AS sessions,
    SUM(transactions) AS transactions,
    SUM(RevenuePLN) AS RevenuePLN
FROM (
    SELECT *
    FROM merged
    WHERE true_date >= '2020-01-01'

    UNION ALL

    SELECT
        true_date,
        country,
        'modivo' AS project,
        devicecategory,
        SUM(sessions) AS sessions,
        SUM(transactions) AS transactions,
        SUM(RevenuePLN) AS RevenuePLN
    FROM
        app_modivo
    GROUP BY
        1, 2, 3, 4

    UNION ALL

    SELECT
        true_date,
        country,
        'eobuwie' AS project,
        devicecategory,
        SUM(sessions) AS sessions,
        SUM(transactions) AS transactions,
        SUM(RevenuePLN) AS RevenuePLN
    FROM
        app_eob
    GROUP BY
        1, 2, 3, 4
) alls
WHERE
    true_date >= '2020-01-01'
GROUP BY
    1, 2, 3, 4
LIMIT 5;