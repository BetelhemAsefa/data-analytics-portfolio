CREATE ROLE 'role_DBA';
CREATE ROLE 'role_Analyst';

-- DBA role: has full control over game_platform database
GRANT ALL PRIVILEGES ON game_platform.* TO 'role_DBA';

-- Analyst: can only read and run procedures/functions
GRANT SELECT ON game_platform.* TO 'role_Analyst';
GRANT EXECUTE ON game_platform.* TO 'role_Analyst';


-- Create test users to test privileges
CREATE USER 'user_DBA'@'localhost' IDENTIFIED BY 'PasswordDBA!';
CREATE USER 'user_Analyst'@'localhost' IDENTIFIED BY 'PasswordAnalyst!';

-- 4) Grant roles to those users
GRANT 'role_DBA' TO 'user_DBA'@'localhost';
GRANT 'role_Analyst' TO 'user_Analyst'@'localhost';

-- 5) Make the roles active by default
SET DEFAULT ROLE 'role_DBA' TO 'user_DBA'@'localhost';
SET DEFAULT ROLE 'role_Analyst' TO 'user_Analyst'@'localhost';


