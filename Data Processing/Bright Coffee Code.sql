SELECT * 
FROM retails.sales.bright_coffee
LIMIT 10;

--- check column are in correct format
SELECT 
     transaction_id, 
     unit_price,
     CAST(REPLACE(unit_price, ',','.')AS DECIMAL(10,2)) AS Unit_price
FROM retails.sales.bright_coffee
LIMIT 10;

--- transaction time is a string

SELECT 
     date_format(transaction_time, 'HH:mm:ss') AS trans_time
     CAST
FROM retails.sales.bright_coffee;


-- CHECK NUMBER OF RECORD 
SELECT 
      COUNT(*) AS total_records
      FROM retails.sales.bright_coffee;

-- CHECK FOR DUPLICATES (it must be on a row basis and not column basis)
SELECT * ,
     COUNT(*)
FROM retails.sales.bright_coffee 
GROUP BY ALL 
HAVING COUNT(*) >1;  -- NO DUPLICATE FOUND


-- CHECK FOR NULL VALUES
SELECT * 
FROM FROM retails.sales.bright_coffee
WHERE transaction_id IS NULL OR transaction_date IS NULL OR transaction_time IS NULL OR transaction_qty IS NULL OR store_id IS NULL OR store_location IS NULL OR product_id IS NULL OR unit_price IS NULL OR product_category IS NULL OR product_type IS NULL OR product_detail IS NULL;  --- NO NULL values 

--------------------------------------------------------------------------------------------------------------------------------------------------------------

--- TOTAL REVENUE 
SELECT transaction_qty * unit_price  ------- It can't run because the data type of unit price on the table is not correct , therefore use CAST. 
FROM FROM retails.sales.bright_coffee;

SELECT 
      transaction_qty * CAST((REPLACE(unit_price, ',','.')) AS DOUBLE) AS total_amount 
FROM retails.sales.bright_coffee; 

--- 1. TOTAL REVENUE 
SELECT
    SUM(transaction_qty * (CAST((REPLACE(unit_price, ',','.')) AS DECIMAL(10,2)))) AS Total_revenue 
FROM retails.sales.bright_coffee;

SELECT 
     transaction_id,
    SUM(transaction_qty * (CAST((REPLACE(unit_price, ',','.')) AS DECIMAL(10,2)))) AS Total_revenue 
FROM retails.sales.bright_coffee
GROUP BY ALL;

--- 2. TOTAL REVENUE PER PRODUCT CATEGORY
SELECT 
    product_category,
    SUM(transaction_qty * (CAST((REPLACE(unit_price, ',','.')) AS DECIMAL(10,2)))) AS Total_revenue 
FROM retails.sales.bright_coffee 
GROUP BY ALL;
 

 --- 3. TOTAL REVENUE PER PRODUCT CATEGORY AND PRODUCT DETAILS
SELECT 
    product_category,
    product_detail,
    SUM(transaction_qty * (CAST((REPLACE(unit_price, ',','.')) AS DECIMAL(10,2)))) AS Total_revenue 
FROM retails.sales.bright_coffee 
--- WHERE product_category = 'Coffee'
 GROUP BY ALL;
 ---ORDER BY Total_revenue;


--- 4. TOTAL REVENUE PER PRODUCT TYPE
SELECT
    product_type,
    SUM(transaction_qty * (CAST((REPLACE(unit_price, ',','.')) AS DECIMAL(10,2)))) AS Total_revenue 
FROM retails.sales.bright_coffee
GROUP BY ALL;

--- 5. TOTAL UNITS SOLD 
SELECT
    --- product_category,
    SUM((transaction_qty)) AS Total_units_sold
FROM retails.sales.bright_coffee;
---GROUP BY ALL;

--- 6 TOTAL REVENUE PER STORE LOCATION 
SELECT
    store_location,
    SUM(transaction_qty * (CAST((REPLACE(unit_price, ',','.')) AS DECIMAL(10,2)))) AS Total_revenue 
FROM retails.sales.bright_coffee
GROUP BY ALL
ORDER BY total_revenue;


--- 7. TOTAL REVENUE BASED ON THE TIME OF THE DAY
-- first check the earliest transaction time
SELECT 
     MIN(transaction_time),
     MAX(transaction_time)
FROM retails.sales.bright_coffee;

--- Bucketing my time 
-- Morning = 06:00 - 11:59:59 
-- Afternoon =12:00 - 16:59:59 
-- Evening = 17:00 - 19:59:59 
-- Night = 20:00 - 20:59:59
 
 --- Total revenue per time bucket
SELECT 
     CASE 
          WHEN transaction_time BETWEEN '06:00:00' AND ' 11:59:59' THEN 'Morning'
          WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
          WHEN transaction_time BETWEEN '17:00:00' AND '19:59:59' THEN 'Evening'
          ELSE 'Night'
          END AS `Time_bucket`,
       SUM(transaction_qty * (CAST((REPLACE(unit_price, ',','.')) AS DECIMAL(10,2)))) AS Total_revenue
FROM retails.sales.bright_coffee
GROUP BY ALL; 

--- Number of transaction per time bucket
SELECT 
     CASE 
          WHEN transaction_time BETWEEN '06:00:00' AND ' 11:59:59' THEN 'Morning'
          WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
          WHEN transaction_time BETWEEN '17:00:00' AND '19:59:59' THEN 'Evening'
          ELSE 'Night'
          END AS `Time_bucket`,
       COUNT(transaction_id) AS Total_transactions
FROM retails.sales.bright_coffee
GROUP BY ALL; 

--- 7. Date extraction (month name, month_id, day_name)
SELECT 
     transaction_date, 
     MONTHNAME(transaction_date) AS month_name, 
     MONTH(transaction_date) AS month_number, 
     DATE_FORMAT(transaction_date, 'yyyy-MMM') AS month_id,
     DAYNAME(transaction_date) AS day_name, 
     DAYOFWEEK(transaction_date) AS week_number
FROM retails.sales.bright_coffee;

------------------------------------------------------------------------------
--- COMBINE ALL THE CODES 
SELECT 
     transaction_id,
     transaction_date,
     YEAR(transaction_date) AS year,
     MONTHNAME(transaction_date) AS month_name, 
     MONTH(transaction_date) AS month_number, 
     DATE_FORMAT(transaction_date, 'yyyy-MMM') AS month_id,
     DAYNAME(transaction_date) AS day_name, 
     DAYOFWEEK(transaction_date) AS day_number,
     product_category, 
     product_type, 
     product_detail,
     store_location,
      CASE 
          WHEN transaction_time BETWEEN '06:00:00' AND ' 11:59:59' THEN 'Morning'
          WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
          WHEN transaction_time BETWEEN '17:00:00' AND '19:59:59' THEN 'Evening'
          ELSE 'Night'
          END AS `Time_bucket`,
          COUNT(transaction_id) AS Total_transactions,
          SUM(transaction_qty) AS Total_units_sold,
          SUM(transaction_qty * (CAST((REPLACE(unit_price, ',','.')) AS DOUBLE))) AS Total_revenue
    FROM retails.sales.bright_coffee
GROUP BY ALL;       
