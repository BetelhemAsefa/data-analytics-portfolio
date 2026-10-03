USE game_platform;

DELIMITER $$
-- Procedure 1: Purchase Insertion
DROP PROCEDURE IF EXISTS sp_insert_purchase $$
CREATE PROCEDURE sp_insert_purchase(
    IN  p_player_id INT,
    IN  p_item_id INT,
    IN  p_amount DECIMAL(8,2),
    OUT p_purchase_id INT,
    OUT p_status VARCHAR(255)
)
proc:BEGIN
    -- Local variables
    DECLARE v_player_exists INT DEFAULT 0;
    DECLARE v_item_exists   INT DEFAULT 0;

    -- Error handler: any SQL error will roll back and set a message
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_purchase_id := NULL;
        SET p_status := 'Error: unexpected database error while inserting purchase.';
    END;

    -- Basic validation
    SELECT COUNT(*) INTO v_player_exists
    FROM Player
    WHERE player_id = p_player_id;

    IF v_player_exists = 0 THEN
        SET p_purchase_id := NULL;
        SET p_status := 'Error: player does not exist.';
        LEAVE proc;
    END IF;

    SELECT COUNT(*) INTO v_item_exists
    FROM Content_Item
    WHERE item_id = p_item_id;

    IF v_item_exists = 0 THEN
        SET p_purchase_id := NULL;
        SET p_status := 'Error: content item does not exist.';
        LEAVE proc;
    END IF;

    IF p_amount < 0 THEN
        SET p_purchase_id := NULL;
        SET p_status := 'Error: purchase amount must be non-negative.';
        LEAVE proc;
    END IF;

    -- Insert purchase inside a transaction
    START TRANSACTION;

    INSERT INTO Purchase (player_id, item_id, amount, purchased_at)
    VALUES (p_player_id, p_item_id, p_amount, NOW());

    SET p_purchase_id := LAST_INSERT_ID();
    COMMIT;

    SET p_status := 'OK: purchase created successfully.';
END $$
$$ revert delimiter
DELIMITER ;

-- Calling and running the procedure with the inputted values
SET @new_id = NULL;
SET @msg    = NULL;
CALL sp_insert_purchase(1, 40, 59.99, @new_id, @msg);
SELECT @new_id AS purchase_id, @msg AS status_message;


DELIMITER $$
-- Procedure 2: Get player's spending summary
CREATE PROCEDURE sp_get_player_spend_summary (
    IN  p_player_id       INT,            -- input: which player
    OUT p_total_spend     DECIMAL(10,2),  -- output: total $ spent
    OUT p_order_count     INT,            -- output: number of purchases
    OUT p_first_purchase  DATETIME,       -- output: first purchase time
    OUT p_last_purchase   DATETIME        -- output: most recent purchase
)
BEGIN
    -- Flag to check whether the player exists
    DECLARE v_player_exists INT DEFAULT 0;

    /*
      Error handling:
      If any SQL exception occurs inside the procedure,
      this EXIT handler will run and then re-throw the error.
    */
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Set outputs to NULL so the caller knows it failed
        SET p_total_spend = NULL;
        SET p_order_count = NULL;
        SET p_first_purchase = NULL;
        SET p_last_purchase = NULL;

        -- Re-raise the original error
        RESIGNAL;
    END;

    -- 1) Validate that the player exists
    SELECT COUNT(*) INTO v_player_exists
    FROM Player
    WHERE player_id = p_player_id;

    IF v_player_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Player does not exist in Player table';
    END IF;

    -- 2) Aggregate purchase data for that player
    SELECT
        COALESCE(SUM(amount), 0) AS total_spend,
        COUNT(*) AS order_count,
        MIN(purchased_at) AS first_purchase,
        MAX(purchased_at)  AS last_purchase
    INTO
        p_total_spend,
        p_order_count,
        p_first_purchase,
        p_last_purchase
    FROM Purchase
    WHERE player_id = p_player_id;

END$$

DELIMITER ;

-- Example output query
-- Calling and running the procedure with the inputted values
CALL sp_get_player_spend_summary(
    6,  -- a valid player_id (1-25)
    @p_total_spend,
    @p_order_count,
    @p_first_purchase,
    @p_last_purchase
);

