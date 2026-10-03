USE game_platform;

-- Developer (25 rows)
INSERT INTO Developer (name) VALUES
('343 Industries'),
('Ubisoft Montreal'),
('Naughty Dog'),
('CD Projekt Red'),
('Insomniac Games'),
('Rockstar North'),
('Infinity Ward'),
('Bungie'),
('FromSoftware'),
('Rare Ltd'),
('Valve Corporation'),
('Respawn Entertainment'),
('Obsidian Entertainment'),
('Arkane Studios'),
('Guerrilla Games'),
('Bethesda Game Studios'),
('Remedy Entertainment'),
('Playground Games'),
('IO Interactive'),
('Capcom'),('Bioware'),
('Eidos Montreal'),
('Techland'),
('id Software'),
('Crystal Dynamics');


-- Content_Item (25 rows: 20 games, 5 DLC)
INSERT INTO Content_Item (title, release_date, base_price) VALUES
('Halo Infinite','2021-12-08',59.99),('Assassins Creed Mirage','2023-10-05',49.99),
('Spider-Man 2','2023-10-20',69.99),('Cyberpunk 2077','2020-12-10',59.99),
('Elden Ring','2022-02-25',59.99),('Forza Horizon 5','2021-11-09',59.99),
('Red Dead Redemption 2','2018-10-26',59.99),('DOOM Eternal','2020-03-20',59.99),
('Destiny 2','2017-09-06',39.99),('Starfield','2023-09-06',69.99),
('Overwatch 2','2022-10-04',0.00),('Alan Wake 2','2023-10-27',49.99),
('The Witcher 3','2015-05-19',39.99),('Control','2019-08-27',49.99),
('GTA V','2013-09-17',29.99),('Sea of Thieves','2018-03-20',39.99),
('Deathloop','2021-09-14',59.99),('Call of Duty: MWIII','2023-11-10',69.99),
('Horizon Forbidden West','2022-02-18',69.99),('Resident Evil 4 Remake','2023-03-24',59.99),
('Halo Infinite: Lone Wolves DLC','2022-05-03',9.99),
('Cyberpunk: Phantom Liberty','2023-09-26',19.99),
('Destiny 2: Lightfall','2023-02-28',29.99),
('Forza Horizon 5: Rally Adventure','2023-03-29',14.99),
('Elden Ring: Shadow of the Erdtree','2024-02-25',19.99);


-- Game (20 games)
INSERT INTO Game (item_id, genre, esrb_rating, coop_supported, developer_id) VALUES
(1,'FPS','T',1,1),
(2,'Action-Adventure','M',0,2),
(3,'Action','T',0,5),
(4,'RPG','M',0,4),
(5,'RPG','M',1,9),
(6,'Racing','E','1',18),
(7,'Action-Adventure','M',0,6),
(8,'Shooter','M',1,24),
(9,'FPS','T',1,8),
(10,'RPG','M',0,16),
(11,'Shooter','T',1,11),
(12,'Horror','M',0,17),
(13,'RPG','M',0,4),
(14,'Action','M',0,17),
(15,'Action-Adventure','M',0,6),
(16,'Adventure','T',1,10),
(17,'Shooter','M',1,14),
(18,'Shooter','M',1,7),
(19,'Action-Adventure','T',0,15),
(20,'Horror','M',0,20);

-- DLC (5 rows)
INSERT INTO DLC (item_id, parent_game_id) VALUES
(21,1),(22,4),(23,9),(24,6),(25,5);

