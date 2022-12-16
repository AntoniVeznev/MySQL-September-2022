

# 01. Create Tables

CREATE TABLE `minions` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(255),
    `age` INT
);

CREATE TABLE `towns` (
    `town_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(255)
);


# 02. Alter Minions Table

ALTER TABLE `minions`
ADD COLUMN (
`town_id` INT 
);

ALTER TABLE `minions`
ADD CONSTRAINT `fk_minions_towns`
FOREIGN KEY `minions`(`town_id`)
REFERENCES `towns`(`id`);


# 03. Insert Records in Both Tables

INSERT INTO `towns` (`id`, `name`) VALUES
(1,"Sofia"),
(2,"Plovdiv"),
(3, "Varna");

INSERT INTO `minions` (`id`, `name`, `age`, `town_id`) VALUES
(1, "Kevin", 22, 1),
(2, "Bob", 15, 3),
(3, "Steward", NULL, 2);


# 04. Truncate Table Minions 

TRUNCATE `minions`;


# 05. Drop All Tables

DROP TABLE `minions`;
DROP TABLE `towns`;


# 06. Create Table People

CREATE TABLE `people` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(200) NOT NULL,
    `picture` BLOB,
    `height` DECIMAL(10 , 2 ),
    `weight` DECIMAL(10 , 2 ),
    `gender` CHAR(1) NOT NULL,
    `birthdate` DATE NOT NULL,
    `biography` TEXT
);

INSERT INTO `people` (`id`, `name`,`picture`,`height`,`weight`,`gender`,`birthdate`,`biography`) VALUES
(1, 'Antoni', NUll, 10.10, 10.10, 'm', DATE(NOW()), NULL ),
(2, 'Svilen', NUll, 10.11, 10.11, 'm', DATE(NOW()), NULL ),
(3, 'Krasimira', NUll, 10.12, 10.12, 'f', DATE(NOW()), NULL ),
(4, 'Atanas', NUll, 10.13, 10.13, 'm', DATE(NOW()), NULL ),
(5, 'Donka', NUll, 10.14, 10.14, 'f', DATE(NOW()), NULL );


# 07. Create Table Users

CREATE TABLE `users` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(30) NOT NULL,
    `password` VARCHAR(26) NOT NULL,
    `profile_picture` BLOB,
    `last_login_time` TIME,
    `is_deleted` BOOLEAN
);

INSERT INTO `users` (`id`, `username`,`password`,`profile_picture`,`last_login_time`,`is_deleted`) VALUES
(1, 'Antoni', 111, NULL, TIME(NOW()), FALSE),
(2, 'Svilen', 222, NULL, TIME(NOW()), FALSE),
(3, 'Krasimira', 333, NULL, TIME(NOW()), FALSE),
(4, 'Atanas', 444, NULL, TIME(NOW()), FALSE),
(5, 'Donka', 555, NULL, TIME(NOW()), FALSE);


# 08. Change Primary Key

ALTER TABLE `users` 
DROP PRIMARY KEY,
ADD PRIMARY KEY `pk_users` (`id`, `username`);


# 09. Set Default Value of a Field

ALTER TABLE `users`
MODIFY COLUMN `last_login_time` DATETIME  DEFAULT NOW();


# 10. Set Unique Field

ALTER TABLE `users`
DROP PRIMARY KEY,
ADD PRIMARY KEY (`id`);

ALTER TABLE `users`
ADD CONSTRAINT `pk_users`
UNIQUE (`username`);


# 11. Movies Database

CREATE TABLE `directors` (
    `id` INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    `director_name` VARCHAR(255) NOT NULL,
    `notes` TEXT
);

CREATE TABLE `genres` (
    `id` INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    `genre_name` VARCHAR(255) NOT NULL,
    `notes` TEXT
);

CREATE TABLE `categories` (
    `id` INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    `category_name` VARCHAR(255) NOT NULL,
    `notes` TEXT
);

CREATE TABLE `movies` (
    `id` INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    `title` VARCHAR(255) NOT NULL,
    `director_id` INT,
    `copyright_year` DATE,
    `length` TIME,
    `genre_id` INT,
    `category_id` INT,
    `rating` DECIMAL,
    `notes` TEXT
);

INSERT INTO `directors` (`director_name`) VALUES 
("Anotni"),
("Svilen"),
("Krasimira"),
("Donka"),
("Atanas");

INSERT INTO `genres` (`genre_name`) VALUES 
("Action"),
("Thriller"),
("Comedy"),
("Drama"),
("Romantic");

INSERT INTO `categories` (`category_name`) VALUES 
("Top rated"),
("Top 50"),
("Top downloaded"),
("Top 100"),
("Top 250");

INSERT INTO `movies` (`title`) VALUES 
("Some stuff 0"),
("Some stuff 1"),
("Some stuff 2"),
("Some stuff 3"),
("Some stuff 4");


# 12. Car Rental Database

CREATE TABLE `categories` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `category` TEXT,
    `daily_rate` DECIMAL,
    `weekly_rate` DECIMAL,
    `monthly_rate` DECIMAL,
    `weekend_rate` DECIMAL
);

INSERT INTO `categories` (`id`) VALUES
(1),
(2),
(3);


CREATE TABLE `cars` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `plate_number` INT,
    `make` DECIMAL,
    `model` DECIMAL,
    `car_year` DATE,
    `category_id` INT,
    `doors` INT,
    `picture` BLOB,
    `car_condition` TEXT,
    `available` BOOLEAN
);

INSERT INTO `cars` (`id`) VALUES
(1),
(2),
(3);



CREATE TABLE `employees` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(50),
    `last_name` VARCHAR(50),
    `title` TEXT,
    `notes` TEXT
);

INSERT INTO `employees` (`id`) VALUES
(1),
(2),
(3);



CREATE TABLE `customers` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `driver_licence_number` TEXT,
    `full_name` VARCHAR(50),
    `address` TEXT,
    `city` VARCHAR(255),
    `zip_code` INT,
    `notes` TEXT
);

INSERT INTO `customers` (`id`) VALUES
(1),
(2),
(3);

CREATE TABLE `rental_orders` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `employee_id` INT,
    `customer_id` INT,
    `car_id` INT,
    `car_condition` TEXT,
    `tank_level` DECIMAL,
    `kilometrage_start` DECIMAL,
    `kilometrage_end` DECIMAL,
    `total_kilometrage` DECIMAL,
    `start_date` DATE,
    `end_date` DATE,
    `total_days` INT,
    `rate_applied` DECIMAL,
    `tax_rate` DECIMAL,
    `order_status` BOOLEAN,
    `notes` TEXT
);

INSERT INTO `rental_orders` (`id`) VALUES
(1),
(2),
(3);


# 13. Basic Insert

INSERT INTO `towns` (`name`) VALUES
("Sofia"),
("Plovdiv"),
("Varna"),
("Burgas");

INSERT INTO `departments` (`name`) VALUES
("Engineering"),
("Sales"),
("Marketing"),
("Software Development"),
("Quality Assurance");

INSERT INTO `employees` (`first_name`, `middle_name`, `last_name`, `job_title`, `department_id`, `hire_date`, `salary`) VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);


# 14. Basic Select All Fields

SELECT * FROM `towns`;
SELECT * FROM `departments`;
SELECT * FROM `employees`;

# 15. Basic Select All Fields and Order 

SELECT * FROM `towns` ORDER BY `name`;	
SELECT * FROM `departments` ORDER BY `name`;
SELECT * FROM `employees` ORDER BY `salary` DESC;


# 16. Basic Select Some Fields

SELECT `name` FROM `towns`ORDER BY `name`;		
SELECT `name` FROM `departments` ORDER BY `name`;
SELECT `first_name`, `last_name`, `job_title`, `salary` FROM `employees` ORDER BY `salary` DESC;


# 17. Increase Employees Salary

UPDATE `employees`
SET `salary` = `salary` * 1.10;
SELECT `salary` FROM `employees`;

