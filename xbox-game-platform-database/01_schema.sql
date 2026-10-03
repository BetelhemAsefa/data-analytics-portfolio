-- Xbox Game Platform Database Schema
CREATE DATABASE IF NOT EXISTS game_platform;
USE game_platform;

-- Developer
CREATE TABLE Developer (
    developer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL UNIQUE
);

-- Content_Item (supertype)
CREATE TABLE Content_Item (
    item_id int AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_date DATE,
    base_price DECIMAL(8,2)
);

-- Game (subtype of Content_Item)
CREATE TABLE Game (
    item_id INT PRIMARY KEY,
    genre VARCHAR(80),
    esrb_rating VARCHAR(10),
    coop_supported INT,
    developer_id INT,
    FOREIGN KEY (item_id) REFERENCES Content_Item(item_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (developer_id) REFERENCES Developer(developer_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- DLC (subtype of Content_Item)
CREATE TABLE DLC (
    item_id INT PRIMARY KEY,
    parent_game_id INT,
    FOREIGN KEY (item_id) REFERENCES Content_Item(item_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (parent_game_id) REFERENCES Game(item_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Player
CREATE TABLE Player (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    gamertag VARCHAR(40) NOT NULL UNIQUE,
    region VARCHAR(40),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Console_Model
CREATE TABLE Console_Model (
    model_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    release_year INT
);

-- Player_Subscription (M:N relationship)
CREATE TABLE Player_Subscription (
    player_id INT,
    plan_id INT,
    start_date DATE,
    status ENUM('active','paused','expired') DEFAULT 'active',
    PRIMARY KEY (player_id, plan_id, start_date),
    FOREIGN KEY (player_id) REFERENCES Player(player_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES Subscription_Plan(plan_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Purchase
CREATE TABLE Purchase (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT,
    item_id INT,
    amount DECIMAL(8,2),
    purchased_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (player_id) REFERENCES Player(player_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (item_id) REFERENCES Content_Item(item_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Multiplayer_Session
CREATE TABLE Multiplayer_Session (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    game_id INT,
    model_id INT,
    host_player_id INT,
    started_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    ended_at DATETIME,
    FOREIGN KEY (game_id) REFERENCES Game(item_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (model_id) REFERENCES Console_Model(model_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (host_player_id) REFERENCES Player(player_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Session_Participant (M:N relationship)
CREATE TABLE Session_Participant (
    session_id INT,
    player_id INT,
    joined_at DATETIME,
    left_at DATETIME,
    PRIMARY KEY (session_id, player_id),
    FOREIGN KEY (session_id) REFERENCES Multiplayer_Session(session_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (player_id) REFERENCES Player(player_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
