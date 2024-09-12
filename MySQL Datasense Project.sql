/* PROJECT: CREATE YOUR OWN DATABASE WITH 3 TABLES WITH 10 RECORDS EACH. 
THEN CREATE THE FOLLOWING:
- 3 if and else staements, put in a stored procedure
- 3 Case statements, put in a stored procedure
- 3 different user-defined functions using your own database only
- 3 subquery then its CTE version as well */



CREATE DATABASE CarSales; 

CREATE TABLE SalesPerson(
	DateOfPurchase DATE PRIMARY KEY NOT NULL,
	Salesperson VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,	
    LastName VARCHAR(50) NOT NULL,	
    CommissionRate DECIMAL (10, 6) NOT NULL,
    CommissionEarned DECIMAL (10, 2) NOT NULL
);

CREATE TABLE Sales(
	DateOfPurchase DATE NOT NULL,
	CustomerNumber INT(10) PRIMARY KEY NOT NULL,
	CarMake VARCHAR(50) NOT NULL,
	CarModel VARCHAR(50) NOT NULL,
	CarYear VARCHAR(50) NOT NULL,
	SalePrice VARCHAR(50) NOT NULL,
	PaymentMode VARCHAR(50) NULL
);

CREATE TABLE Customer(
	CustomerNumber INT(5) PRIMARY KEY NOT NULL,
	FirstName VARCHAR(50) NOT NULL,	
    LastName VARCHAR(50) NOT NULL,	
	City VARCHAR(50) NULL,	
	State VARCHAR(50) NULL,	
	Country VARCHAR(50) NULL,	
	PostalCode INT(50)
);

SELECT * FROM salesperson;

SELECT * FROM sales;

SELECT * FROM customer;


   
   
    DELIMITER $$
    CREATE Procedure CustomerIdentity()
    BEGIN
		SELECT 
        CustomerNumber,
        CONCAT(FirstName, ' ', LastName) AS 'FullName'
        FROM customer;
	END $$
    DELIMITER ;
    
    CALL CustomerIdentity();
    
    -- 1. IF: CLASSIFY THE CUSTOMERS' PAYMENT STATUS AS FULLY OR PARTIALLY PAID BASED ON PAYMENT MODE.
    DELIMITER $$
    CREATE PROCEDURE Payment()
	BEGIN
		SELECT 
        b.CustomerNumber,
		CONCAT(c.FirstName, ' ', c.LastName) AS 'FullName',
        b.PaymentMode,
        IF(PaymentMode = 'cash', 'Fully Paid', 'Partially Paid') AS PaymentStatus
        FROM sales AS b
        JOIN customer AS c
        ON b.CustomerNumber = c.CustomerNumber
        ORDER BY FirstName;
	END $$
    DELIMITER ;
        
    CALL Payment();
    
  -- 2. IF: DETERMINE IF THE CUSTOMERS LIVE WITHIN THE STATE OF CALIFORNIA.
    DELIMITER $$
    CREATE PROCEDURE InState()
    BEGIN
		SELECT 
		CustomerNumber,
		CONCAT(FirstName, ' ', LastName) AS 'FullName',
        IF(State = 'California', 'IN STATE', 'OUT OF STATE') AS Locality
		FROM customer;
	END $$
    DELIMITER ;
        
    CALL InState();
    
    -- 3. IF: IDENTIFY CARS' ORIGIN COUNTRY BASED ON CAR BRAND.
    DELIMITER $$
    CREATE PROCEDURE CarOrigin()
    BEGIN
		SELECT 
        CustomerNumber,
        CarMake,
        IF(CarMake IN ('Toyota', 'Nissan', 'Honda'), 'Japan',
			IF (CarMake = 'Ford', 'USA', 'Others')) AS CarOrigin
		FROM sales;
	END $$
    DELIMITER ;
        
    CALL CarOrigin();
    
    -- #1 CASE STATEMENT: CLASSIFY A CAR'S SALE PRICE IF IT'S HIGH, MODERATE OR LOW.
    DELIMITER $$
    CREATE PROCEDURE PriceRange()
    BEGIN
		SELECT
			CarMake,
			CarModel,
			SalePrice,
			CASE
				WHEN SalePrice <= 20000 THEN 'LOW'
				WHEN SalePrice > 20000 AND SalePrice <= 40000 THEN 'MODERATE'
				WHEN SalePrice >40000 THEN 'HIGH'
				ELSE 'OutOfRange'
			END AS PriceRange
        FROM sales ;
	END $$
    DELIMITER ;
	
    CALL PriceRange()
    
    -- #2 CASE STATEMENT: CLASSIFY SALES PERSONS' COMMISSION RATE AS HIGH, MODERATE OR LOW.
    DELIMITER $$
    CREATE PROCEDURE CommissionRate()
    BEGIN
		SELECT
			a.DateOfPurchase,
			CONCAT(a.FirstName, ' ', a.LastName) AS SalesFullName,
            FORMAT(b.SalePrice,2) AS SalePrice,
            FORMAT((a.CommissionRate * 100), 2) AS CommissionPercent,
            CASE 
				WHEN CommissionRate >0 AND CommissionRate < 0.06 THEN 'LOW'
                WHEN CommissionRate BETWEEN 0.06 AND 0.1 THEN 'MODERATE' 
                WHEN CommissionRate >0.1 THEN 'HIGH'
                ELSE 'NO COMMISSION'
			END AS 'Description'
            FROM salesperson AS a
            JOIN sales AS b
            ON a.DateOfPurchase = b.DateOfPurchase
            ORDER BY DateOfPurchase;
	END $$
    DELIMITER ;
    
    CALL CommissionRate();
    
    -- #3 CASE STATEMENT: CLASSIFY A CAR IF IT'S OLD, MODERATE OR NEW BASED ON THE YEAR.
    DELIMITER $$
    CREATE PROCEDURE CarYear()
    BEGIN
		SELECT
			DateOfPurchase,
			CarMake,
            CarModel,
			CarYear,
			CASE
				WHEN CarYear <= 2015 THEN 'OLD'
                WHEN CarYear BETWEEN 2016 AND 2020 THEN 'MODERATE'
                WHEN CarYear >= 2021 THEN 'NEW'
                ELSE 'OUT OF RANGE'
			END AS 'ModelDescription'
		FROM sales
        ORDER BY DateOfPurchase;
	END $$
    DELIMITER ;
   
   CALL CarYear();
   
