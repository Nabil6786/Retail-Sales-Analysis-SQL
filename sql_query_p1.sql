```sql
-- ============================================================
-- SQL RETAIL SALES ANALYSIS - P1
-- MySQL Version
-- Dataset: Retail Sales Dataset
-- Total Records: 1,987
-- ============================================================


-- ============================================================
-- 1. CREATE DATABASE
-- ============================================================

CREATE DATABASE IF NOT EXISTS sql_project_p2;

USE sql_project_p2;


-- ============================================================
-- 2. CREATE CLEAN RETAIL SALES TABLE
-- ============================================================

DROP TABLE IF EXISTS retail_sales_clean;

CREATE TABLE retail_sales_clean
(
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);


-- ============================================================
-- 3. IMPORT DATA FROM THE ORIGINAL IMPORTED TABLE
-- ============================================================
-- The original imported table contains:
-- ï»¿transactions_id -> transaction_id
-- quantiy          -> quantity
-- sale_date        -> TEXT
-- sale_time        -> TEXT
--
-- The following query converts them into the correct format.


INSERT INTO retail_sales_clean
(
    transaction_id,
    sale_date,
    sale_time,
    customer_id,
    gender,
    age,
    category,
    quantity,
    price_per_unit,
    cogs,
    total_sale
)
SELECT
    `ï»¿transactions_id`,
    STR_TO_DATE(sale_date, '%Y-%m-%d'),
    STR_TO_DATE(sale_time, '%H:%i:%s'),
    customer_id,
    gender,
    age,
    category,
    quantiy,
    price_per_unit,
    cogs,
    total_sale
FROM `sql - retail sales analysis_utf`;


-- ============================================================
-- 4. VERIFY DATA
-- ============================================================

-- Display first 10 records

SELECT *
FROM retail_sales_clean
LIMIT 10;


-- Count total records

SELECT COUNT(*) AS total_records
FROM retail_sales_clean;


-- Check table structure

DESCRIBE retail_sales_clean;


-- ============================================================
-- 5. DATA CLEANING
-- ============================================================

-- Check for NULL transaction IDs

SELECT *
FROM retail_sales_clean
WHERE transaction_id IS NULL;


-- Check for NULL sale dates

SELECT *
FROM retail_sales_clean
WHERE sale_date IS NULL;


-- Check for NULL sale times

SELECT *
FROM retail_sales_clean
WHERE sale_time IS NULL;


-- Check for NULL values in important columns

SELECT *
FROM retail_sales_clean
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;


-- Delete records containing NULL values
-- Run only after checking the NULL results above.

DELETE FROM retail_sales_clean
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;


-- ============================================================
-- 6. DATA EXPLORATION
-- ============================================================

-- Total number of sales/transactions

SELECT COUNT(*) AS total_sales
FROM retail_sales_clean;


-- Number of unique customers

SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales_clean;


-- List of unique product categories

SELECT DISTINCT category
FROM retail_sales_clean;


-- ============================================================
-- 7. BUSINESS QUESTIONS & ANALYSIS
-- ============================================================


-- ============================================================
-- Q1. Sales made on 2022-11-05
-- ============================================================

SELECT *
FROM retail_sales_clean
WHERE sale_date = '2022-11-05';


-- ============================================================
-- Q2. Clothing sales with quantity greater than 4
--     during November 2022
-- ============================================================

SELECT *
FROM retail_sales_clean
WHERE category = 'Clothing'
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01'
  AND quantity > 4;


-- ============================================================
-- Q3. Total sales and orders for each category
-- ============================================================

SELECT
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM retail_sales_clean
GROUP BY category;


-- ============================================================
-- Q4. Average age of customers who purchased Beauty products
-- ============================================================

SELECT
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales_clean
WHERE category = 'Beauty';


-- ============================================================
-- Q5. Transactions where total sale is greater than 1000
-- ============================================================

SELECT *
FROM retail_sales_clean
WHERE total_sale > 1000;


-- ============================================================
-- Q6. Number of transactions by gender and category
-- ============================================================

SELECT
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales_clean
GROUP BY category, gender
ORDER BY category, gender;


-- ============================================================
-- Q7. Average sales for each month
-- ============================================================

SELECT
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    ROUND(AVG(total_sale), 2) AS avg_sale
FROM retail_sales_clean
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY year, avg_sale DESC;


-- ============================================================
-- Q8. Top 5 customers based on highest total sales
-- ============================================================

SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales_clean
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


-- ============================================================
-- Q9. Number of unique customers in each category
-- ============================================================

SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales_clean
GROUP BY category
ORDER BY category;


-- ============================================================
-- Q10. Number of orders by sales shift
-- ============================================================
-- Morning   : Before 12 PM
-- Afternoon : 12 PM to 5 PM
-- Evening   : After 5 PM


SELECT
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
FROM retail_sales_clean
GROUP BY shift
ORDER BY total_orders DESC;


-- ============================================================
-- END OF RETAIL SALES ANALYSIS PROJECT
-- ============================================================
```
