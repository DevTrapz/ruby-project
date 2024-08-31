-- CREATE USER rails WITH PASSWORD 'strong_password';
-- CREATE DATABASE userdata;
-- GRANT ALL PRIVILEGES ON DATABASE userdata TO rails;

-- \c userdata rails;
-- CREATE SCHEMA app;




-- CREATE TABLE permission (
--   id SERIAL NOT NULL PRIMARY KEY,
--   type VARCHAR(15)
-- );

-- CREATE TABLE users (
--   id SERIAL NOT NULL PRIMARY KEY,
--   displayName VARCHAR(25),
--   permission_id VARCHAR(25) REFERENCES permission(id)
-- );

-- CREATE TABLE podcasts (
--   id SERIAL NOT NULL PRIMARY KEY,
--   title VARCHAR(25),
--   url VARCHAR(150)
-- );

-- CREATE TABLE subscriptions (
--   id SERIAL NOT NULL PRIMARY KEY,
--   user_id INTEGER REFERENCES users(id),
--   podcast_id INTEGER REFERENCES podcasts(id)
-- );

-- CREATE TABLE orders (
--   id SERIAL NOT NULL PRIMARY KEY,
--   user_podcasts INTEGER REFERENCES subscriptions(id)
-- );
