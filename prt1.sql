SELECT * FROM sqlproject1.retail_sales_raw;
ALTER TABLE retail_sales_raw
MODIFY trsnsactions_id INT;

ALTER TABLE retail_sales_raw
ADD PRIMARY KEY (trsnsactions_id);

ALTER TABLE retail_sales_raw
MODIFY sale_date date;

ALTER TABLE retail_sales_raw
MODIFY sale_time time;

ALTER TABLE retail_sales_raw
MODIFY customer_id int;

ALTER TABLE retail_sales_raw
MODIFY category varchar(15);

ALTER TABLE retail_sales_raw
MODIFY age int;

UPDATE retail_sales_raw
SET age = NULL
WHERE TRIM(age) = '';

SET SQL_SAFE_UPDATES = 0;

SET SQL_SAFE_UPDATES = 1;

ALTER TABLE retail_sales_raw
MODIFY quantity int;

ALTER TABLE retail_sales_raw
MODIFY price_per_unit float;

ALTER TABLE retail_sales_raw
MODIFY cogs float;

ALTER TABLE retail_sales_raw
MODIFY total_sale float;

-- data exploration

-- How many sales we have
select count(*) as total_sale from retail_sales_raw

select count(distinct customer_id) from retail_sales_raw

select distinct category from retail_sales_raw6

-- Business Key Problems & Answers
-- 1. write a sql query to retrive all columns for sales made on '2022-11-05'

select * from retail_sales_raw
where sale_date= '2022-11-05'
-- 2. write sql query to retive all transactions where the category is clothing and the quantity sold 
-- is more than 10 in the month of nov-20222

SELECT *
FROM retail_sales_raw
WHERE category = 'Clothing'
  AND quantity >=4
  AND YEAR(sale_date) = 2022
  AND MONTH(sale_date) = 11;
  
  SELECT *
FROM retail_sales_raw
WHERE category = 'Clothing'
  AND quantity >=4
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
  
-- -- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.  

select category, sum(total_sale) as total_sales, count(*) as total_orders
 from retail_sales_raw
 group by category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT  category, round(AVG(age), 2) AS avg_age
FROM retail_sales_raw
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales_raw
where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in 
-- each category.

SELECT
    gender,
    category,
    COUNT(*) AS no_of_trans
FROM retail_sales_raw
GROUP BY gender, category
order by category

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT
    year,
    month,
    avg_sale
FROM (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retail_sales_raw
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) t
WHERE rnk = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT
    customer_id,
    SUM(total_sale) AS total_sale
FROM retail_sales_raw
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category,
count( distinct customer_id) no_of_customers
from retail_sales_raw
group by category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon 
-- Between 12 & 17, Evening >17)

SELECT
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS number_of_orders
FROM retail_sales_raw
GROUP BY shift;





