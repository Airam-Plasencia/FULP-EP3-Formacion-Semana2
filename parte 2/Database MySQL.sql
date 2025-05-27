DROP DATABASE IF EXISTS twitter_db;

CREATE DATABASE twitter_db;

USE twitter_db;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
user_id INT AUTO_INCREMENT,
user_handle VARCHAR(50) NOT NULL UNIQUE,
email_address VARCHAR(50) NOT NULL UNIQUE,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
phonenumber CHAR(10) UNIQUE,
created_at TIMESTAMP NOT NULL DEFAULT(NOW()),
PRIMARY KEY (user_id)
);

INSERT INTO users(user_handle, email_address, first_name, last_name, phonenumber)
VALUES
('midudev', 'midudev@gmail.com', 'Miguel', 'Hernandez' , '699854751'),
('marta', 'marta@gmail.com', 'Marta', 'Garcia' , '656468596'),
('paco', 'pepe@gmail.com', 'Paco', 'Pla' , '697554751'),
('pepe', 'pe@gmail.com', 'Pep', 'Pe' , '357554751');


CREATE TABLE followers(
follower_id INT NOT NULL,
following_id INT NOT NULL,
FOREIGN KEY(follower_id) REFERENCES users(user_id),
FOREIGN KEY(following_id) REFERENCES users(user_id),
PRIMARY KEY(follower_id, following_id)
);
ALTER TABLE followers
ADD CONSTRAINT check_follower_id
CHECK (follower_id <> following_id);

INSERT INTO followers(follower_id, following_id)
VALUES
(1, 2),
(2 , 3),
(3, 1),
(3 , 2),
(3 , 4),
(4 , 2),
(4 , 1);

SELECT follower_id, following_id FROM followers;
SELECT follower_id FROM followers WHERE following_id = 1;
SELECT COUNT(follower_id) AS followers FROM followers WHERE following_id = 1;

-- TOP 2 usuarios con mayor número de seguidores

SELECT following_id, COUNT(follower_id) AS followers
FROM followers
GROUP BY following_id
ORDER BY followers DESC
LIMIT 2;

-- TOP 2 pero con JOIN
SELECT users.user_id, users.user_handle, users.first_name, following_id, COUNT(follower_id) AS followers
FROM followers
JOIN users ON users.user_id = followers.following_id
GROUP BY following_id
ORDER BY followers DESC
LIMIT 2;

CREATE TABLE tweets(
tweet_id INT NOT NULL AUTO_INCREMENT,
user_id INT NOT NULL,
tweet_text VARCHAR(280) NOT NULL,
num_likes INT DEFAULT 0,
num_retweets INT DEFAULT 0,
num_comments INT DEFAULT 0,
created_at TIMESTAMP NOT NULL DEFAULT (NOW()),
FOREIGN KEY (user_id) REFERENCES users(user_id),
PRIMARY KEY (tweet_id)
);

INSERT INTO tweets(user_id, tweet_text)
VALUES
(1, 'Hola Mundo'),
(2, 'Entrando a Twitter');

-- ¿Cuantos tweets ha hecho un usuario?
SELECT user_id, COUNT(*) AS tweet_count
FROM tweets
GROUP BY user_id;

-- Obtener los tweets de los usuarios con más de 1 seguidor.
SELECT tweet_id, tweet_text, user_id
FROM tweets
WHERE user_id IN (
SELECT following_id
FROM followers
GROUP BY following_id
HAVING COUNT (*) > 2
);

-- UPDATE
UPDATE tweets SET num_comments = num_comments + 1 WHERE tweet_id = 1;

CREATE TABLE tweet_likes (
user_id INT NOT NULL,
tweet_id INT NOT NULL,
FOREIGN KEY (user_id) REFERENCES users(user_id),
FOREIGN KEY (tweet_id) REFERENCES tweets(tweet_id),
PRIMARY KEY (user_id, tweet_id)
);

INSERT INTO tweets_likes (user_id, tweet_id)
VALUES (1 , 2);

-- TRIGGERS
DELIMITER $$
CREATE TRIGGER increase_follower_count
AFTER INSERT ON followers
FOR EACH ROW
BEGIN
UPDATE users SET follower_count = follower_count + 1
WHERE user_id = NEW.following_id;
END $$

DELIMITER ;

INSERT INTO followers(follower_id, following_id)
VALUES
(1 , 2),





