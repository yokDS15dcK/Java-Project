CREATE DATABASE IF NOT EXISTS authzen_db;
USE authzen_db;

CREATE TABLE User (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    enabled BOOLEAN NOT NULL,
    account_non_expired BOOLEAN NOT NULL,
    account_non_locked BOOLEAN NOT NULL,
    credentials_non_expired BOOLEAN NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE Permission (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE UserRole (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(id),
    FOREIGN KEY (role_id) REFERENCES Role(id)
);

CREATE TABLE RolePermission (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    role_id BIGINT NOT NULL,
    permission_id BIGINT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES Role(id),
    FOREIGN KEY (permission_id) REFERENCES Permission(id)
);

CREATE TABLE RefreshToken (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    token VARCHAR(255) NOT NULL,
    expiry_date TIMESTAMP NOT NULL,
    user_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(id)
);

CREATE TABLE EmailToken (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    token VARCHAR(255) NOT NULL,
    expiry_date TIMESTAMP NOT NULL,
    user_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(id)
);

CREATE TABLE OauthProvider (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    provider VARCHAR(255) NOT NULL,
    provider_user_id VARCHAR(255) NOT NULL,
    user_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(id)
);

CREATE TABLE AuditLog (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    action VARCHAR(255) NOT NULL,
    performed_by BIGINT,
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details TEXT,
    FOREIGN KEY (performed_by) REFERENCES User(id)
);

INSERT INTO User (username, email, password, enabled, account_non_expired, account_non_locked, credentials_non_expired)
VALUES
('admin', 'admin@example.com', 'adminpass', TRUE, TRUE, TRUE, TRUE),
('user1', 'user1@example.com', 'user1pass', TRUE, TRUE, TRUE, TRUE),
('user2', 'user2@example.com', 'user2pass', TRUE, TRUE, TRUE, TRUE);

INSERT INTO Role (name, description) VALUES
('ADMIN', 'Administrator role'),
('USER', 'Standard user role');

INSERT INTO Permission (name, description) VALUES
('READ_PRIVILEGES', 'Can read data'),
('WRITE_PRIVILEGES', 'Can write data'),
('DELETE_PRIVILEGES', 'Can delete data');

INSERT INTO UserRole (user_id, role_id) VALUES
(1, 1),
(2, 2),
(3, 2);

INSERT INTO RolePermission (role_id, permission_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1);

INSERT INTO RefreshToken (token, expiry_date, user_id) VALUES
('refresh_token_1', '2030-01-01 00:00:00', 1),
('refresh_token_2', '2030-01-01 00:00:00', 2);

INSERT INTO EmailToken (token, expiry_date, user_id) VALUES
('email_token_1', '2030-01-01 00:00:00', 1),
('email_token_2', '2030-01-01 00:00:00', 2);

INSERT INTO OauthProvider (provider, provider_user_id, user_id) VALUES
('google', 'google-uid-1', 1),
('github', 'github-uid-2', 2);

INSERT INTO AuditLog (action, performed_by, details) VALUES
('LOGIN', 1, 'Admin logged in'),
('LOGIN', 2, 'User1 logged in'),
('UPDATE_PROFILE', 2, 'User1 updated profile');