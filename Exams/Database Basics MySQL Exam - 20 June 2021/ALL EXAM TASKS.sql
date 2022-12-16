

# 01. Table Design

CREATE TABLE `addresses`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(100) NOT NULL
); 
CREATE TABLE `categories`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(10) NOT NULL
); 
CREATE TABLE `clients`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`full_name` VARCHAR(50) NOT NULL,
`phone_number` VARCHAR(20) NOT NULL
); 
CREATE TABLE `drivers`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(30) NOT NULL,
`last_name` VARCHAR(30) NOT NULL,
`age` INT NOT NULL,
`rating` FLOAT DEFAULT(5.5)
); 
CREATE TABLE `cars`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`make` VARCHAR(20) NOT NULL,
`model` VARCHAR(20),
`year` INT NOT NULL DEFAULT(0),
`mileage` INT DEFAULT(0),
`condition` CHAR(1) NOT NULL,
`category_id` INT NOT NULL
); 
CREATE TABLE `courses`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`from_address_id` INT NOT NULL,
`start` DATETIME NOT NULL,
`bill` DECIMAL(10, 2) DEFAULT(10),
`car_id` INT NOT NULL,
`client_id` INT NOT NULL
); 
CREATE TABLE `cars_drivers`(
`car_id` INT NOT NULL,
`driver_id` INT NOT NULL,
PRIMARY KEY (`car_id`, `driver_id`)
); 

ALTER TABLE `cars`
ADD CONSTRAINT fk1
FOREIGN KEY (category_id)
REFERENCES categories(id);

ALTER TABLE `courses`
ADD CONSTRAINT fk2
FOREIGN KEY (from_address_id)
REFERENCES addresses(id);

ALTER TABLE `courses`
ADD CONSTRAINT fk3
FOREIGN KEY (car_id)
REFERENCES cars(id);

ALTER TABLE `courses`
ADD CONSTRAINT fk4
FOREIGN KEY (client_id)
REFERENCES clients(id);

ALTER TABLE `cars_drivers`
ADD CONSTRAINT fk5
FOREIGN KEY (car_id)
REFERENCES cars(id);

ALTER TABLE `cars_drivers`
ADD CONSTRAINT fk6
FOREIGN KEY (driver_id)
REFERENCES drivers(id);


# 02. Insert

INSERT INTO `clients` (`full_name`,`phone_number`)
(
SELECT
concat(d.first_name, ' ', last_name) AS full_name,
concat('(088) 9999', '', d.id * 2) AS phone_number
FROM `drivers` AS d
WHERE d.id BETWEEN 10 AND 20
);


# 03. Update

UPDATE cars AS c	
SET c.condition = 'C'
WHERE (c.mileage >= 800000 OR c.mileage IS NULL) AND c.year <= 2010;


# 04. Delete

DELETE c FROM clients AS c
LEFT JOIN courses AS cou
ON c.id = cou.client_id
WHERE cou.client_id IS NULL AND char_length(c.full_name) > 3;


# 05. Cars

SELECT `make`, `model`, `condition` FROM cars
ORDER BY id;


# 06. Drivers and Cars

SELECT 
d.`first_name`,
d.`last_name`,
c.`make`,
c.`model`,
c.`mileage`
FROM drivers AS d
JOIN cars_drivers AS cd
ON d.id = cd.driver_id
JOIN cars AS c
ON cd.car_id = c.id
WHERE c.mileage IS NOT NULL
ORDER BY mileage DESC, first_name;


# 07. Number of courses 

SELECT 
c.id AS `car_id`,
c.`make`,
c.`mileage`,
COUNT(cur.car_id)  AS `count_of_courses`,
ROUND(AVG(cur.bill), 2) AS `avg_bill`
FROM cars AS c
LEFT JOIN courses AS cur
ON c.id = cur.car_id
GROUP BY c.id
HAVING count_of_courses != 2 
ORDER BY count_of_courses DESC , car_id ASC;


# 08. Regular clients

SELECT 
cli.full_name AS full_name,
count(cur.car_id) AS  count_of_cars,
sum(cur.bill) AS  total_sum
FROM clients AS cli
JOIN courses AS cur
ON cli.id = cur.client_id
JOIN cars AS car
ON cur.car_id = car.id
GROUP BY cli.id
HAVING LEFT(SUBSTRING(cli.full_name, 2) ,1) ='a' AND count_of_cars > 1
ORDER BY full_name;


# 09. Full info for courses

SELECT
addr.`name` AS `name`, 
CASE 
WHEN HOUR(cur.start) >= 6 AND HOUR(cur.start) <= 20 THEN 'Day'
ELSE 'Night'
END AS `day_time`,
cur.`bill`  AS `bill`,
cli.`full_name`  AS `full_name`, 
car.`make` AS `make`,
car.`model`AS `model`,
cat.`name` AS `category_name` 
FROM courses AS `cur`
JOIN cars AS `car`
ON cur.`car_id` = car.`id`
JOIN categories AS `cat`
ON car.`category_id` = cat.`id`
JOIN clients AS `cli`
ON cur.`client_id` = cli.`id`
JOIN addresses AS `addr`
ON cur.`from_address_id` = addr.`id`
ORDER BY cur.`id`;


# 10. Find all courses by client’s phone number

DELIMITER $$
CREATE FUNCTION udf_courses_by_client (phone_num VARCHAR (20))
RETURNS INT
DETERMINISTIC
BEGIN

RETURN (SELECT count(cur.id) FROM clients AS cli
JOIN courses AS cur
ON cli.`id` = cur.`client_id`
WHERE cli.phone_number = phone_num);
END$$


# 11. Full info for address

DELIMITER $$
CREATE PROCEDURE udp_courses_by_address(address_name VARCHAR(100))
BEGIN
SELECT
addr.`name` AS `name`,
cli.`full_name` AS `full_name`,
CASE 
WHEN cur.bill <= 20 THEN 'Low'
WHEN cur.bill <= 30 THEN 'Medium'
ELSE 'High'
END AS `level_of_bill`,
car.`make` AS `make`,
car.`condition` AS `condition`,
cat.`name` AS `cat_name` 
FROM addresses AS addr
JOIN courses AS cur
ON addr.id = cur.from_address_id
JOIN clients AS cli
ON cli.id = cur.client_id
JOIN cars AS car
ON car.id = cur.car_id
JOIN categories AS cat
ON cat.id = car.category_id
WHERE addr.`name` = address_name
ORDER BY make, full_name;
END $$

