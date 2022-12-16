

# 01. Managers

SELECT 
    `employee_id`,
    CONCAT(`first_name`, ' ', `last_name`) AS `full_name`,
    `departments`.`department_id`,
    `departments`.`name` AS `department_name`
FROM
    `employees`
        JOIN
    `departments` ON `employees`.`employee_id` = `departments`.`manager_id`
ORDER BY `employee_id`
LIMIT 5;


# 02. Towns and Addresses

SELECT 
    `a`.`town_id`, `t`.`name` AS `town_name`, `a`.`address_text`
FROM
    `addresses` AS `a`
        JOIN
    `towns` AS `t` ON `a`.`town_id` = `t`.`town_id`
WHERE
    `t`.`name` LIKE 'San Francisco'
        OR `t`.`name` LIKE 'Sofia'
        OR `t`.`name` LIKE 'Carnation'
ORDER BY `town_id` , `address_id`;


# 03. Employees Without Managers

SELECT `employee_id`, `first_name`, `last_name`, `department_id`, `salary` FROM `employees`
WHERE `manager_id` IS NULL;


# 04. High Salary

SELECT COUNT(`employee_id`) AS `count` FROM `employees`
WHERE `employees`.`salary`> (SELECT AVG(`salary`) FROM `employees`);

