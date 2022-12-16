

# 01. Find Book Titles

SELECT `title` FROM `books`
WHERE SUBSTRING(`title`, 1 ,3) = "The"
ORDER BY `id`;


# 02. Replace Titles

SELECT REPLACE(`title`, "The", "***")  AS `title` 
FROM `books` WHERE SUBSTRING(`title`, 1, 3) = "The";


# 03. Sum Cost of All Books

SELECT ROUND(SUM(`cost`),2) AS `sum`
FROM `books`;


# 04. Days Lived

SELECT CONCAT(`first_name`, ' ', `last_name`) AS `Full name`,
TIMESTAMPDIFF(DAY, `born`, `died`) AS `Days Lived` 
FROM `authors`;
     
     
# 05. Harry Potter Books

SELECT `title`FROM `books`
WHERE `title` LIKE 'Harry_Potter%';

