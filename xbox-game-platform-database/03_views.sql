CREATE OR REPLACE VIEW v_game_kpis AS
SELECT
    g.item_id                          AS game_id,
    ci.title                           AS game_title,
    COALESCE(gs.game_purchases, 0)     AS game_purchases,
    COALESCE(gs.game_revenue, 0)       AS game_revenue,
    COALESCE(ds.dlc_purchases, 0)      AS dlc_purchases,
    COALESCE(ds.dlc_revenue, 0)        AS dlc_revenue,
    COALESCE(gs.game_revenue, 0)
      + COALESCE(ds.dlc_revenue, 0)    AS total_revenue
FROM Game g
JOIN Content_Item ci
  ON ci.item_id = g.item_id

-- base-game purchases
LEFT JOIN (
    SELECT
        p.item_id              AS game_id,
        COUNT(*)               AS game_purchases,
        SUM(p.amount)          AS game_revenue
    FROM Purchase p
    JOIN Game g2
      ON g2.item_id = p.item_id
    GROUP BY p.item_id
) gs
  ON gs.game_id = g.item_id

-- DLC purchases mapped back to parent game
LEFT JOIN (
    SELECT
        d.parent_game_id       AS game_id,
        COUNT(p.purchase_id)   AS dlc_purchases,
        SUM(p.amount)          AS dlc_revenue
    FROM DLC d
    JOIN Purchase p
      ON p.item_id = d.item_id
    GROUP BY d.parent_game_id
) ds
  ON ds.game_id = g.item_id;



CREATE OR REPLACE VIEW v_player_kpis AS
SELECT
    pl.player_id,
    pl.gamertag,
    COALESCE(gs.games_bought, 0)   AS games_bought,
    COALESCE(gs.game_spend, 0)     AS game_spend,
    COALESCE(ds.dlcs_bought, 0)    AS dlcs_bought,
    COALESCE(ds.dlc_spend, 0)      AS dlc_spend,
    COALESCE(gs.game_spend, 0)
      + COALESCE(ds.dlc_spend, 0)  AS total_spend
FROM Player pl

-- game purchases per player
LEFT JOIN (
    SELECT
        p.player_id,
        COUNT(DISTINCT p.item_id) AS games_bought,
        SUM(p.amount)             AS game_spend
    FROM Purchase p
    JOIN Game g
      ON g.item_id = p.item_id
    GROUP BY p.player_id
) gs
  ON gs.player_id = pl.player_id

-- DLC purchases per player
LEFT JOIN (
    SELECT
        p.player_id,
        COUNT(DISTINCT p.item_id) AS dlcs_bought,
        SUM(p.amount)             AS dlc_spend
    FROM Purchase p
    JOIN DLC d
      ON d.item_id = p.item_id
    GROUP BY p.player_id
) ds
  ON ds.player_id = pl.player_id;

-- getting the tables
SELECT * FROM v_game_kpis;
SELECT * FROM v_player_kpis;
