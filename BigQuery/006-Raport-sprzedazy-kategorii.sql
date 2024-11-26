%%bigquery --project produkcja-mobile

WITH tabela1 AS (
    SELECT
        date,
        EXTRACT(YEAR FROM PARSE_DATE('%Y%m%d', date)) AS year,
        EXTRACT(ISOWEEK FROM PARSE_DATE('%Y%m%d', date)) AS week,
        COALESCE(
            SUBSTR(REGEXP_EXTRACT(product.productSKU, "(.*-)"), 1, LENGTH(REGEXP_EXTRACT(product.productSKU, "(.*-)")) - 1),
            product.productSKU
        ) AS SKU,
        hits.eCommerceAction.action_type,
        SUBSTR(REGEXP_EXTRACT(product.v2ProductCategory, "(.*/)"), 1, LENGTH(REGEXP_EXTRACT(product.v2ProductCategory, '^([^/]+)'))) AS kategoria1,
        SUBSTR(
            product.v2ProductCategory,
            LENGTH(REGEXP_EXTRACT(product.v2ProductCategory, '^([^/]+)')) + 2,
            LENGTH(REGEXP_EXTRACT(
                SUBSTR(product.v2ProductCategory, LENGTH(REGEXP_EXTRACT(product.v2ProductCategory, '^([^/]+)')) + 2, 100),
                '^([^/]+)'
            ))
        ) AS kategoria2,
        SUBSTR(
            SUBSTR(REGEXP_EXTRACT(product.v2ProductCategory, '/[^/].*'), 2, 100),
            LENGTH(REGEXP_EXTRACT(SUBSTR(REGEXP_EXTRACT(product.v2ProductCategory, '/[^/].*'), 2, 100), '^([^/]+)')) + 2,
            LENGTH(REGEXP_EXTRACT(
                SUBSTR(SUBSTR(REGEXP_EXTRACT(product.v2ProductCategory, '/[^/].*'), 2, 100),
                LENGTH(REGEXP_EXTRACT(SUBSTR(REGEXP_EXTRACT(product.v2ProductCategory, '/[^/].*'), 2, 100), '^([^/]+)')) + 2, 100),
                '^([^/]+)'
            ))
        ) AS kategoria3,
        COUNT(*) AS ilosc,
        COUNT(DISTINCT hits.transaction.transactionId) AS unique_transactions,
        COUNT(hits.transaction.transactionId) AS transactions
    FROM
        `eobuwie-181013.3869171.ga_sessions_*`,
        UNNEST(hits) AS hits,
        UNNEST(hits.product) AS product
    WHERE
        _TABLE_SUFFIX BETWEEN '20200101' AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
        AND hits.eCommerceAction.action_type IN ('2', '3', '6')
    GROUP BY
        1, 2, 3, 4, 5, 6, 7, 8
),

tabela2 AS (
    SELECT
        date,
        year,
        week,
        SKU,
        kategoria1,
        kategoria2,
        kategoria3,
        MAX(CASE WHEN action_type = '2' THEN ilosc END) AS ilosc_odslon,
        MAX(CASE WHEN action_type = '6' THEN unique_transactions END) AS unique_transactions,
        MAX(CASE WHEN action_type = '6' THEN transactions END) AS quantity,
        MAX(CASE WHEN action_type = '3' THEN ilosc END) AS basket
    FROM
        tabela1
    GROUP BY
        1, 2, 3, 4, 5, 6, 7
)

SELECT
    year,
    week,
    kategoria1,
    kategoria2,
    kategoria3,
    SUM(ilosc_odslon) AS wyswietlenia,
    SUM(unique_transactions) AS transakcje,
    SUM(quantity) AS liczba_sztuk,
    SUM(basket) AS koszyk
FROM
    tabela2
GROUP BY
    1, 2, 3, 4, 5
ORDER BY
    1 DESC
LIMIT 5;