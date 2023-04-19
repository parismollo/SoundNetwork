-- Insert a new user
INSERT INTO users (name) VALUES ('Rick');

-- Insert a new event associated with the user
INSERT INTO events (user_id) SELECT user_id FROM users WHERE name = 'Rick';
