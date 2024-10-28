-- Drop the 'users' table if it exists
DROP TABLE IF EXISTS users;

-- Create a table named 'users'
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert 10 rows of realistic dummy data into the 'users' table
INSERT INTO users (username, email) VALUES
('RoxMai', 'rox.mai@bbju.com'),
('JaneSmith', 'jane.smith@example.com'),
('MikeBrown', 'mike.brown@example.com'),
('EmilyDavis', 'emily.davis@example.com'),
('ChrisWilson', 'chris.wilson@example.com'),
('AnnaTaylor', 'anna.taylor@example.com'),
('JamesWhite', 'james.white@example.com'),
('SarahClark', 'sarah.clark@example.com'),
('DavidLewis', 'david.lewis@example.com'),
('LauraHall', 'laura.hall@example.com');
