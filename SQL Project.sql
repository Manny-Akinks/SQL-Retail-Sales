select * from retail_sales
limit 10

select count(*) from retail_sales

-- Data Exploration

-- how many sales have we?
select count(*) as Total from retail_sales

-- customer number
select count(distinct customer_id) from retail_sales

select distinct category from retail_sales

-- Data Analysis & Business key problems 

-- Write a query to retrieve all transactions where the category is 'Clothing' and the quantity is 4 and the month of Nov-2022

select * from retail_sales 
where category = 'Clothing'
	and 
	To_Char(sale_date, 'YYYY-MM') = '2022-11'
	and
	quantity = 4
alter table retail_sales
rename quantiy to quantity

--write a query to calculate total sales for each category

select category, sum(total_sale) from retail_sales
group by 1

-- avg age of customers who purchased from beauty category

select category, round(avg(age),2) from retail_sales
where category = 'Beauty'
group by 1

-- transanctions where total sale > 1000
select * from retail_sales 
where total_sale > 1000

-- transactions made by each gender in each category
select gender, category, count(*) from retail_sales
group by 1,2
order by 2

-- avg sales per month, best selling month per year
select sale_year, sale_month, average_sale, monthly_rank from
(
	SELECT
	    EXTRACT(YEAR FROM sale_date) AS sale_year,
	    EXTRACT(MONTH FROM sale_date) AS sale_month,
	    ROUND(AVG(total_sale)::numeric, 2) AS average_sale,
	    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS monthly_rank
	FROM
	    retail_sales
	GROUP BY
	    EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) as t1
where monthly_rank = 1
--order by 1,3 desc

-- top 5 customers based on highest total sales
select count(distinct customer_id) from retail_sales

SELECT
		customer_id,
	    sum(total_sale) As total_sale
	FROM
	    retail_sales
	GROUP BY
	    1
order by 2 desc
limit 5

-- unique customers who purchased items from each category 

select 
count(distinct customer_id) as unique_customers,
category
from retail_sales
group by 2

-- create each shift and number of orders

select 
sum(quantity),
case
	when sale_time <= '12:00:00' then 'Morning'
	when sale_time between '12:00:00' and '17:00:00' then 'Afternoon'
	else 'Evening'
end as Timeless
from retail_sales
group by 2

with hourly_sale
as
(
select *,
	case 
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift 
from retail_sales
)
select 
	shift,
	count(*) as total_orders 
from hourly_sale
group by shift