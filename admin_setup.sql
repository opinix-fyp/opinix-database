-- Create database
CREATE DATABASE IF NOT EXISTS opinix_db
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_0900_ai_ci;

-- Create dedicated application user
CREATE USER IF NOT EXISTS 'opinix_user'@'localhost'
IDENTIFIED BY 'MyStrongPass123!';

-- Grant privileges only to this database
GRANT ALL PRIVILEGES ON opinix_db.* TO 'opinix_user'@'localhost';

FLUSH PRIVILEGES;