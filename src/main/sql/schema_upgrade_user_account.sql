-- =========================================================
-- User account table for authentication and role management
-- =========================================================
-- This script adds a user_account table to support:
-- 1. User registration
-- 2. User login
-- 3. User role distinction
--    - general: general / non-professional user
--    - professional: professional user
-- =========================================================
USE biomed;

CREATE TABLE IF NOT EXISTS user_account (
                                            id INT PRIMARY KEY AUTO_INCREMENT,

                                            username VARCHAR(100) NOT NULL UNIQUE,

    password VARCHAR(255) NOT NULL,

    role VARCHAR(50) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

-- Optional test accounts.
-- You can delete these INSERT statements if you do not want default users.
-- Passwords are stored as plain text for the first functional version.
-- Later, this can be upgraded to encrypted password storage.

INSERT INTO user_account (username, password, role)
VALUES
    ('general_test', '123456', 'general'),
    ('professional_test', '123456', 'professional');