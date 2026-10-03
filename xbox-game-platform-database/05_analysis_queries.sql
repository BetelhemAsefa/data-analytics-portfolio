-- Q1: Top games by number of purchases
USE game_platform;

SELECT
  g.item_id            AS game_id,
  ci.title             AS game_title,
  COUNT(p.purchase_id) AS purchase_count
FROM Purchase p
JOIN Content_Item ci ON ci.item_id = p.item_id
JOIN Game g          ON g.item_id  = ci.item_id
GROUP BY g.item_id, ci.title
ORDER BY purchase_count DESC, game_title
LIMIT 10;
-- Insight: Elden Ring leads with the most purchases out of every other game. 
-- The other AAA games suggests a slighty lower interst.


-- Q2: Average multiplayer session length per console model, ranked
WITH session_lengths AS (
  SELECT
    ms.model_id,
    TIMESTAMPDIFF(MINUTE, ms.started_at, ms.ended_at) AS minutes_len
  FROM Multiplayer_Session ms
  WHERE ms.ended_at IS NOT NULL
)
SELECT
  cm.model_id,
  cm.name                         AS console_model,
  ROUND(AVG(sl.minutes_len), 1)   AS avg_minutes,
  RANK() OVER (ORDER BY AVG(sl.minutes_len) DESC) AS duration_rank
FROM session_lengths sl
JOIN Console_Model cm ON cm.model_id = sl.model_id
GROUP BY cm.model_id, cm.name
ORDER BY duration_rank, console_model;
-- Each console ties in average minutes because each session is 2 hours. 
-- To analyze, this few would highlight platforms that deliver longer play sessions, which is useful for optimization. 


-- Q3: Player lifetime spend, purchase count, Average Order Value (AOV), and spend tier
SELECT
  p.player_id,
  p.gamertag,
  COUNT(pr.purchase_id)                 AS orders,
  ROUND(SUM(pr.amount), 2)              AS lifetime_spend,
  ROUND(AVG(pr.amount), 2)              AS avg_order_value,
  CASE
    WHEN SUM(pr.amount) >= 69.99  THEN 'Platinum'
    WHEN SUM(pr.amount) >= 49.99  THEN 'Gold'
    WHEN SUM(pr.amount) >= 29.99  THEN 'Silver'
    WHEN SUM(pr.amount) >  0   THEN 'Bronze'
    ELSE                            'No Spend'
  END AS spend_tier
FROM Player p
LEFT JOIN Purchase pr ON pr.player_id = p.player_id
GROUP BY p.player_id, p.gamertag
ORDER BY lifetime_spend DESC, orders DESC, p.player_id
LIMIT 10;
-- Insight: There are players at the Platinum tier with disproportionate renevue.
-- This would suggest that targeted retention could be effective.


-- Q4: DLC attach rate per base game (buyers of base game who also bought its DLC)
WITH base_buyers AS (
  SELECT g.item_id AS game_id, p.player_id
  FROM Game g
  JOIN Purchase p ON p.item_id = g.item_id
),
dlc_buyers AS (
  SELECT d.parent_game_id AS game_id, p.player_id
  FROM DLC d
  JOIN Purchase p ON p.item_id = d.item_id
)
SELECT
  ci.title                           AS game_title,
  COUNT(DISTINCT bb.player_id)       AS game_buyers,
  COUNT(DISTINCT db.player_id)       AS dlc_buyers_for_that_game,
  ROUND(
    100.0 * COUNT(DISTINCT db.player_id)
         / NULLIF(COUNT(DISTINCT bb.player_id),0), 1
  )                                  AS dlc_attach_rate_pct
FROM base_buyers bb
JOIN Content_Item ci ON ci.item_id = bb.game_id
LEFT JOIN dlc_buyers db
  ON db.game_id = bb.game_id
GROUP BY ci.title
ORDER BY dlc_attach_rate_pct DESC, game_title;
-- Attach rates assist in prioritizing DLC pipelines.
-- Forza Horizo n 5 shows perfect attach, games like Elden Ring should consider pushing DLC bundles to its larger base.


-- Q5: Developer Studios' revenue from their games + DLC that are tied to those games
WITH content_to_dev AS (
  -- map each content item to the responsible developer
  SELECT g.item_id AS item_id, g.developer_id
  FROM Game g
  UNION ALL
  SELECT d.item_id AS item_id, g.developer_id
  FROM DLC d
  JOIN Game g ON g.item_id = d.parent_game_id
)
SELECT
  d.name                                          AS developer,
  ROUND(SUM(p.amount), 2)                         AS total_revenue,
  COUNT(p.purchase_id)                            AS orders,
  RANK() OVER (ORDER BY SUM(p.amount) DESC)       AS rev_rank
FROM Purchase p
JOIN content_to_dev m ON m.item_id = p.item_id
JOIN Developer d      ON d.developer_id = m.developer_id
GROUP BY d.name
ORDER BY rev_rank, developer;
-- Insight: By joining the DLC and parent game revenue, the earnings are credited to the developer studio that owns the franchise.
-- 10 studios are tied. This helps identify which studios should recieve more content investments.


