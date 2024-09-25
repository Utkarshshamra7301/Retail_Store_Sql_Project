-- SQL Retail Sales Analysis
CREATE DATABASE Retail_Store;

-- Create Table
CREATE TABLE Retail_Sales 
	(
		transactions_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(15),
		quantiy  INT, 
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
	);

SELECT * FROM Retail_sales;

SELECT COUNT(*) FROM Retail_sales;

-- Check if there is any  null Value in the dataset
SELECT * FROM Retail_Sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	category IS NULL
	OR
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR
	total_sale IS NULL;

DELETE FROM Retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	category IS NULL
	OR
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration 
-- How many record we have ? 
SELECT COUNT(*) FROM Retail_sales;

-- How many uniuque customers we have ?
SELECT COUNT(DISTINCT(customer_id)) FROM Retail_sales

-- How many categories we have ? 
SELECT DISTINCT(category) FROM Retail_sales;

-- Solve some Bussiness problems.
-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM Retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT transactions_id 
FROM Retail_sales
WHERE 
	category = 'Clothing' 
	AND quantiy > 1 
	AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
	SUM(total_sale) AS Total_sales 
		FROM Retail_sales
		GROUP BY category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	ROUND(AVG(age),2) AS avg_age
		FROM Retail_sales
		WHERE category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.


SELECT * FROM Retail_sales
WHERE total_sale >1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	gender,
	category,
	COUNT(transactions_id) 
		FROM Retail_sales
		GROUP BY gender,category;
		


	
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM 
	(SELECT 
	EXTRACT(MONTH FROM sale_date) AS month,
	EXTRACT(YEAR FROM sale_date) AS year,
	AVG(total_sale),
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC ) AS rank
	FROM Retail_sales
	GROUP BY 1,2) AS t1
	WHERE rank = 1;



-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
	customer_id,
	sum(total_sale) AS net_sale
		FROM Retail_sales
		GROUP BY customer_id
		ORDER BY 2 DESC
		LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	category,
	COUNT(DISTINCT(customer_id))
	FROM Retail_sales
	GROUP BY 1;
	

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale 
AS 
	(SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) >12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
			END AS Shift
		FROM Retail_sales)

SELECT 
	shift,
	COUNT(*)
	FROM hourly_sale
		GROUP BY shift
