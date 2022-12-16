

# 01. Departments Info

SELECT `department_id`, COUNT(`id`) AS `Number of employees` 
FROM `employees` GROUP BY `department_id`; 


# 02. Average Salary

SELECT `department_id`, ROUND(AVG(`salary`), 2) AS `Average Salary`
FROM `employees` 
GROUP BY `department_id`;


# 03. Minimum Salary 

SELECT `department_id`, ROUND(MIN(`salary`), 2) AS `Min salary`
FROM `employees`
GROUP BY `department_id`
HAVING `Min salary` > 800;


# 04. Appetizers Count

SELECT COUNT(`category_id`) AS `count` FROM `products`
WHERE `price` > 8 
GROUP BY `category_id`
HAVING `category_id` = 2 ;


# 05. Menu Prices

SELECT `category_id`, 
ROUND(AVG(`price`), 2) AS `Average price`,
ROUND(MIN(`price`), 2) AS `Cheapest product`,
ROUND(MAX(`price`), 2) AS `Most Expensive Product`
FROM `products`
GROUP BY `category_id`;

