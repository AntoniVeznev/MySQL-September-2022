

# 01. Table Design


CREATE TABLE `pictures` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`url` VARCHAR(100) NOT NULL,
`added_on` DATETIME NOT NULL
);
CREATE TABLE `categories` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL UNIQUE
);
CREATE TABLE `products` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL UNIQUE,
`best_before` DATE,
`price` DECIMAL(10,2),
`description` TEXT,
`category_id` INT NOT NULL,
`picture_id` INT NOT NULL
);
CREATE TABLE `towns` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(20) NOT NULL UNIQUE
);
CREATE TABLE `addresses` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL UNIQUE,
`town_id` INT NOT NULL
);
CREATE TABLE `stores` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(20) NOT NULL UNIQUE,
`rating` FLOAT NOT NULL,
`has_parking` TINYINT(1) DEFAULT (false),
`address_id` INT NOT NULL
);
CREATE TABLE `products_stores` (
`product_id` INT NOT NULL,
`store_id` INT NOT NULL,
PRIMARY KEY (`product_id`, `store_id`)
);
CREATE TABLE `employees` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(15) NOT NULL,
`middle_name` CHAR(1),
`last_name` VARCHAR(20) NOT NULL,
`salary` DECIMAL(19, 2) DEFAULT (0),
`hire_date` DATE NOT NULL,
`manager_id` INT,
`store_id` INT NOT NULL
);

ALTER TABLE `products_stores`
ADD CONSTRAINT fk1
FOREIGN KEY (product_id)
REFERENCES products(id),
ADD CONSTRAINT fk2
FOREIGN KEY (store_id)
REFERENCES stores(id);

ALTER TABLE `products`
ADD CONSTRAINT fk3
FOREIGN KEY (category_id)
REFERENCES categories(id),
ADD CONSTRAINT fk4
FOREIGN KEY (picture_id)
REFERENCES pictures(id);

ALTER TABLE `addresses`
ADD CONSTRAINT fk5
FOREIGN KEY (town_id)
REFERENCES towns(id);

ALTER TABLE `stores`
ADD CONSTRAINT fk6
FOREIGN KEY (address_id)
REFERENCES addresses(id);

ALTER TABLE `employees`
ADD CONSTRAINT fk7
FOREIGN KEY (store_id)
REFERENCES stores(id),
ADD CONSTRAINT fk8
FOREIGN KEY (manager_id)
REFERENCES employees(id);


# 02. Insert

INSERT INTO `products_stores` (`product_id`, `store_id`)
(SELECT
p.id AS product_id,
1 AS store_id
FROM products AS p
LEFT JOIN products_stores AS ps
ON p.`id` = ps.`product_id`
WHERE ps.product_id IS NULL
);


# 03. Update

UPDATE employees AS e
JOIN stores AS s
ON e.`store_id` = s.`id`
SET e.manager_id = 3, e.salary = e.salary- 500
WHERE YEAR(e.hire_date) > 2003 AND e.store_id != 5 AND e.store_id != 14;


# 04. Delete

DELETE e FROM `employees` AS e
WHERE e.salary >= 6000 AND e.manager_id IS NOT NULL;


# 05. Employees 

SELECT 
`first_name`,
`middle_name`,
`last_name`,
`salary`,
`hire_date`
FROM employees AS e 
ORDER BY e.hire_date DESC;


# 06. Products with old pictures

SELECT 
p.`name`,
p.`price`,
p.`best_before`,
CONCAT(SUBSTRING(p.`description`, 1, 10 ), '' , '...') AS short_description ,
pic.url 
FROM products AS p
JOIN pictures AS pic
ON p.picture_id = pic.id
WHERE CHAR_LENGTH(p.`description`) > 100 AND YEAR(pic.added_on) < 2019 AND p.price >20
ORDER BY p.price DESC;


# 07. Counts of products in stores

SELECT 
s.name,
COUNT(p.category_id) AS product_count,
ROUND(AVG((p.price)),2) AS avg
FROM stores AS s
LEFT JOIN products_stores AS ps
ON s.`id` = ps.`store_id`
LEFT JOIN products AS p
ON ps.`product_id` = p.`id`
GROUP BY s.name
ORDER BY product_count DESC, avg DESC, s.id;


# 08. Specific employee

SELECT 
CONCAT(e.first_name, ' ', e.last_name) AS `Full_name`,
s.`name` AS `Store_name`,
addr.`name` AS `address`,
e.`salary`
FROM employees AS e
JOIN stores AS s
ON e.`store_id` = s.`id`
JOIN addresses AS addr
ON s.`address_id` = addr.`id`
WHERE e.salary<4000 AND addr.`name` LIKE '%5%' 
AND CHAR_LENGTH(s.`name`) > 8 AND RIGHT(e.last_name,1) LIKE 'n';


# 09. Find all information of stores

SELECT 
REVERSE(s.`name`) AS `reversed_name`,
concat(upper(t.`name`),'-',addr.`name`) AS `full_address`, 
count(s.`address_id`) AS `employees_count`
FROM `stores` AS s
JOIN `employees` AS e
ON s.`id` = e.`store_id`
JOIN `addresses` AS addr
ON s.`address_id` = addr.`id`
JOIN `towns` AS t
ON addr.`town_id` = t.`id`
GROUP BY s.`name`
HAVING employees_count >= 1
ORDER BY `full_address`;

