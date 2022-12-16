

# 01. Table Design

CREATE TABLE countries (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL UNIQUE,
`continent` VARCHAR(30) NOT NULL,
`currency` VARCHAR(5) NOT NULL
);

CREATE TABLE genres (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE actors (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(50) NOT NULL,
`last_name` VARCHAR(50) NOT NULL,
`birthdate` DATE NOT NULL,
`height` INT,
`awards` INT,
`country_id` INT NOT NULL
);

CREATE TABLE movies_additional_info (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`rating` DECIMAL(10, 2) NOT NULL,
`runtime` INT NOT NULL,
`picture_url` VARCHAR(80) NOT NULL,
`budget` DECIMAL(10, 2),
`release_date` DATE NOT NULL,
`has_subtitles` BOOLEAN,
`description` TEXT
);

CREATE TABLE movies (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`title` VARCHAR(70) NOT NULL UNIQUE,
`country_id` INT NOT NULL,
`movie_info_id` INT NOT NULL UNIQUE
);

CREATE TABLE movies_actors (
`movie_id` INT,
`actor_id` INT
);

CREATE TABLE genres_movies (
`genre_id` INT,
`movie_id` INT
);

ALTER TABLE `actors`
ADD CONSTRAINT fk1
FOREIGN KEY (country_id)
REFERENCES countries(id);

ALTER TABLE `movies`
ADD CONSTRAINT fk2
FOREIGN KEY (country_id)
REFERENCES countries(id),
ADD CONSTRAINT fk3
FOREIGN KEY (movie_info_id)
REFERENCES movies_additional_info(id);

ALTER TABLE `movies_actors`
ADD CONSTRAINT fk4
FOREIGN KEY (movie_id)
REFERENCES movies(id),
ADD CONSTRAINT fk5
FOREIGN KEY (actor_id)
REFERENCES actors(id);

ALTER TABLE `genres_movies`
ADD CONSTRAINT fk6
FOREIGN KEY (genre_id)
REFERENCES genres(id),
ADD CONSTRAINT fk7
FOREIGN KEY (movie_id)
REFERENCES movies(id);


# 02. Insert

INSERT `actors` (`first_name`, `last_name`, `birthdate`, `height`, `awards`, `country_id`)
SELECT 
REVERSE(a.`first_name`) AS `first_name`, 
REVERSE(a.`last_name`) AS `last_name`, 
a.`birthdate` - 2 AS `birthdate`, 
a.`height` + 10 AS `height`, 
a.`country_id` AS `awards`,
3 AS `country_id`
FROM actors AS a
WHERE a.`id` <= 10;


# 03. Update

UPDATE `movies_additional_info` SET `runtime` =  `runtime` - 10
WHERE movies_additional_info.`id` >= 15 AND movies_additional_info.`id` <= 25;


# 04. Delete

DELETE c FROM `countries` AS c
LEFT JOIN `movies` AS m
ON c.`id` = m.`country_id`
WHERE m.country_id IS NULL;


# 05. Countries

SELECT * FROM `countries`
ORDER BY currency DESC, id;


# 06. Old movies

SELECT 
m.`id`,
m.`title`,
mai.`runtime`,
mai.`budget`,
mai.`release_date`
FROM `movies` AS m
JOIN `movies_additional_info` AS mai
ON m.`movie_info_id` = mai.`id`
WHERE YEAR(mai.`release_date`)  >= 1996 AND YEAR(mai.`release_date`)  <= 1999
ORDER BY `runtime`, `id`
LIMIT 20;


# 07. Movie casting

SELECT 
CONCAT(a.first_name, ' ', a.last_name) AS `full_name`, 	
CONCAT(REVERSE(a.last_name), CHAR_LENGTH(a.last_name), '@cast.com') AS `email`,
2022 - YEAR(a.birthdate) AS `age`, 
a.`height`
FROM `actors` AS a
LEFT join `movies_actors` AS ma
ON a.`id` = ma.`actor_id`
LEFT JOIN `movies` AS m
ON ma.`movie_id` = m.`id`
WHERE ma.movie_id IS NULL
ORDER BY `height`;


# 08. International festival

SELECT 
c.`name`,
COUNT(m.`country_id`) AS `movies_count`
FROM countries AS c
JOIN movies AS m
ON c.`id` = m.`country_id`
GROUP BY country_id
HAVING movies_count >= 7
ORDER BY  c.`name` DESC;


# 09. Rating system

SELECT
m.`title`,
CASE WHEN mai.`rating` <= 4 THEN 'poor'
WHEN mai.`rating` <= 7 THEN 'good'
WHEN mai.`rating` > 7 THEN 'excellent'
END AS `rating`,
CASE WHEN mai.`has_subtitles` = 1 THEN 'english'
WHEN mai.`has_subtitles` = 0 THEN '-'
END AS `subtitles`,
mai.`budget`
FROM movies AS m
JOIN movies_additional_info AS mai
ON m.movie_info_id = mai.id
ORDER BY budget DESC;


# 10. History movies

DELIMITER $$
CREATE FUNCTION udf_actor_history_movies_count(full_name VARCHAR(50))
RETURNS INT 
DETERMINISTIC
BEGIN

RETURN (select count(*) FROM actors AS a
JOIN movies_actors AS ma
ON a.`id` = ma.`actor_id`
JOIN movies AS m
ON ma.`movie_id` = m.`id`
JOIN genres_movies AS gm
ON m.`id` = gm.`movie_id`
JOIN genres AS g
ON gm.`genre_id` = g.`id`
WHERE g.name = 'History' AND CONCAT(a.first_name, ' ', a.last_name) = full_name);

END $$


# 11. Movie awards

DELIMITER $$
CREATE PROCEDURE udp_award_movie(movie_title VARCHAR(50))
BEGIN
UPDATE `actors` as a 
JOIN movies_actors as ma
on ma.actor_id = a.id
join movies as m
ON m.id = ma.movie_id
SET `awards` = `awards` + 1 
WHERE m.title = movie_title;
END$$

