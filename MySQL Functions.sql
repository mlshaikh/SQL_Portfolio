-- EXERCISE: USE 20 MYSQL FUNCTIONS

USE sakila;

#1-3 CONCATENATE(), LEFT(), LCASE()
SELECT 
actor_id,
CONCAT(first_name, ' ',last_name) AS FullName,
LCASE(CONCAT((LEFT(first_name, 1)), last_name)) AS Username
FROM actor
ORDER BY first_name;


#4-12 INSERT(), INSTR(), SPACE(), SUBSTRING_INDEX(), LENGTH(), RIGHT(), REVERSE(), CEILING(), FLOOR()

SELECT 
title,
INSERT(title, INSTR(title, ' '),1, space(10)) AS SpacedTitle,
SUBSTRING_INDEX(title, ' ' , 1) AS TitleFirstWord,
description,
LENGTH(description) AS DescriptionLength,
RIGHT(REVERSE(description), 5) AS RightReverse,
rental_rate,
CEILING(rental_rate) AS Ceiling,
FLOOR(rental_rate) AS Floor
FROM film;


#13-14 FORMAT(), SUM()

SELECT 
customer_id,
FORMAT(SUM(amount), 0) AS TotalAmountPaid
FROM payment
GROUP BY customer_id;


# 15-17 ADDTIME(), ADDDATE(), DATEDIFF()

SELECT
payment_id,
payment_date,
last_update,
ADDTIME(ADDDATE(payment_date, INTERVAL 30 DAY), '-9:0:0') AS ExtendedRentalDate,
DATEDIFF(last_update, payment_date) AS PaymentToUpdate
FROM payment;


# 18-21 MONTHNAME(), DAYNAME(), LAST_DAY(), MAKETIME()

SELECT 
rental_date,
MONTHNAME(rental_date) AS RentalMonth,
return_date,
DAYNAME (return_date) AS ReturnDay,
LAST_DAY(return_date) AS ReturnDeadline,
MAKETIME('16', '00', '00') AS DeadlineTime
FROM rental;