-- 1. UDF: FUNCTION THAT RETURNS THE SALES OF THE INPUTED DATE.
DELIMITER $$
CREATE FUNCTION FN_SaleOfTheDay(PurchaseDate date)
RETURNS DECIMAL (10,2)
DETERMINISTIC
BEGIN
	DECLARE SaleOfTheDay DECIMAL (10,2);
    SELECT SalePrice
    INTO SaleOfTheDay
    FROM sales
    WHERE PurchaseDate = DateOfPurchase;
    
	RETURN SaleOfTheDay;
END $$
DELIMITER ;

SELECT FN_SaleOfTheDay('2022-08-01'); 	

-- #2 UDF: FUNCTION THAT RETURNS CUSTOMER'S MODE OF PAYMENT WITH CUSTOMER NUMBER AS INPUT.
DELIMITER $$
CREATE FUNCTION FN_Payment(customernum INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
	DECLARE Payment VARCHAR(50);
    SELECT PaymentMode
    INTO Payment
    FROM sales
    WHERE customernum = CustomerNumber;
    
	RETURN Payment;
END $$
DELIMITER ;		

SELECT FN_Payment('131');
 
 -- #3 UDF: FUNCTION THAT SUMMARIZES CUSTOMER INFORMATION WITH CUSTOMER NUMBER AS INPUT.
DELIMITER $$
CREATE FUNCTION FN_CustomerInfo(customernum INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	DECLARE Customer VARCHAR(100);
    SELECT 
    CONCAT(FirstName,' ', LastName, ' - ',City, ' City, ' ,State,', ',Country,' ',PostalCode ) AS CustomerInfo
    INTO Customer
    FROM customer
    WHERE customernum = CustomerNumber;
    
	RETURN Customer;
END $$
DELIMITER ;		

SELECT FN_CustomerInfo('131');    

-- 1. SUBQUERY: HOW MANY CAR BRANDS HAVE SALES MORE THAN $60000
SELECT COUNT(*)
FROM (SELECT CarMake, SUM(SalePrice) AS SalesPerBrand
	 FROM sales
	 GROUP BY CarMake) AS BrandSales

WHERE SalesPerBrand > 60000;

-- 1. CTE
WITH BrandSales AS (SELECT CarMake, SUM(SalePrice) AS SalesPerBrand
					FROM sales
					GROUP BY CarMake)
SELECT COUNT(*)
FROM BrandSales
WHERE SalesPerBrand > 60000;

-- 2. SUBQUERY: LIST CAR BRANDS WITH SALES AMOUNT LESS THAN OR EQUAL TO THE AVERAGE SALES PER BRAND.
SELECT CarMake
FROM (SELECT CarMake, SUM(SalePrice) AS SalesPerBrand
	 FROM sales
	 GROUP BY CarMake) AS BrandSales

WHERE SalesPerBrand <= (SELECT AVG(SalesPerBrand)
FROM (SELECT CarMake, SUM(SalePrice) AS SalesPerBrand
	 FROM sales
	 GROUP BY CarMake) AS SalesPerBrand) ;

-- 2. CTE
WITH BrandSales AS (SELECT CarMake, SUM(SalePrice) AS SalesPerBrand
					FROM sales
					GROUP BY CarMake)
SELECT CarMake
FROM BrandSales
WHERE SalesPerBrand <= (SELECT AVG(SalesPerBrand)
						FROM BrandSales);

-- 3. SUBQUERY: MAKE A TABLE WITH THE MAX PRICE FOR EACH CAR MODEL WITH THE SALE PRICE OF EACH SOLD MODEL.
SELECT *
FROM (SELECT CarModel, MAX(SalePrice) AS MaxPrice
			FROM sales
			GROUP BY CarModel) AS MM
LEFT JOIN (SELECT CarModel, SalePrice
			FROM sales) AS CM 
ON MM.CarModel = CM.CarModel;

-- 3. CTE 
WITH MM AS (SELECT CarModel, MAX(SalePrice) AS MaxPrice
			FROM sales
			GROUP BY CarModel),
	 CM AS (SELECT CarModel, SalePrice
			FROM sales)
	
SELECT *
FROM MM
LEFT JOIN CM ON MM.CarModel = CM.CarModel;
