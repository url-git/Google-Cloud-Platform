SELECT
    t1.date,
    full_transactions,
    null_af_procenty,
    null_fire_procenty,
    ROUND(IF(t2.null_eob = 0, 0, t2.null_eob / t1.full_transactions * 100), 2) AS null_eob_procenty,
    ROUND(IF(t2.null_mod = 0, 0, t2.null_mod / t1.full_transactions * 100), 2) AS null_mod_procenty,
    ROUND(IF(t2.null_ios = 0, 0, t2.null_ios / t1.full_transactions * 100), 2) AS null_ios_procenty,
    ROUND(IF(t2.null_android = 0, 0, t2.null_android / t1.full_transactions * 100), 2) AS null_android_procenty
FROM (
    SELECT
        *,
        ROUND(IF(t1.null_af = 0, 0, t1.null_af / t1.full_transactions * 100), 2) AS null_af_procenty,
        ROUND(IF(t1.null_fire = 0, 0, t1.null_fire / t1.full_transactions * 100), 2) AS null_fire_procenty
    FROM (
        SELECT
            t1.date,
            t1.full_transactions,
            t1.null_af,
            COUNT(t2.transaction_ID) AS null_fire
        FROM (
            SELECT
                t1.date,
                t1.full_transactions,
                COUNT(t2.transaction_ID) AS null_af
            FROM (
                SELECT
                    date,
                    COUNT(transaction_ID) AS full_transactions
                FROM `dwh-eobuwie.transactions.transactions_app`
                GROUP BY 1
                ORDER BY date DESC
            ) AS t1
            LEFT JOIN `dwh-eobuwie.transactions.transactions_app` AS t2
            ON t1.date = t2.date
            WHERE source_AF IS NULL
            GROUP BY 1, 2
        ) AS t1
        LEFT JOIN `dwh-eobuwie.transactions.transactions_app` AS t2
        ON t1.date = t2.date
        WHERE source_fire IS NULL
        GROUP BY 1, 2, 3
    ) AS t1
    WHERE
        date > PARSE_DATE("%Y%m%d", '20210301')
        AND date < DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)
    GROUP BY 1, 2, 3, 4
    ORDER BY date DESC
) AS t1
LEFT JOIN (
    SELECT
        date,
        SUM(null_eob) AS null_eob,
        SUM(null_mod) AS null_mod,
        SUM(null_ios) AS null_ios,
        SUM(null_android) AS null_android
    FROM (
        SELECT
            *,
            IF(brand = "Eobuwie", 1, 0) AS null_eob,
            IF(brand = "Modivo", 1, 0) AS null_mod,
            IF(platform = "ios", 1, 0) AS null_ios,
            IF(platform = "android", 1, 0) AS null_android
        FROM (
            SELECT
                date,
                brand,
                Transaction_ID,
                source_fire,
                platform
            FROM `dwh-eobuwie.transactions.transactions_app`
            WHERE source_fire IS NULL
        ) AS t1
    ) AS t1
    GROUP BY 1
    ORDER BY date DESC
) AS t2
ON t1.date = t2.date
ORDER BY 1 DESC
LIMIT 3;