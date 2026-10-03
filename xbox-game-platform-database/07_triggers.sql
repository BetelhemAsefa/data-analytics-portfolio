USE game_platform;
-- Table used forr Triggers 1 & 2
CREATE TABLE IF NOT EXISTS Purchase_Auditing (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,   -- unique row id
    purchase_id INT,                           -- Purchase.purchase_id
    player_id INT,
    item_id INT,
    amount DECIMAL(8,2),
    purchased_at DATETIME,
    action_type ENUM('INSERT','UPDATE','DELETE') NOT NULL,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


DELIMITER //
-- Trigger 1: Purchase Audit
-- Purpose: Audit every new purchase made on the platform.
DROP TRIGGER IF EXISTS trigger_purchase_after_insert_audit //
CREATE TRIGGER trigger_purchase_after_insert_audit
AFTER INSERT ON Purchase
FOR EACH ROW
BEGIN
    /*
      Behavior:
        Whenever a row is inserted into Purchase, copy key details
        into Purchase_Audit with action_type = 'INSERT'.
      This:
        • logs history of data changes
        • After trigger requirement (runs after the row is committed)
    */
    INSERT INTO Purchase_Auditing
        (purchase_id, player_id, item_id, amount, purchased_at, action_type)
    VALUES
        (NEW.purchase_id, NEW.player_id, NEW.item_id, NEW.amount, NEW.purchased_at, 'INSERT');
END //
//
DELIMITER ;
-- Audits every new purchase made on the platform.
-- Whenever a new row is inserted into Purchase table, details are inserted into Pruchase_Auditing table.

INSERT INTO Purchase (player_id, item_id, amount)
VALUES (3, 3, 69.99);
-- Will insert values along with coresponding details into audit table 

SELECT * FROM Purchase_Auditing
ORDER BY audit_id DESC
LIMIT 5;



Delimiter //
-- Trigger 2: Pruchase Integrity
DROP TRIGGER IF EXISTS trigger_purchase_integrity //
CREATE TRIGGER trigger_purchase_integrity
BEFORE INSERT ON Purchase
FOR EACH ROW
BEGIN
    DECLARE v_is_valid_item INT DEFAULT 0;

    -- Integrity rule #1: amount must be positive
    IF NEW.amount IS NULL OR NEW.amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Purchase amount must be greater than zero';
    END IF;

    -- Integrity rule #2: item_id must be a purchasable title
    --                    (either a Game or a DLC row)
    SELECT COUNT(*) INTO v_is_valid_item
    FROM (
        SELECT item_id FROM Game WHERE item_id = NEW.item_id
        UNION ALL
        SELECT item_id FROM DLC  WHERE item_id = NEW.item_id
    ) AS x;

    IF v_is_valid_item = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Purchase item_id must refer to a Game or DLC';
    END IF;

END //
DELIMITER ;

INSERT INTO Purchase (player_id, item_id, amount)
VALUES (1, 1, -5.00);
-- Expected Result: ERROR: "Purchase amount must be greater than zero"

INSERT INTO Purchase (player_id, item_id, amount)
VALUES (1, 500, 59.99);
-- assume 500 is a Content_Item that is not within Game or DLC tables
-- Expected Result: ERROR: "Purchase item_id must refer to a Game or DLC"

INSERT INTO Purchase (player_id, item_id, amount)
VALUES (1, 21, 9.99);   -- item_id 1 is a real Game id
-- Expected Result: Successful Purchase




DELIMITER //
-- Trigger 3: Mulitplayer Session Automation 
-- Purpose: Whenever a new multiplayer session is created, 
--          automatically insert the host player into Session_Participant
--          so host is counted as a participant
DROP TRIGGER IF EXISTS trigger_multiplayer_session_auto_host //
CREATE TRIGGER trigger_multiplayer_session_auto_host
AFTER INSERT ON Multiplayer_Session
FOR EACH ROW
BEGIN
    -- Notes:
    --   • Skips insert if host_player_id is NULL
    --   • Skips insert if a (session_id, player_id)
    --     row already exists (defensive).
    DECLARE v_exists INT DEFAULT 0;

    -- Only do anything if there *is* a host
    IF NEW.host_player_id IS NOT NULL THEN

        -- Check if this host is already in Session_Participant
        SELECT COUNT(*) INTO v_exists
        FROM Session_Participant sp
        WHERE sp.session_id = NEW.session_id
          AND sp.player_id  = NEW.host_player_id;

        -- If not, insert an automatic participant row
        IF v_exists = 0 THEN
            INSERT INTO Session_Participant (
                session_id,
                player_id,
                joined_at,
                left_at
            )
            VALUES (
                NEW.session_id,
                NEW.host_player_id,
                NEW.started_at,   
                NEW.ended_at      
            );
        END IF;
    END IF;
END //
//
DELIMITER ;

-- Example output query
INSERT INTO Multiplayer_Session (game_id, model_id, host_player_id, started_at, ended_at)
VALUES (9, 5, 12, '2025-09-06 14:00:00', '2025-09-06 16:00:00');

SELECT * 
FROM Session_Participant
WHERE session_id = LAST_INSERT_ID();