-- Player (25 rows)
INSERT INTO Player (email, gamertag, region, created_at) VALUES
('player1@mail.com','GamerOne','US','2024-01-01'),
('player2@mail.com','DarkKnight','US','2024-01-02'),
('player3@mail.com','PixelHero','CA','2024-01-03'),
('player4@mail.com','SniperWolf','UK','2024-01-04'),
('player5@mail.com','SpeedRacer','JP','2024-01-05'),
('player6@mail.com','ShadowFox','DE','2024-01-06'),
('player7@mail.com','ArcadeKing','FR','2024-01-07'),
('player8@mail.com','NovaBlast','US','2024-01-08'),
('player9@mail.com','StormBreaker','BR','2024-01-09'),
('player10@mail.com','SilentHunter','US','2024-01-10'),
('player11@mail.com','EchoZero','CA','2024-01-11'),
('player12@mail.com','FlameOn','DE','2024-01-12'),
('player13@mail.com','QuickScope','US','2024-01-13'),
('player14@mail.com','DreamWeaver','FR','2024-01-14'),
('player15@mail.com','NeonFury','UK','2024-01-15'),
('player16@mail.com','AquaWave','US','2024-01-16'),
('player17@mail.com','CrimsonWolf','JP','2024-01-17'),
('player18@mail.com','OmegaStrike','CA','2024-01-18'),
('player19@mail.com','PhantomEdge','US','2024-01-19'),
('player20@mail.com','BlueComet','US','2024-01-20'),
('player21@mail.com','VenomRush','DE','2024-01-21'),
('player22@mail.com','ZeroKnight','US','2024-01-22'),
('player23@mail.com','CloudDrift','CA','2024-01-23'),
('player24@mail.com','SteelFang','US','2024-01-24'),
('player25@mail.com','InfernoCore','FR','2024-01-25');

-- Console_Model (25 rows)
INSERT INTO Console_Model (name, release_year) VALUES
('Xbox One',2013),('Xbox One S',2016),('Xbox One X',2017),
('Xbox Series S',2020),('Xbox Series X',2020),
('PlayStation 4',2013),('PlayStation 5',2020),('Nintendo Switch',2017),
('Steam Deck',2022),('PC',2010),
('ROG Ally',2023),('Xbox 360',2005),('PlayStation 3',2006),
('PS Vita',2011),('Oculus Quest 2',2020),('Valve Index',2019),
('PS Portal',2024),('PlayStation TV',2013),('Meta Quest 3',2023),
('GameCube',2001),('Dreamcast',1999),('Wii',2006),('Wii U',2012),
('Switch OLED',2021),('PSP',2005);

-- Player_Subscription (25 rows)
INSERT INTO Player_Subscription (player_id, plan_id, start_date, status) VALUES
(1,3,'2025-01-01','active'),(2,1,'2024-02-01','expired'),(3,2,'2025-01-05','active'),
(4,5,'2024-11-05','paused'),(5,4,'2024-03-05','active'),(6,6,'2024-05-10','active'),
(7,7,'2024-04-04','expired'),(8,8,'2024-09-09','paused'),(9,9,'2025-02-10','active'),
(10,10,'2024-01-01','active'),(11,11,'2024-07-01','paused'),(12,12,'2024-06-01','active'),
(13,13,'2024-04-01','expired'),(14,14,'2024-03-01','active'),(15,15,'2024-05-01','active'),
(16,16,'2024-02-01','paused'),(17,17,'2025-01-01','active'),(18,18,'2024-10-01','active'),
(19,19,'2024-07-01','expired'),(20,20,'2024-01-01','paused'),(21,21,'2024-06-01','active'),
(22,22,'2024-08-01','active'),(23,23,'2024-09-01','active'),(24,24,'2024-10-01','active'),
(25,25,'2025-01-01','active');

-- Purchase (25 rows)
INSERT INTO Purchase (player_id, item_id, amount, purchased_at) VALUES
(1,1,59.99,'2025-01-01 10:00:00'),(2,2,49.99,'2025-01-02 11:00:00'),
(3,3,69.99,'2025-01-03 12:00:00'),(4,4,59.99,'2025-01-04 13:00:00'),
(5,5,59.99,'2025-01-05 14:00:00'),(6,6,59.99,'2025-01-06 15:00:00'),
(7,7,59.99,'2025-01-07 16:00:00'),(8,8,59.99,'2025-01-08 17:00:00'),
(9,9,39.99,'2025-01-09 18:00:00'),(10,10,69.99,'2025-01-10 19:00:00'),
(11,21,9.99,'2025-01-11 20:00:00'),(12,22,19.99,'2025-01-12 21:00:00'),
(13,23,29.99,'2025-01-13 22:00:00'),(14,24,14.99,'2025-01-14 23:00:00'),
(15,25,19.99,'2025-01-15 10:00:00'),(16,3,69.99,'2025-01-16 11:00:00'),
(17,4,59.99,'2025-01-17 12:00:00'),(18,5,59.99,'2025-01-18 13:00:00'),
(19,7,59.99,'2025-01-19 14:00:00'),(20,8,59.99,'2025-01-20 15:00:00'),
(21,9,39.99,'2025-01-21 16:00:00'),(22,10,69.99,'2025-01-22 17:00:00'),
(23,1,59.99,'2025-01-23 18:00:00'),(24,2,49.99,'2025-01-24 19:00:00'),
(25,5,59.99,'2025-01-25 20:00:00');