-- Q6: Subscription adoption and active rate by region
WITH adoption AS (
  SELECT
    pl.region,
    COUNT(DISTINCT ps.player_id)   AS subs_players,
    SUM(ps.status = 'active')      AS active_rows,  -- counts rows
    COUNT(*)                       AS total_rows
  FROM Player_Subscription ps
  JOIN Player pl ON pl.player_id = ps.player_id
  GROUP BY pl.region
)
SELECT
  region,
  subs_players,
  total_rows  AS sub_records,
  active_rows,
  ROUND(100.0 * active_rows / NULLIF(total_rows,0), 1) AS active_rate_pct,
  ROUND(
    100.0 * subs_players / NULLIF((SELECT COUNT(*) FROM Player),0), 1
  )                                                 AS adoption_pct_of_players
FROM adoption
ORDER BY active_rate_pct DESC, subs_players DESC, region;
-- Insight: Smaller regions show a lower rate of active share.
-- In this dataset, Germany has the largested subcriber base with a strong active rate of ~100%. 


-- Q7: Days between first and most recent purchase per player
SELECT
  p.player_id,
  p.gamertag,
  MIN(pr.purchased_at) AS first_purchase,
  MAX(pr.purchased_at) AS last_purchase,
  TIMESTAMPDIFF(DAY, MIN(pr.purchased_at), MAX(pr.purchased_at)) AS days_between
FROM Player p
JOIN Purchase pr ON pr.player_id = p.player_id
GROUP BY p.player_id, p.gamertag
ORDER BY days_between DESC;
-- Insight: Estimates how long players stay active. This is based on their purchase history.
-- This measures those gamers who would likely return for new content.
-- Based on  the data, all gamers made only one purchase, showing a low rentention rate.


-- Q8: Total revenue by Entertainment Software Rating Board (ESRB) rating
SELECT
  g.esrb_rating,
  ROUND(SUM(p.amount), 2) AS total_revenue,
  COUNT(p.purchase_id)    AS total_purchases,
  ROUND(AVG(p.amount), 2) AS avg_price
FROM Purchase p
JOIN Game g ON g.item_id = p.item_id
GROUP BY g.esrb_rating
ORDER BY total_revenue DESC;
-- Insight: This shows which categories of ESRB can create the most revenue.
-- Titles that are rated mature take the most sales and revenue volume
-- This suggest the platform's average buyings are mature gamers, whille a good number are teen-rated.
-- E-rated games show the least amount of traction for gamers.


-- Q9: Developer performance (total game revenue)
SELECT
  d.name AS studio,
  ROUND(SUM(p.amount), 2) AS total_revenue,
  COUNT(p.purchase_id) AS games_sold,
  RANK() OVER (ORDER BY SUM(p.amount) DESC) AS revenue_rank
FROM Developer d
JOIN Game g ON g.developer_id = d.developer_id
JOIN Purchase p ON p.item_id = g.item_id
GROUP BY d.name
ORDER BY total_revenue DESC;
-- Insight: Ranks developer teams by their sales revenue.
-- Studios such as FromSoftware and Insomniac Games are ranked high due to their high-value games like Elden Ring and the Spiderman series.
-- This ranking identifies which studio pullls in the most revenue on Xbox.


-- Q10: Most active multiplayer hosts
SELECT
  p.gamertag,
  COUNT(ms.session_id) AS sessions_hosted,
  ROUND(AVG(TIMESTAMPDIFF(MINUTE, ms.started_at, ms.ended_at)), 1) AS avg_duration_min
FROM Multiplayer_Session ms
JOIN Player p ON p.player_id = ms.host_player_id
GROUP BY p.gamertag
ORDER BY sessions_hosted DESC, avg_duration_min DESC
LIMIT 10;
-- Insight: Determines which players host the most multiplayer sessions.
-- All players host an equal amount of muiltplayer sessions.
-- These hosts support multiplayer engagement and can bring new players to the online Xbox community.

-- Q11: Revenue by Game (title, revenue, orders)
SELECT
  ci.title            AS game_title,
  ROUND(SUM(p.amount), 2) AS total_revenue,
  COUNT(*)            AS orders
FROM Purchase p
JOIN Content_Item ci ON ci.item_id = p.item_id
JOIN Game g ON g.item_id = ci.item_id
GROUP BY ci.title
ORDER BY total_revenue DESC, orders DESC, game_title;

-- Q12: Purchases categorized by player region (region, purchases, revenue)
SELECT
  pl.region,
  COUNT(*)             AS purchases,
  ROUND(SUM(p.amount), 2) AS revenue
FROM Purchase p
JOIN Player pl ON pl.player_id = p.player_id
GROUP BY pl.region
ORDER BY purchases DESC, revenue DESC, region;
