

# 01. Employees with Salary Above 35000

DELIMITER $$ 
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
SELECT first_name, last_name FROM `employees` as e
WHERE e.salary > 35000
ORDER BY first_name, last_name, employee_id DESC;
END$$


# 02. Employees with Salary Above Number

DELIMITER $$ 
CREATE PROCEDURE usp_get_employees_salary_above(salaryyy DECIMAL(19,4))
BEGIN
SELECT first_name, last_name FROM `employees` as e
WHERE e.salary >= salaryyy
ORDER BY first_name, last_name, employee_id DESC;
END$$


# 03. Town Names Starting With

DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(word VARCHAR(255))
BEGIN 
SELECT `name`AS `town_name` FROM `towns` AS t
JOIN `addresses` AS a
ON t.`town_id` = a.`town_id`
JOIN `employees` AS e
ON a.`address_id` = e.`address_id`
WHERE t.`name` LIKE CONCAT(word,'','%')
GROUP BY t.`name`
ORDER BY t.`name`;
END $$


# 04. Employees from Town

DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town(name_of_the_town VARCHAR(255))
BEGIN
SELECT `first_name`, `last_name` FROM `employees` AS e
JOIN `addresses` AS a
ON e.`address_id` = a.`address_id`
JOIN `towns` AS t
ON a.`town_id` = t.`town_id`
WHERE t.`name` LIKE name_of_the_town
ORDER BY e.`first_name`, e.`last_name`;
END $$


# 05. Salary Level Function

DELIMITER $$
CREATE FUNCTION `ufn_get_salary_level`(`salary` DECIMAL(19, 4))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
DECLARE `salary_level` VARCHAR(255);
IF `salary` < 30000 THEN SET `salary_level` := 'Low';
ELSEIF `salary` >= 30000 AND `salary` <= 50000 THEN SET `salary_level` := 'Average';
ELSEIF `salary` > 50000 THEN SET `salary_level` := 'High';
END IF;
RETURN salary_level;
END $$


# 06. Employees by Salary Level

CREATE FUNCTION `ufn_get_salary_level`(`salary` DECIMAL(19, 4))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
DECLARE `salary_level` VARCHAR(255);
IF `salary` < 30000 THEN SET `salary_level` := 'Low';
ELSEIF `salary` >= 30000 AND `salary` <= 50000 THEN SET `salary_level` := 'Average';
ELSE SET `salary_level` := 'High';
END IF;
RETURN salary_level;
END;

CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(255))
BEGIN
SELECT `first_name`, `last_name`  FROM `employees`
WHERE `ufn_get_salary_level`(`salary`) LIKE `salary_level`
ORDER BY `first_name` DESC, `last_name` DESC;
END;


# 07. Define Function

CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
RETURN word REGEXP (CONCAT('^[', set_of_letters, ']+$'));
END


# 08. Find Full Name

CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
SELECT CONCAT(`first_name`, ' ', `last_name`) AS `full_name` FROM `account_holders`
ORDER BY `full_name`, `id`;
END


# 10. Future Value Function

CREATE FUNCTION ufn_calculate_future_value(sum DECIMAL(19, 4), yearly_interest DOUBLE, yers INT)
RETURNS DECIMAL(19, 4)
DETERMINISTIC
BEGIN
    DECLARE future_sum DECIMAL(19, 4);
    SET future_sum := sum * POW(1 + yearly_interest, yers);
    RETURN future_sum;
END


# 11. Calculating Interest

CREATE FUNCTION ufn_calculate_future_value(sum DECIMAL(19, 4), yearly_interest DOUBLE, yers INT)
RETURNS DECIMAL(19, 4)
DETERMINISTIC
BEGIN
    DECLARE future_sum DECIMAL(19, 4);
    SET future_sum := sum * POW(1 + yearly_interest, yers);
    RETURN future_sum;
END;

CREATE PROCEDURE usp_calculate_future_value_for_account(id INT, interest_rate DECIMAL(19,4))
BEGIN
    SELECT a.`id` AS 'account_id', ah.`first_name`, ah.`last_name`, 
    a.`balance` AS 'current_balance', ufn_calculate_future_value(a.balance, interest_rate, 5) AS 'balance_in_5_years'
    FROM `account_holders` AS ah
    JOIN `accounts` AS a ON a.`account_holder_id` = ah.`id`
    WHERE a.`id` = id;
END;


# 12. Deposit Money

CREATE PROCEDURE usp_deposit_money(id INT, money_amount DECIMAL(19,4))
BEGIN
    START TRANSACTION;
    IF(money_amount <= 0 ) THEN
    ROLLBACK;
    ELSE
        UPDATE `accounts` AS ac SET ac.`balance` = ac.`balance` + money_amount
        WHERE ac.`id` = id;
    END IF; 
END


# 13. Withdraw Money

CREATE PROCEDURE usp_withdraw_money(id int, money_amount decimal(19,4))
BEGIN
    START TRANSACTION;
    IF (money_amount <= 0 OR (SELECT `balance` FROM accounts AS a WHERE a.`id` = id) < money_amount) THEN
    ROLLBACK;
    ELSE
        UPDATE accounts as ac SET ac.balance = ac.balance - money_amount
        WHERE ac.id = id;
        COMMIT;
    END IF; 
END


# 14. Money Transfer

CREATE PROCEDURE usp_transfer_money(fromID int, toID int,money_amount decimal(19,4))
BEGIN
    START TRANSACTION;
    IF(money_amount <= 0 OR (SELECT `balance` from `accounts` where `id` = fromID) < money_amount
    OR fromID = toID 
    OR (SELECT COUNT(id) FROM `accounts` WHERE `id` = fromID) <> 1
    OR (SELECT COUNT(id) FROM `accounts` WHERE `id` = toID) <> 1) 
    THEN ROLLBACK;
    ELSE
        UPDATE `accounts` SET `balance` = `balance` - money_amount
        WHERE `id` = fromID;
        UPDATE `accounts` SET `balance` = `balance` + money_amount
        WHERE `id` = toID;
        COMMIT;
    END IF; 
END