-- Multiplayer_Session (25 rows)
INSERT INTO Multiplayer_Session (game_id, model_id, host_player_id, started_at, ended_at) VALUES
(1,5,1,'2025-03-01 18:00:00','2025-03-01 20:00:00'),
(2,4,2,'2025-03-02 18:00:00','2025-03-02 20:00:00'),
(3,3,3,'2025-03-03 18:00:00','2025-03-03 20:00:00'),
(4,2,4,'2025-03-04 18:00:00','2025-03-04 20:00:00'),
(5,1,5,'2025-03-05 18:00:00','2025-03-05 20:00:00'),
(6,10,6,'2025-03-06 18:00:00','2025-03-06 20:00:00'),
(7,8,7,'2025-03-07 18:00:00','2025-03-07 20:00:00'),
(8,9,8,'2025-03-08 18:00:00','2025-03-08 20:00:00'),
(9,4,9,'2025-03-09 18:00:00','2025-03-09 20:00:00'),
(10,5,10,'2025-03-10 18:00:00','2025-03-10 20:00:00'),
(11,2,11,'2025-03-11 18:00:00','2025-03-11 20:00:00'),
(12,3,12,'2025-03-12 18:00:00','2025-03-12 20:00:00'),
(13,4,13,'2025-03-13 18:00:00','2025-03-13 20:00:00'),
(14,5,14,'2025-03-14 18:00:00','2025-03-14 20:00:00'),
(15,10,15,'2025-03-15 18:00:00','2025-03-15 20:00:00'),
(16,7,16,'2025-03-16 18:00:00','2025-03-16 20:00:00'),
(17,8,17,'2025-03-17 18:00:00','2025-03-17 20:00:00'),
(18,9,18,'2025-03-18 18:00:00','2025-03-18 20:00:00'),
(19,3,19,'2025-03-19 18:00:00','2025-03-19 20:00:00'),
(20,4,20,'2025-03-20 18:00:00','2025-03-20 20:00:00'),
(1,5,21,'2025-03-21 18:00:00','2025-03-21 20:00:00'),
(2,4,22,'2025-03-22 18:00:00','2025-03-22 20:00:00'),
(3,3,23,'2025-03-23 18:00:00','2025-03-23 20:00:00'),
(4,2,24,'2025-03-24 18:00:00','2025-03-24 20:00:00'),
(5,1,25,'2025-03-25 18:00:00','2025-03-25 20:00:00');

