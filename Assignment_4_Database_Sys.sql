-- ============================================
-- Assignment 4
-- CSE3153
-- Destiny Jones
-- ============================================


-- ============================================
-- DELETE OLD DATABASE IF IT EXISTS
-- ============================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'MinecraftModerationAssignment4')
BEGIN
    ALTER DATABASE MinecraftModerationAssignment4
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE MinecraftModerationAssignment4;
END
GO


-- ============================================
-- CREATE DATABASE
-- ============================================

CREATE DATABASE MinecraftModerationAssignment4;
GO

USE MinecraftModerationAssignment4;
GO


-- ============================================
-- CREATE PLAYERS TABLE
-- ============================================

CREATE TABLE players
(
    uuid CHAR(32) PRIMARY KEY,
    username VARCHAR(16) NOT NULL,
    timezone VARCHAR(50) NOT NULL,
    join_date DATE NOT NULL,
    hours_played INT NOT NULL,
    server_role VARCHAR(16) NOT NULL
        CHECK (server_role IN ('player','moderator','administrator'))
);
GO


-- ============================================
-- CREATE PLAYER IPS TABLE
-- ============================================

CREATE TABLE player_ips
(
    ip_id INT PRIMARY KEY,
    uuid CHAR(32) NOT NULL,
    ip_address VARCHAR(45) NOT NULL,

    FOREIGN KEY (uuid)
    REFERENCES players(uuid)
);
GO


-- ============================================
-- CREATE OFFENSE DEFINITIONS TABLE
-- ============================================

CREATE TABLE offense_definitions
(
    offense_id INT PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    offense_type VARCHAR(8) NOT NULL
        CHECK (offense_type IN ('ban','mute','kick','warning')),
    default_duration_hours INT NOT NULL
);
GO


-- ============================================
-- CREATE DISCIPLINARY ACTIONS TABLE
-- ============================================

CREATE TABLE disciplinary_actions
(
    discipline_id INT PRIMARY KEY,
    uuid CHAR(32) NOT NULL,
    offense_id INT NOT NULL,
    custom_duration_hours INT NULL,
    date_assigned DATETIME NOT NULL,
    assigned_by CHAR(32) NOT NULL,

    FOREIGN KEY (uuid)
    REFERENCES players(uuid),

    FOREIGN KEY (offense_id)
    REFERENCES offense_definitions(offense_id),

    FOREIGN KEY (assigned_by)
    REFERENCES players(uuid)
);
GO


-- ============================================
-- CREATE TICKETS TABLE
-- ============================================

CREATE TABLE tickets
(
    ticket_id INT PRIMARY KEY,
    uuid CHAR(32) NOT NULL,
    world VARCHAR(32) NOT NULL
        CHECK (world IN ('overworld','nether','the_end')),
    x DECIMAL(10,2) NOT NULL,
    y DECIMAL(10,2) NOT NULL,
    z DECIMAL(10,2) NOT NULL,
    yaw DECIMAL(10,2) NOT NULL,
    status VARCHAR(16) NOT NULL,
    claimed_by CHAR(32),
    description VARCHAR(255) NOT NULL,
    resulting_action INT,

    FOREIGN KEY (uuid)
    REFERENCES players(uuid),

    FOREIGN KEY (claimed_by)
    REFERENCES players(uuid),

    FOREIGN KEY (resulting_action)
    REFERENCES disciplinary_actions(discipline_id)
);
GO


-- ============================================
-- INSERT PLAYERS
-- ============================================

INSERT INTO players
VALUES
('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA','Steve','EST','2024-01-10',250,'player'),
('BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB','Alex','CST','2023-07-15',600,'moderator'),
('CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC','Herobrine','PST','2022-03-05',1500,'administrator');
GO


-- ============================================
-- INSERT PLAYER IPS
-- ============================================

INSERT INTO player_ips
VALUES
(1,'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA','192.168.1.20'),
(2,'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB','192.168.1.21'),
(3,'CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC','192.168.1.22');
GO


-- ============================================
-- INSERT OFFENSE DEFINITIONS
-- ============================================

INSERT INTO offense_definitions
VALUES
(1,'Griefing another players build','ban',72),
(2,'Using offensive language','mute',24),
(3,'Spamming chat repeatedly','warning',0);
GO


-- ============================================
-- INSERT DISCIPLINARY ACTIONS
-- ============================================

INSERT INTO disciplinary_actions
VALUES
(1,'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',1,NULL,'2026-07-08 14:00:00','CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC'),

(2,'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',2,12,'2026-07-09 09:30:00','BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB'),

(3,'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB',3,NULL,'2026-07-10 16:45:00','CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC');
GO


-- ============================================
-- INSERT TICKETS
-- ============================================

INSERT INTO tickets
VALUES
(
1,
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',
'overworld',
125.50,
64.00,
-210.75,
180.00,
'Open',
'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB',
'Player reported griefing.',
1
),

(
2,
'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB',
'nether',
50.00,
80.00,
30.00,
90.00,
'Closed',
'CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC',
'Suspicious activity investigated.',
3
),

(
3,
'CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC',
'the_end',
0.00,
65.00,
0.00,
270.00,
'Pending',
NULL,
'End portal issue reported.',
NULL
);
GO


-- ============================================
-- VERIFY DATA
-- ============================================

SELECT * FROM players;
GO

SELECT * FROM player_ips;
GO

SELECT * FROM offense_definitions;
GO

SELECT * FROM disciplinary_actions;
GO

SELECT * FROM tickets;
GO