

# 01. One-To-One Relationship

CREATE TABLE `people` (
`person_id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(255),
`salary` DECIMAL(10,2),
`passport_id` INT UNIQUE
);


CREATE TABLE `passports`(
`passport_id` INT PRIMARY KEY AUTO_INCREMENT,
`passport_number` VARCHAR(255) UNIQUE
);


ALTER TABLE `people`
ADD CONSTRAINT `fk_people_passports`
FOREIGN KEY (`passport_id`)
REFERENCES `passports` (`passport_id`);


INSERT INTO `passports` (`passport_id`, `passport_number`) VALUES
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2');


INSERT INTO `people` (`first_name`, `salary`, `passport_id`) VALUES
('Roberto', 43300.00, 102),
('Tom', 56100.00, 103),
('Yana', 60200.00, 101);


# 02. One-To-Many Relationship

CREATE TABLE `manufacturers` (
`manufacturer_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(255),
`established_on` DATE
);
CREATE TABLE `models` (
`model_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(255),
`manufacturer_id` INT
);
ALTER TABLE `models`
ADD CONSTRAINT `fk_models_manufacturer`
FOREIGN KEY (`manufacturer_id`)
REFERENCES `manufacturers`(`manufacturer_id`);

INSERT INTO `manufacturers` (`name`, `established_on`) VALUES 
('BMW', '1916-03-01'),
('Tesla', '2003-01-01'),
('Lada', '1966-05-01');

INSERT INTO `models` (`model_id`, `name`, `manufacturer_id`) VALUES 
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3);


# 03. Many-To-Many Relationship

CREATE TABLE `students_exams`(
`student_id` INT,
`exam_id` INT 
);
CREATE TABLE `students`(
`student_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(255)
);
CREATE TABLE `exams`(
`exam_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(255)
);

ALTER TABLE `students_exams`
ADD CONSTRAINT `fk_student_student`
FOREIGN KEY (`student_id`)
REFERENCES `students`(`student_id`);

ALTER TABLE `students_exams`
ADD CONSTRAINT `fk_exam_exam`
FOREIGN KEY (`exam_id`)
REFERENCES `exams`(`exam_id`);

INSERT INTO `students`(`name`) VALUES
('Mila'),
('Toni'),
('Ron');
INSERT INTO `exams`(`exam_id`, `name`) VALUES
(101, 'Spring MVC'),
(102, 'Neo4j'),
(103, 'Oracle 11g');
INSERT INTO `students_exams`(`student_id`, `exam_id`) VALUES
(1, 101),	
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103);


# 04. Self-Referencing

CREATE TABLE `teachers`(
`teacher_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50),
`manager_id` INT
);

INSERT INTO `teachers` (`teacher_id`, `name`, `manager_id`) VALUES
(101, 'John', NULL),
(102, 'Maya', 106),
(103, 'Silvia', 106),
(104, 'Ted', 105),
(105, 'Mark', 101),
(106, 'Greta', 101);

ALTER TABLE `teachers`
ADD CONSTRAINT `fk_manager_id_teacher`
FOREIGN KEY (`manager_id`)
REFERENCES `teachers` (`teacher_id`);


# 05. Online Store Database

CREATE TABLE `customers` (
    `customer_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50),
    `birthday` DATE,
    `city_id` INT(11)
);
CREATE TABLE `cities` (
    `city_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50)
);
CREATE TABLE `orders` (
    `order_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
    `customer_id` INT(11)
);
CREATE TABLE `order_items` (
    `order_id` INT(11),
    `item_id` INT(11),
    CONSTRAINT `pk` PRIMARY KEY (`order_id` , `item_id`)
);
CREATE TABLE `items` (
    `item_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50),
    `item_type_id` INT(11)
);
CREATE TABLE `item_types` (
    `item_type_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50)
);

ALTER TABLE `order_items`
ADD CONSTRAINT `fk1`
FOREIGN KEY (`order_id`)
REFERENCES `orders` (`order_id`);

ALTER TABLE `order_items`
ADD CONSTRAINT `fk2`
FOREIGN KEY (`item_id`)	
REFERENCES `items` (`item_id`);

ALTER TABLE `items`
ADD CONSTRAINT `fk3`
FOREIGN KEY (`item_type_id`)
REFERENCES `item_types` (`item_type_id`);

ALTER TABLE `orders`
ADD CONSTRAINT `fk4`
FOREIGN KEY (`customer_id`)
REFERENCES `customers` (`customer_id`);

ALTER TABLE `customers`
ADD CONSTRAINT `fk5`
FOREIGN KEY (`city_id`)
REFERENCES `cities` (`city_id`);


# 06. University Database

CREATE TABLE `subjects` (
    `subject_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
    `subject_name` VARCHAR(50)
);
CREATE TABLE `majors` (
    `major_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50)
);
CREATE TABLE `payments` (
    `payment_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
    `payment_date` DATE,
    `payment_amount` DECIMAL(8 , 2 ),
    `student_id` INT(11)
);
CREATE TABLE `students` (
    `student_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
    `student_number` VARCHAR(12),
    `student_name` VARCHAR(50),
    `major_id` INT(11)
);
CREATE TABLE `agenda` (
    `student_id` INT(11),
    `subject_id` INT(11),
    PRIMARY KEY (`student_id` , `subject_id`)
);
ALTER TABLE `payments`
ADD CONSTRAINT `fk1`
FOREIGN KEY (`student_id`)
REFERENCES `students` (`student_id`);
ALTER TABLE `students`
ADD CONSTRAINT `fk2`
FOREIGN KEY (`major_id`)
REFERENCES `majors`(`major_id`);
ALTER TABLE `agenda`
ADD CONSTRAINT `fk3`
FOREIGN KEY (`student_id`)
REFERENCES `students`(`student_id`);
ALTER TABLE `agenda`
ADD CONSTRAINT `fk4`
FOREIGN KEY (`subject_id`)
REFERENCES `subjects`(`subject_id`);


# 07. Peaks in Rila

SELECT `mountain_range`, `peak_name`, `elevation` AS `peak_elevation` 
FROM `mountains` AS `m`
JOIN `peaks` AS `p`
ON `m`.`id` = `p`.`mountain_id`
WHERE `mountain_range` LIKE 'Rila'
ORDER BY `peak_elevation` DESC;

