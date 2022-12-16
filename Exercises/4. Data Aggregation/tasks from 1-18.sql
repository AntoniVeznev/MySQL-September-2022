

# 01. Records’ Count

SELECT COUNT(`id`) AS `count` FROM `wizzard_deposits`;


# 02. Longest Magic Wand

SELECT `magic_wand_size` AS `longest_magic_wand` FROM `wizzard_deposits`
ORDER BY `magic_wand_size` DESC
LIMIT 1;


# 03. Longest Magic Wand per Deposit Groups

SELECT `deposit_group` , MAX(`magic_wand_size`) AS `lognest_magic_wand`
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `lognest_magic_wand`, `deposit_group`;


# 04. Smallest Deposit Group per Magic Wand Size

SELECT `deposit_group`
FROM `wizzard_deposits`
GROUP BY `deposit_group`
HAVING MIN(`magic_wand_size`)
LIMIT 1;


# 05. Deposits Sum

SELECT `deposit_group`, SUM(`deposit_amount`) AS `total_sum` FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `total_sum`;


# 06. Deposits Sum for Ollivander Family

SELECT `deposit_group`, SUM(`deposit_amount`) AS `total_sum` FROM `wizzard_deposits`
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
ORDER BY `deposit_group`;


# 07. Deposits Filter

SELECT `deposit_group`, SUM(`deposit_amount`) AS `total_sum` FROM `wizzard_deposits`
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
HAVING `total_sum` < 150000
ORDER BY `total_sum` DESC;	


# 08. Deposit Charge

SELECT `deposit_group`, `magic_wand_creator`, MIN(`deposit_charge`) AS `min_deposit_charge` FROM `wizzard_deposits`
GROUP BY `deposit_group`, `magic_wand_creator`
ORDER BY `magic_wand_creator`, `deposit_group`;


# 09. Age Groups

SELECT 
CASE
WHEN `age` <= 10 then '[0-10]'
WHEN `age` <= 20 then '[11-20]'
WHEN `age` <= 30 then '[21-30]'
WHEN `age` <= 40 then '[31-40]'
WHEN `age` <= 50 then '[41-50]'
WHEN `age` <= 60 then '[51-60]'
WHEN `age` >= 61 then '[61+]'
END AS `age_group`, COUNT(*) `age_group`
FROM `wizzard_deposits`
GROUP BY `age_group`
ORDER BY `age_group`;


# 10. First Letter

SELECT LEFT(`first_name`, 1) AS `first_letter` FROM `wizzard_deposits`
WHERE `deposit_group` = 'Troll Chest'
GROUP BY `first_letter`
ORDER BY `first_letter`;


# 11. Average Interest

SELECT `deposit_group`, `is_deposit_expired`, AVG(`deposit_interest`) AS 'average_interest' 
FROM `wizzard_deposits`
WHERE `deposit_start_date` > '1985-01-01'
GROUP BY `deposit_group`,`is_deposit_expired`
HAVING `is_deposit_expired` = 0 OR `is_deposit_expired` = 1
ORDER BY `deposit_group` DESC, `is_deposit_expired`;


# 12. Employees Minimum Salaries

SELECT `department_id`, MIN(`salary`) AS 'minimum_salary' FROM `employees`
WHERE `hire_date` > '2000-01-01'
GROUP BY `department_id`
HAVING `department_id` IN (2, 5, 7)
ORDER BY `department_id`;

# 13. Employees Average Salaries

CREATE TABLE `new_table` (
SELECT * FROM `employees`
WHERE `salary` > 30000
);
DELETE FROM `new_table`
WHERE `manager_id` = 42;
UPDATE `new_table`
SET `salary` = `salary` + 5000
WHERE `department_id` = 1;
SELECT `department_id`, AVG(`salary`) AS 'avg_salary' FROM `new_table`
GROUP BY `department_id`
ORDER BY `department_id`;


# 14. Employees Maximum Salaries

SELECT `department_id`, MAX(`salary`) AS 'max_salary' FROM `employees`
GROUP BY `department_id`
HAVING `max_salary` < 30000 OR `max_salary` > 70000
ORDER BY `department_id` ASC;


# 15. Employees Count Salaries

SELECT COUNT(`salary`) FROM `employees`
WHERE `manager_id` IS NULL;


# 16. 3rd Highest Salary

SELECT `department_id`, 
(
SELECT DISTINCT `salary` FROM `employees` e
WHERE e.`department_id`= `employees`. `department_id`
ORDER BY `salary` DESC
LIMIT 1 OFFSET 2
) 
AS `third_highest_salary` FROM `employees`
GROUP BY `department_id`
HAVING `third_highest_salary` IS NOT NULL
ORDER BY `department_id`;


# 17. Salary Challenge

SELECT `first_name`, `last_name`, `department_id` FROM `employees` AS `current_item`
WHERE `salary` > (
                  SELECT AVG(`salary`) FROM `employees` AS `next_item`
				  WHERE `current_item`.`department_id`=`next_item`.`department_id`
                  )
ORDER BY `department_id`, `employee_id` LIMIT 10;


# 18. Departments Total Salaries

SELECT `department_id`, SUM(`salary`) AS `total_salary` FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id`;