-- Session_Participant (25 rows)
INSERT INTO Session_Participant (session_id, player_id, joined_at, left_at) VALUES
(1,1,'2025-03-01 18:00:00','2025-03-01 20:00:00'),
(1,2,'2025-03-01 18:05:00','2025-03-01 20:00:00'),
(2,3,'2025-03-02 18:10:00','2025-03-02 19:50:00'),
(3,4,'2025-03-03 18:15:00','2025-03-03 19:55:00'),
(4,5,'2025-03-04 18:20:00','2025-03-04 19:50:00'),
(5,6,'2025-03-05 18:25:00','2025-03-05 20:00:00'),
(6,7,'2025-03-06 18:00:00','2025-03-06 19:55:00'),
(7,8,'2025-03-07 18:10:00','2025-03-07 20:00:00'),
(8,9,'2025-03-08 18:00:00','2025-03-08 20:00:00'),
(9,10,'2025-03-09 18:10:00','2025-03-09 20:00:00'),
(10,11,'2025-03-10 18:15:00','2025-03-10 20:00:00'),
(11,12,'2025-03-11 18:10:00','2025-03-11 20:00:00'),
(12,13,'2025-03-12 18:05:00','2025-03-12 20:00:00'),
(13,14,'2025-03-13 18:00:00','2025-03-13 20:00:00'),
(14,15,'2025-03-14 18:10:00','2025-03-14 20:00:00'),
(15,16,'2025-03-15 18:00:00','2025-03-15 20:00:00'),
(16,17,'2025-03-16 18:00:00','2025-03-16 20:00:00'),
(17,18,'2025-03-17 18:10:00','2025-03-17 20:00:00'),
(18,19,'2025-03-18 18:00:00','2025-03-18 20:00:00'),
(19,20,'2025-03-19 18:15:00','2025-03-19 20:00:00'),
(20,21,'2025-03-20 18:10:00','2025-03-20 20:00:00'),
(21,22,'2025-03-21 18:05:00','2025-03-21 20:00:00'),
(22,23,'2025-03-22 18:10:00','2025-03-22 20:00:00'),
(23,24,'2025-03-23 18:15:00','2025-03-23 20:00:00'),
(24,25,'2025-03-24 18:10:00','2025-03-24 20:00:00');

-- tests (expect duplicate-key error 1062)
START TRANSACTION;
  INSERT INTO player (email, gamertag, region)
  SELECT email, CONCAT(gamertag,'_dup'), region FROM player LIMIT 1;
-- expected: ERROR 1062 (email UNIQUE)
ROLLBACK;

-- FOREIGN KEY tests (expect child-row error 1452) 
START TRANSACTION;
  INSERT INTO game (item_id, genre, esrb_rating, coop_supported, developer_id)
  VALUES (999999,'Action','T',1,1);  -- item_id not in content_item
-- expected: ERROR 1452
ROLLBACK;

START TRANSACTION;
  INSERT INTO dlc (item_id, parent_game_id) VALUES (999998, 1); -- bad item_id
-- expected: ERROR 1452
ROLLBACK;

-- CHECK tests (expect 3819) 
START TRANSACTION;
  INSERT INTO purchase (player_id, item_id, amount) VALUES (1,1,-1.00);
-- expected: ERROR 3819 (amount >= 0)
ROLLBACK;

START TRANSACTION;
  INSERT INTO multiplayer_session (game_id, model_id, host_player_id, started_at, ended_at)
  VALUES (1,1,1,'2025-01-02 10:00:00','2025-01-02 09:59:59');
-- expected: ERROR 3819 (ended_at >= started_at)
ROLLBACK;

-- COMPOSITE PK test (expect duplicate-key error 1062)
START TRANSACTION;
  SELECT session_id, player_id INTO @s, @p FROM session_participant LIMIT 1;
  INSERT INTO session_participant (session_id, player_id, joined_at) VALUES (@s, @p, NOW());
-- expected: ERROR 1062 (duplicate PK (session_id, player_id))
ROLLBACK;

-- ON DELETE CASCADE (should succeed) 
-- Make a temp Content_Item + Game then delete the CI and show the Game vanished
START TRANSACTION;
  INSERT INTO content_item (title, release_date, base_price) VALUES ('Temp CI','2025-02-01',1.00);
  SET @ci := LAST_INSERT_ID();
  INSERT INTO game (item_id, genre, esrb_rating, coop_supported, developer_id)
  VALUES (@ci,'Action','T',1,1);
  DELETE FROM content_item WHERE item_id = @ci;  -- CASCADE to game
  SELECT COUNT(*) AS game_rows_should_be_0 FROM game WHERE item_id = @ci;
ROLLBACK;

-- ON DELETE RESTRICT (should fail with 1451) 
START TRANSACTION;
  -- find an item that appears in a purchase
  SELECT item_id INTO @purchased_item FROM purchase LIMIT 1;
  DELETE FROM content_item WHERE item_id = @purchased_item;
-- expected: ERROR 1451 (cannot delete parent row)
ROLLBACK;