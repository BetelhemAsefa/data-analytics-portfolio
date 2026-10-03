-- Show purchases BEFORE transaction
SELECT * FROM Purchase WHERE player_id = 21;

-- Begin Transaction
START TRANSACTION;

-- Valid purchase inserted
INSERT INTO Purchase (player_id, item_id, amount, purchased_at)
VALUES (21, 3, 69.99, NOW());

-- Creates savepoint before the next purchase is inserted.
SAVEPOINT before_next_insert;

-- Insert Another Purchase; Let's says it's a mistaken purchase
INSERT INTO Purchase (player_id, item_id, amount, purchased_at)
VALUES (21, 19, 69.99, NOW()); 

-- Rollback to the savepoint
-- Removes only the second insert
ROLLBACK TO before_next_insert;

-- Commit transaction;
-- Saves all changes made during transaction
COMMIT;

-- Show table results AFTER commit
SELECT * FROM Purchase WHERE player_id = 21;