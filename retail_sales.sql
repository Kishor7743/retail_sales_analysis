select * from public.retail_sales
order by transactions_id asc
limit 100;

--Data Cleaning:
select * from retail_sales
where quantity IS NULL
      OR
	  transactions_id is null
	  or
	  sale_date is null
	  or
	  sale_time is null
	  or
	  customer_id is null
	  or
	  gender is null
	  or
	  age is null
	  or
	  category is null
	  or
	  quantity is null
	  or
	  price_per_unit is null
	  or
	  cogs is null
	  or
	  total_sale is null;

DELETE from retail_sales
where quantity IS NULL
      OR
	  transactions_id is null
	  or
	  sale_date is null
	  or
	  sale_time is null
	  or
	  customer_id is null
	  or
	  gender is null
	  or
	  age is null
	  or
	  category is null
	  or
	  quantity is null
	  or
	  price_per_unit is null
	  or
	  cogs is null
	  or
	  total_sale is null;
	  
select * from retail_sales;

--Data Exploration:
--How many sales we have?
select count(*) as total_sale
from retail_sales;
--How many unique customers we have?
select count(distinct customer_id) as customers
from retail_sales;
--Which product categories do we have?
select distinct category
from retail_sales;

--Data Analysis & Business Key Problems & Solutions:
--Write a query to retrieve all columns for sales made on '2022-11-05'?
select * from retail_sales
where sale_date = '2022-11-05';
--Write a sql query to retrieve all transactions where the category is 'Clothing' and quantity sold is more than or equal to 4 in the month of Nov-2022?
select transactions_id, sale_date, quantity, category
from retail_sales
where category = 'Clothing'
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND quantity >= 4;
--Write query to calculate total sales for each category?
select sum(total_sale) as total_sales, category, count(*) as total_orders 
from retail_sales
group by category;
--Write query to find the average age of the customers who purchased the items from 'Beauty' category?
select round(avg(age)) as average_age
from retail_sales
where category = 'Beauty'
--Write a query to find all transactions where total_sale is greater than 1000?
select transactions_id, total_sale
from retail_sales
where total_sale > 1000
--Write a query to find total number of transactions made by each gender in each category?
select count(*) as total_transactions, gender, category
from retail_sales
group by 2,3
order by 3;
--Write a query to calculate a average sale for each month. Find out the best selling month in each year?
select year, month, avg_sales from (select extract(YEAR from sale_date) as year,
extract(MONTH from sale_date) as month,
avg(total_sale) as avg_sales,
rank() over(partition by extract(YEAR from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1, 2)
where rank = 1;
--Write a query to find top 5 customers based on the highest total sales?
select customer_id, sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by total_sales desc
limit 5;
--Write a query to find the number of unique customers who purchased items from each category?
select count(distinct(customer_id)) as no_of_unique_customers, category
from retail_sales
group by category;
--Write a query to create shift and number of orders (Example: Morning <= 12, Afternoon Between 12 & 17 Evening > 17)?
WITH hourly_sales as(
select *,
CASE
When extract(HOUR from sale_time) < 12 Then 'Morning'
When extract(HOUR from sale_time) BETWEEN 12 AND 17 Then 'Afternoon'
Else 'Evening'
END as shift
from retail_sales)
select count(*) as total_orders, shift
from hourly_sales
group by shift;