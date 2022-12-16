

# 01. Table Design

CREATE TABLE `products` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL UNIQUE,
`type` VARCHAR(30) NOT NULL,
`price` DECIMAL(10, 2) NOT NULL
);
CREATE TABLE `clients` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(50) NOT NULL,
`last_name` VARCHAR(50) NOT NULL,
`birthdate` DATE NOT NULL,
`card` VARCHAR(50),
`review` TEXT
);
CREATE TABLE `tables` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`floor` INT NOT NULL,
`reserved` TINYINT(1),
`capacity` INT NOT NULL
);
CREATE TABLE `waiters` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(50) NOT NULL,
`last_name` VARCHAR(50) NOT NULL,
`email` VARCHAR(50) NOT NULL,
`phone` VARCHAR(50),
`salary` DECIMAL(10, 2)
);
CREATE TABLE `orders` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`table_id` INT NOT NULL,
`waiter_id` INT NOT NULL,
`order_time` TIME NOT NULL,
`payed_status` TINYINT(1)
);
CREATE TABLE `orders_clients` (
`order_id` INT,
`client_id` INT
);
CREATE TABLE `orders_products` (
`order_id` INT,
`product_id` INT
);

ALTER TABLE `orders_clients`
ADD CONSTRAINT fk1
FOREIGN KEY (order_id)
REFERENCES orders(id),
ADD CONSTRAINT fk2
FOREIGN KEY (client_id)
REFERENCES clients(id);

ALTER TABLE `orders_products`
ADD CONSTRAINT fk3
FOREIGN KEY (order_id)
REFERENCES orders(id),
ADD CONSTRAINT fk4
FOREIGN KEY (product_id)
REFERENCES products(id);

ALTER TABLE `orders`
ADD CONSTRAINT fk5
FOREIGN KEY (table_id)
REFERENCES `tables`(id),
ADD CONSTRAINT fk6
FOREIGN KEY (waiter_id)
REFERENCES waiters(id);


# 02. Insert

INSERT INTO `products` (`name`, `type`, `price`)
(SELECT
concat(w.last_name, ' ', 'specialty') AS `name`,
 'Cocktail' AS `type`,
ceil((w.salary * 1.01) - w.salary) AS `price`
FROM waiters AS w
WHERE  w.id > 6
);


# 03. Update

UPDATE orders AS o
SET o.table_id = o.table_id -1
WHERE  o.id>= 12 AND o.id <=23;


# 04. Delete

DELETE w FROM `waiters` AS w
LEFT JOIN `orders` AS o
ON w.`id` = o.`waiter_id`
WHERE o.waiter_id IS NULL;


# 05. Clients

SELECT * FROM clients
ORDER BY birthdate DESC, id DESC;


# 06. Birthdate

SELECT 
`first_name`,
`last_name`,
`birthdate`,
`review`
FROM clients AS c
WHERE c.card IS NULL AND YEAR(c.birthdate) >= 1978 AND YEAR(c.birthdate) <= 1993 
ORDER BY last_name DESC, id 
LIMIT 5;
    
    
# 07. Accounts

SELECT
concat(w.last_name, '', w.first_name, CHAR_LENGTH(w.first_name), 'Restaurant') AS `username`,
REVERSE(substring(w.email, 2, 12)) AS `password`
FROM waiters AS w
WHERE w.salary IS NOT NULL
ORDER BY `password` DESC;


# 08. Top from menu

SELECT 
p.`id` AS `id`,
p.`name` AS `name`, 
count(*) AS `count`
FROM products AS p
JOIN orders_products AS op 
ON p.id = op.product_id
JOIN orders AS o 
ON op.order_id = o.id 
GROUP BY p.`name`
HAVING count >= 5
ORDER BY count DESC, name ASC;


# 09. Availability

SELECT 
t.id AS table_id,
t.capacity AS capacity,
count(o.table_id) AS count_clients,
CASE WHEN t.capacity > count(*) THEN 'Free seats'
WHEN t.capacity = count(*) THEN 'Full'
WHEN t.capacity < count(*) THEN 'Extra seats'
END AS `availability`
FROM `tables` AS t
JOIN orders AS o
ON t.`id` = o.`table_id`
JOIN orders_clients AS oc
ON o.`id` = oc.`order_id`
JOIN clients AS c
ON oc.`client_id` = c.`id`
WHERE t.`floor` = 1
GROUP BY o.table_id
ORDER BY table_id DESC;
 
 
# 10. Extract bill

DELIMITER $$
CREATE FUNCTION udf_client_bill(full_name VARCHAR(50))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN 
RETURN(
SELECT sum(p.price) FROM clients AS c
JOIN orders_clients AS oc
ON c.`id` = oc.`client_id`
JOIN orders AS o
ON oc.`order_id` = o.`id`
JOIN orders_products AS op
ON o.`id` = op.`order_id`
JOIN products AS p
ON op.`product_id` = p.`id`
WHERE concat(c.first_name, ' ', c.last_name) = full_name
GROUP BY c.`first_name`
);
END $$


# 11. Happy hour

DELIMITER $$
CREATE PROCEDURE udp_happy_hour(type VARCHAR(50))
BEGIN 
UPDATE `products` AS p
SET p.price =  p.price - (p.price * 0.20)
WHERE p.price >= 10 AND p.type = type;
END $$