USE game_platform;

-- Summary 1: Daily revenue & purchases per game
CREATE TABLE IF NOT EXISTS Summary_Game_Daily (
    summary_date    DATE        NOT NULL,
    game_id         INT         NOT NULL,
    game_title      VARCHAR(255) NOT NULL,
    game_purchases  INT         NOT NULL,
    dlc_purchases   INT         NOT NULL,
    game_revenue    DECIMAL(10,2) NOT NULL,
    dlc_revenue     DECIMAL(10,2) NOT NULL,
    total_revenue   DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (summary_date, game_id)
);

-- Clear old data before refreshing
TRUNCATE TABLE Summary_Game_Daily;

-- Insert daily game + DLC revenue per game
INSERT INTO Summary_Game_Daily (
    summary_date,
    game_id,
    game_title,
    game_purchases,
    dlc_purchases,
    game_revenue,
    dlc_revenue,
    total_revenue
)
SELECT
    summary_date,
    game_id,
    MAX(game_title) AS game_title,
    SUM(game_purchases) AS game_purchases,
    SUM(dlc_purchases) AS dlc_purchases,
    SUM(game_revenue)  AS game_revenue,
    SUM(dlc_revenue)   AS dlc_revenue,
    SUM(game_revenue) + SUM(dlc_revenue) AS total_revenue
FROM (
    -- Base game purchases per day
    SELECT
        DATE(p.purchased_at)     AS summary_date,
        g.item_id                AS game_id,
        ci.title                 AS game_title,
        COUNT(*)                 AS game_purchases,
        0                        AS dlc_purchases,
        SUM(p.amount)            AS game_revenue,
        0                        AS dlc_revenue
    FROM Purchase p
    JOIN Game g
      ON g.item_id = p.item_id
    JOIN Content_Item ci
      ON ci.item_id = g.item_id
    GROUP BY DATE(p.purchased_at), g.item_id, ci.title

    UNION ALL

    -- DLC purchases per day, rolled up to the parent game
    SELECT
        DATE(p.purchased_at)     AS summary_date,
        d.parent_game_id         AS game_id,
        ci2.title                AS game_title,
        0                        AS game_purchases,
        COUNT(*)                 AS dlc_purchases,
        0                        AS game_revenue,
        SUM(p.amount)            AS dlc_revenue
    FROM Purchase p
    JOIN DLC d
      ON d.item_id = p.item_id
    JOIN Game g2
      ON g2.item_id = d.parent_game_id
    JOIN Content_Item ci2
      ON ci2.item_id = g2.item_id
    GROUP BY DATE(p.purchased_at), d.parent_game_id, ci2.title
) x
GROUP BY summary_date, game_id;


-- Summary 2: Per-player total spend and purchase activity
CREATE TABLE IF NOT EXISTS Summary_Player_Total (
    player_id        INT          NOT NULL,          -- references Player.player_id
    gamertag         VARCHAR(40)  NOT NULL,
    total_purchases  INT          NOT NULL,
    total_spend      DECIMAL(10,2) NOT NULL,
    first_purchase   DATETIME     NULL,
    last_purchase    DATETIME     NULL,
    PRIMARY KEY (player_id)
);

TRUNCATE TABLE Summary_Player_Total;

INSERT INTO Summary_Player_Total (
    player_id,
    gamertag,
    total_purchases,
    total_spend,
    first_purchase,
    last_purchase
)
SELECT
    p.player_id,
    p.gamertag,
    COUNT(pr.purchase_id)                 AS total_purchases,
    COALESCE(ROUND(SUM(pr.amount), 2),0)  AS total_spend,
    MIN(pr.purchased_at)                  AS first_purchase,
    MAX(pr.purchased_at)                  AS last_purchase
FROM Player p
LEFT JOIN Purchase pr
  ON pr.player_id = p.player_id
GROUP BY p.player_id, p.gamertag;


-- testing summary tables
SELECT * FROM summary_game_daily;
SELECT * FROM summary_player_total;


