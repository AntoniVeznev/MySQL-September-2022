

# 01. Table Design

CREATE TABLE `brands` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);
CREATE TABLE `categories` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);
CREATE TABLE `reviews` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `content` TEXT,
    `rating` DECIMAL(10 , 2 ) NOT NULL,
    `picture_url` VARCHAR(80) NOT NULL,
    `published_at` DATETIME NOT NULL
);
CREATE TABLE `products` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL,
    `price` DECIMAL(19 , 2 ) NOT NULL,
    `quantity_in_stock` INT,
    `description` TEXT,
    `brand_id` INT NOT NULL,
    `category_id` INT NOT NULL,
    `review_id` INT
);
CREATE TABLE `customers`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`first_name` VARCHAR(20) NOT NULL,
	`last_name` VARCHAR(20) NOT NULL,
	`phone` VARCHAR(30) NOT NULL UNIQUE,
	`address` VARCHAR(60) NOT NULL,
	`discount_card` BIT(1)
);
CREATE TABLE `orders` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `order_datetime` DATETIME NOT NULL,
    `customer_id` INT NOT NULL
);
CREATE TABLE `orders_products` (
    `order_id` INT,
    `product_id` INT
);
  
ALTER TABLE `products`
ADD CONSTRAINT fk1
FOREIGN KEY (brand_id)
REFERENCES brands(id),
ADD CONSTRAINT fk2
FOREIGN KEY (category_id)
REFERENCES categories(id),
ADD CONSTRAINT fk3
FOREIGN KEY (review_id)
REFERENCES reviews(id);

ALTER TABLE `orders`
ADD CONSTRAINT fk4
FOREIGN KEY (customer_id)
REFERENCES customers(id);

ALTER TABLE `orders_products`
ADD CONSTRAINT fk5
FOREIGN KEY (order_id)
REFERENCES orders(id),
ADD CONSTRAINT fk6
FOREIGN KEY (product_id)
REFERENCES products(id);


# 02. Insert

INSERT INTO `reviews` (`content`, `picture_url`, `published_at`, `rating`)
(SELECT 
LEFT(p.`description`, 15) AS `content`,
REVERSE(p.`name`) AS `picture_url`,
'2010/10/10' AS `published_at`,
p.`price` / 8 AS `rating`
FROM `products` AS p
WHERE p.`id` >= 5);


# 03. Update

UPDATE `products` SET `quantity_in_stock` = `quantity_in_stock` - 5
WHERE `quantity_in_stock` >= 60 AND `quantity_in_stock` <= 70;


# 04. Delete

DELETE c FROM `customers` AS c  
LEFT JOIN orders AS o
ON c.`id` = o.`customer_id`
WHERE customer_id IS NULL;


# 05. Categories

SELECT * FROM `categories` AS c
ORDER BY c.name DESC;


# 06. Quantity

SELECT
`id`,
`brand_id`, 
`name`,
`quantity_in_stock`
FROM `products` AS p
WHERE p.`price` > 1000 AND p.`quantity_in_stock` < 30
ORDER BY `quantity_in_stock`, `id`;


# 07. Review

SELECT * FROM `reviews` AS r
WHERE LEFT(r.content, 2) = 'My' AND char_length(r.content) > 61
ORDER BY rating DESC;


# 08. First customers

SELECT 
CONCAT(c.first_name, ' ', c.last_name) AS `full_name`,
c.`address`,
o.`order_datetime` AS `order_date`
FROM `customers` AS c
JOIN `orders` AS o
ON c.`id` = o.`customer_id`
WHERE YEAR(o.`order_datetime`) <= 2018
ORDER BY `full_name` DESC;


# 09. Best categories

SELECT 
count(p.category_id) AS `items_count`,
c.`name` AS `name`,
sum(p.quantity_in_stock) AS `total_quantity`
FROM `categories` AS c
JOIN `products` AS p
ON c.`id` = p.`category_id`
WHERE p.category_id = c.id
GROUP BY category_id
ORDER BY `items_count` DESC, `total_quantity`
LIMIT 5;


# 10. Extract client cards count

DELIMITER $$
CREATE FUNCTION udf_customer_products_count(name VARCHAR(30))
RETURNS INT 
DETERMINISTIC
BEGIN

RETURN(SELECT count(c.first_name) FROM customers AS c
JOIN orders AS o
ON c.id = o.customer_id
JOIN orders_products AS op
ON o.id = op.order_id
WHERE c.first_name = name);

END $$


# 11. Reduce price

DELIMITER $$
CREATE PROCEDURE udp_reduce_price(category_name VARCHAR(50))
BEGIN
UPDATE `products` AS p 
JOIN `categories` AS c
ON c.id = p.category_id
JOIN `reviews` AS r
ON r.id = p.review_id
SET p.price = (p.price)-(p.price * 0.30)
WHERE c.name = category_name AND r.rating < 4;
END $$

