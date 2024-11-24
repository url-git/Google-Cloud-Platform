WITH add_to_basket AS (
    SELECT
        date,
        fullvisitorid,
        device.deviceCategory AS urzadzenie,
        visitid,
        (SELECT value FROM t.customDimensions WHERE index = 6) AS typ,
        hits.eCommerceAction.action_type,
        'PL' AS kraj,
        MIN(hits.time) AS add_to_basket
    FROM
        `eobuwie-181013.3869171.ga_sessions_*` AS t,
        UNNEST(hits) AS hits,
        UNNEST(hits.product) AS product
    WHERE
        _TABLE_SUFFIX BETWEEN '20210101' AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
        AND hits.eCommerceAction.action_type = '3'
    GROUP BY
        1, 2, 3, 4, 5, 6

    UNION ALL

    SELECT
        date,
        fullvisitorid,
        device.deviceCategory AS urzadzenie,
        visitid,
        (SELECT value FROM t.customDimensions WHERE index = 6) AS typ,
        hits.eCommerceAction.action_type,
        'modivo.pl' AS kraj,
        MIN(hits.time) AS add_to_basket
    FROM
        `modivo-237010.191117789.ga_sessions_*` AS t,
        UNNEST(hits) AS hits,
        UNNEST(hits.product) AS product
    WHERE
        _TABLE_SUFFIX BETWEEN '20210101' AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
        AND hits.eCommerceAction.action_type = '3'
    GROUP BY
        1, 2, 3, 4, 5, 6
    HAVING
        add_to_basket > 0
),

bought AS (
    SELECT
        date,
        fullvisitorid,
        device.deviceCategory AS urzadzenie,
        visitid,
        (SELECT value FROM t.customDimensions WHERE index = 6) AS typ,
        hits.eCommerceAction.action_type,
        'PL' AS kraj,
        MIN(hits.time) AS bought
    FROM
        `eobuwie-181013.3869171.ga_sessions_*` AS t,
        UNNEST(hits) AS hits,
        UNNEST(hits.product) AS product
    WHERE
        _TABLE_SUFFIX BETWEEN '20210101' AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
        AND hits.eCommerceAction.action_type = '6'
    GROUP BY
        1, 2, 3, 4, 5, 6

    UNION ALL

    SELECT
        date,
        fullvisitorid,
        device.deviceCategory AS urzadzenie,
        visitid,
        (SELECT value FROM t.customDimensions WHERE index = 6) AS typ,
        hits.eCommerceAction.action_type,
        'modivo.pl' AS kraj,
        MIN(hits.time) AS bought
    FROM
        `modivo-237010.191117789.ga_sessions_*` AS t,
        UNNEST(hits) AS hits,
        UNNEST(hits.product) AS product
    WHERE
        _TABLE_SUFFIX BETWEEN '20210101' AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
        AND hits.eCommerceAction.action_type = '6'
    GROUP BY
        1, 2, 3, 4, 5, 6
    HAVING
        bought > 0
)

SELECT
    kraj,
    roznica,
    date,
    urzadzenie,
    typ
FROM (
    SELECT
        a.date,
        a.fullvisitorid,
        a.visitid,
        a.urzadzenie,
        a.typ,
        a.kraj,
        a.add_to_basket,
        b.bought,
        (b.bought - a.add_to_basket) / 1000 AS roznica
    FROM
        add_to_basket a
    LEFT JOIN
        bought b
    ON
        a.fullvisitorid = b.fullvisitorid
        AND a.visitid = b.visitid
        AND a.kraj = b.kraj
        AND a.urzadzenie = b.urzadzenie
    WHERE
        b.bought > 0
)
GROUP BY
    1, 2, 3, 4, 5
LIMIT 5;