SELECT
  @p_total_spend    AS total_spend,
  @p_order_count    AS order_count,
  @p_first_purchase AS first_purchase,
  @p_last_purchase  AS last_purchase;


DELIMITER $$
-- Procedure 3: Developer's Game Revenue from associated games.
-- Purpose:
    --   Returns a list of all games and DLC
    --   associated with a developer, including
    --   per-item revenue totals.
DROP PROCEDURE IF EXISTS sp_developer_game_revenue $$
CREATE PROCEDURE sp_developer_game_revenue(
    IN p_developer_id INT
)
BEGIN
    -- Error: NULL input
    IF p_developer_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Developer ID cannot be NULL';
    END IF;

    -- Error: Developer does not exist
    IF (SELECT COUNT(*) FROM Developer WHERE developer_id = p_developer_id) = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Developer ID does not exist';
    END IF;

    -- Return each game + DLC with revenue
    SELECT
        ci.item_id,
        ci.title,
        ROUND(COALESCE(SUM(p.amount), 0.00), 2) AS item_revenue
    FROM Content_Item ci
    JOIN Game g ON g.item_id = ci.item_id AND g.developer_id = p_developer_id

    LEFT JOIN DLC d ON d.parent_game_id = g.item_id
    LEFT JOIN Purchase p ON p.item_id IN (ci.item_id, d.item_id)

    GROUP BY ci.item_id, ci.title
    ORDER BY item_revenue DESC, ci.title;

END $$
DELIMITER ;

-- =====================================================

DELIMITER $$
-- Function 1: Game's Total Revenue
DROP FUNCTION IF EXISTS fn_game_total_revenue $$
CREATE FUNCTION fn_game_total_revenue(
    p_game_item_id INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_exists INT DEFAULT 0;

    -- Validate input: ensure p_game_item_id exists in Game table
    -- (A game must exist in Game; DLC IDs should not be accepted)
    SELECT COUNT(*)
    INTO v_exists
    FROM Game
    WHERE item_id = p_game_item_id;

    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Game ID does not exist in content_item table.';
    END IF;
    -- Calculate total revenue:
    -- Sum purchases for the base game + all DLC tied to it.
    -- If no purchases exist, COALESCE ensures result = 0.00
    SELECT COALESCE(SUM(p.amount), 0.00)
    INTO v_total
    FROM Purchase p
    WHERE p.item_id = p_game_item_id
       OR p.item_id IN (
            SELECT d.item_id
            FROM DLC d
            WHERE d.parent_game_id = p_game_item_id
       );

    RETURN v_total;
END $$
DELIMITER ;



DELIMITER $$
-- Function 2: Developer's Total Revenue
-- Purpose: Returns the total revenue generated by a developer from:
			-- direct purchases of their games
            -- purchases of DLC whose parent game belongs to that developer.
DROP FUNCTION IF EXISTS fn_developer_total_revenue $$
CREATE FUNCTION fn_developer_total_revenue(
    p_developer_id INT   -- (IN) developer_id from Developer table
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total      DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_exists     INT DEFAULT 0;

    -- 1) Validate input is not NULL
    IF p_developer_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'fn_developer_total_revenue: developer id cannot be NULL';
    END IF;

	-- Error handling: If developer does not exist -> SIGNAL error
    -- 2) Check that the developer exists in the Developer table
    SELECT COUNT(*) INTO v_exists
    FROM Developer d
    WHERE d.developer_id = p_developer_id;

    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT ='fn_developer_total_revenue: developer id does not exist';
    END IF;

    -- 3) Revenue from base games by this developer
    SELECT
        COALESCE(SUM(p.amount), 0.00)
    INTO v_total
    FROM Purchase p
    JOIN Game g
      ON g.item_id = p.item_id
    WHERE g.developer_id = p_developer_id;

    -- 4) Add revenue from DLC whose parent game belongs to this developer
    SET v_total = v_total + COALESCE((
        SELECT COALESCE(SUM(p2.amount), 0.00)
        FROM Purchase p2
        JOIN DLC d
          ON d.item_id = p2.item_id
        JOIN Game g2
          ON g2.item_id = d.parent_game_id
        WHERE g2.developer_id = p_developer_id
    ), 0.00);

    -- 5) Return the combined revenue
    RETURN v_total;
END $$
DELIMITER ;