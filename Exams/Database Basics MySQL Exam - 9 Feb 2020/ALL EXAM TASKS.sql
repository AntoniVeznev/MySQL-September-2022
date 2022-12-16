

# 01. Table Design


CREATE TABLE `players`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(10) NOT NULL,
`last_name` VARCHAR(20) NOT NULL,
`age` INT DEFAULT(0) NOT NULL,
`position` CHAR(1) NOT NULL,
`salary` DECIMAL(10, 2) DEFAULT(0) NOT NULL,
`hire_date` DATETIME,
`skills_data_id` INT NOT NULL,
`team_id` INT 
);

CREATE TABLE `players_coaches`(
	`player_id` INT,
    `coach_id` INT
);

CREATE TABLE `coaches`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(10) NOT NULL,
`last_name` VARCHAR(20) NOT NULL,
`salary` DECIMAL(10, 2) NOT NULL DEFAULT(0),
`coach_level` INT DEFAULT(0) NOT NULL
);

CREATE TABLE `skills_data`(
 `id` INT PRIMARY KEY AUTO_INCREMENT,
 `dribbling` INT DEFAULT(0),
 `pace` INT DEFAULT(0),
 `passing` INT DEFAULT(0),
 `shooting` INT DEFAULT(0),
 `speed` INT DEFAULT(0),
 `strength` INT DEFAULT(0)
);

CREATE TABLE `teams`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL,
`established` DATE NOT NULL, 
`fan_base` BIGINT DEFAULT(0) NOT NULL,
`stadium_id` INT NOT NULL
);

CREATE TABLE `stadiums`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL,
`capacity` INT NOT NULL,
`town_id` INT NOT NULL
);

CREATE TABLE `towns`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL,
`country_id` INT NOT NULL
);

CREATE TABLE `countries`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL
);

ALTER TABLE `players`
ADD CONSTRAINT fk1
FOREIGN KEY (skills_data_id)
REFERENCES  skills_data(id);

ALTER TABLE `players`
ADD CONSTRAINT fk2
FOREIGN KEY (team_id)
REFERENCES  teams(id);

ALTER TABLE `players_coaches`
ADD CONSTRAINT fk3
FOREIGN KEY (coach_id)
REFERENCES  coaches(id);

ALTER TABLE `players_coaches`
ADD CONSTRAINT fk4
FOREIGN KEY (player_id)
REFERENCES  players(id);

ALTER TABLE `teams`
ADD CONSTRAINT fk5
FOREIGN KEY (stadium_id)
REFERENCES  stadiums(id);	

ALTER TABLE `stadiums`
ADD CONSTRAINT fk6
FOREIGN KEY (town_id)
REFERENCES  towns(id);

ALTER TABLE `towns`
ADD CONSTRAINT fk7
FOREIGN KEY (country_id)
REFERENCES  countries(id);


# 02. Insert

INSERT INTO `coaches` (first_name, last_name, salary, coach_level) (
SELECT 
p.`first_name`, 
p.`last_name`, 
p.`salary` = `salary` * 2, 
CHAR_LENGTH(p.first_name) AS coach_level
FROM `players` AS p
WHERE p.age >= 45
);


# 03. Update

UPDATE `coaches` AS `c`
JOIN `players_coaches` AS `pc`
ON c.`id` = pc.`coach_id`
SET c.`coach_level` = c.`coach_level` + 1
WHERE LEFT(c.`first_name`, 1) = 'A'
AND pc.`coach_id` > 0 ;


# 04. Delete

DELETE FROM `players` AS p
WHERE p.age >= 45;


# 05. Players 

SELECT
first_name,
age,
salary
FROM players
ORDER BY salary DESC;


# 06. Young offense players without contract

SELECT
p.`id`,
CONCAT(p.`first_name`, ' ', p.`last_name`) AS `full_name`, 
p.`age`,
p.`position`,
p.`hire_date`
FROM `players` AS p
JOIN `skills_data` AS sd
ON p.`skills_data_id` = sd.`id`
WHERE p.`age` < 23 AND p.`position` LIKE 'A' AND p.`hire_date` IS NULL AND sd.`strength` > 50
ORDER BY p.salary ASC, p.age;


# 07. Detail info for all teams

SELECT 
t.`name` AS `team_name`,
t.`established`,
t.`fan_base`,
COUNT(p.`team_id`) AS `count_of_players`
FROM `teams` AS t
LEFT JOIN `players` AS p
ON t.`id` = p.`team_id`
GROUP BY t.`id`
ORDER BY `count_of_players` DESC, `fan_base` DESC;


# 08. The fastest player by towns

SELECT
MAX(sd.`speed`) AS `max_speed`,
tow.`name` AS `town_name`
FROM `players` AS p
RIGHT JOIN `skills_data` AS sd
ON p.`skills_data_id` = sd.`id`
RIGHT JOIN `teams` AS te
ON p.`team_id` = te.`id`
RIGHT JOIN `stadiums` AS s
ON te.`stadium_id` = s.`id`
RIGHT JOIN `towns` AS tow
ON s.`town_id` = tow.`id`
WHERE te.`name` NOT LIKE 'Devify'
GROUP BY town_name
ORDER BY max_speed DESC, town_name;


# 09. Total salaries and players by country

SELECT
c.`name`,
COUNT(p.first_name) AS `total_count_of_players`,
SUM(p.`salary`) AS `total_sum_of_salaries`
FROM `players` AS p
RIGHT JOIN `teams` AS t
ON p.`team_id` = t.`id`
RIGHT JOIN `stadiums` AS s
ON t.`stadium_id` = s.`id`
RIGHT JOIN `towns` AS tow
ON s.`town_id` = tow.`id`
RIGHT JOIN `countries` AS c
ON tow.`country_id` = c.`id`
GROUP BY c.`name`
ORDER BY total_count_of_players DESC, name;


# 10. Find all players that play on stadium

DELIMITER $$
CREATE FUNCTION udf_stadium_players_count (stadium_name VARCHAR(30)) 
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE count_we_return INT;
SET count_we_return := (SELECT COUNT(t.stadium_id) AS count FROM `players` AS p
JOIN `teams` AS t
ON p.`team_id` = t.`id`
JOIN `stadiums` AS s
ON t.`stadium_id` = s.`id`
WHERE s.`name` = stadium_name);
RETURN count_we_return;
END $$


# 11. Find good playmaker by teams

DELIMITER $$
CREATE PROCEDURE udp_find_playmaker(min_dribble_points INT, team_name VARCHAR(45)) 
BEGIN
SELECT 
CONCAT(p.`first_name`, ' ', p.`last_name`) AS `full_name`, 
p.`age`, 
p.`salary`, 
sd.`dribbling`, 
sd.`speed`, 
t.`name` AS `team_name`
FROM teams AS t
JOIN players AS p
ON t.`id` = p.`team_id`
JOIN skills_data AS sd
ON p.`skills_data_id` = sd.`id`
WHERE min_dribble_points < sd.dribbling AND t.name = team_name
ORDER BY speed DESC 
LIMIT 1;
END$$

