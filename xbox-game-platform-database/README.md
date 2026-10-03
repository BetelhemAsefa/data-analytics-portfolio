# Xbox Game Platform Database

A MySQL database modeled on the Xbox platform's backend. It manages games and DLC, players, purchases, subscriptions, and multiplayer sessions. On top of it, I built analytical queries, reporting views, automation, and Python visualizations.

## Business questions

- Which games and DLC bring in the most revenue and purchases?
- How concentrated is spending across players?
- How often do buyers of a base game also buy its DLC (attach rate)?
- How does subscription adoption vary by region?
- How can views, procedures, and triggers automate reporting and protect data integrity?

## Database design

The design starts from an EERD (`EERD.pdf`) with 10 core tables:

| Table | Purpose |
|---|---|
| `Content_Item` | Supertype for everything sold on the platform |
| `Game` / `DLC` | Subtypes of `Content_Item`; each DLC belongs to one parent game |
| `Developer` | Studio responsible for each game |
| `Player` | Accounts with unique email and gamertag |
| `Purchase` | Each transaction, linked to a player and a content item |
| `Subscription_Plan` / `Player_Subscription` | Plans and each player's subscription history (active, paused, or expired) |
| `Console_Model` | Hardware a session is played on |
| `Multiplayer_Session` / `Session_Participant` | Online sessions and the players in them |

Integrity is enforced with primary and foreign keys, UNIQUE constraints, ENUM status values, and cascade rules. `02_sample_data_and_tests.sql` also includes tests that confirm bad data is rejected: duplicate keys, invalid foreign keys, and negative amounts.

## Analysis (`05_analysis_queries.sql`)

12 queries using joins, CTEs, window functions (`RANK()`), and CASE logic, including:

- Top games by purchases and revenue
- Player lifetime spend, **average order value**, and **spend tiers** (Bronze, Silver, Gold, Platinum)
- **DLC attach rate** per base game
- Developer revenue that credits DLC sales back to the studio behind the parent game
- **Subscription adoption and active rate by region**
- Revenue by ESRB rating and by player region

## Reporting and automation

- **Views:** `v_game_kpis`, `v_player_kpis` (`03_views.sql`)
- **Summary tables:** daily revenue per game, lifetime totals per player (`04_summary_tables.sql`)
- **Stored procedures:** validated purchase insertion, player spending summary, developer revenue report
- **Functions:** total revenue per game (including DLC) and per developer (`06_procedures_and_functions.sql`)
- **Triggers:** purchase audit log, purchase validation, automatic host enrollment in multiplayer sessions (`07_triggers.sql`)
- **Transactions:** savepoint and rollback example (`08_transactions.sql`)
- **Roles:** separate DBA and read-only Analyst access (`09_roles.sql`)

## Visualization (`10_visualizations.ipynb`)

I exported query results to Python (pandas, matplotlib, seaborn) and built:
- a revenue ranking and a Pareto chart
- a spending distribution boxplot
- a daily revenue trend
- a revenue cohort heatmap
- a purchase funnel

## How to run

Run the SQL scripts in MySQL Workbench in numbered order (`01` through `09`):

1. `01_schema.sql`
2. `02_sample_data_and_tests.sql`
3. `03_views.sql`
4. `04_summary_tables.sql`
5. `05_analysis_queries.sql`
6. `06_procedures_and_functions.sql`
7. `07_triggers.sql`
8. `08_transactions.sql`
9. `09_roles.sql`

## Full report

See `Xbox_Game_Platform_Report.pdf` for the complete write-up with screenshots, charts, and recommendations.

## Notes

The database is loaded with a small sample (about 25 rows per table). The queries are written to work the same way at production scale, but the sample results are illustrations, not real-world findings.
