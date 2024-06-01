create database if not exists WalmartSales;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);


-- ------------------------------ Feature Engineering -------------------------------------------------

-- time of the day --------------------

select time,
	(
    case
    when `time` between '00:00:00' and '12:00:00' then 'Morning'
    when `time` between '12:00:01' and '16:00:00' then 'Afternoon'
    else 'Evening'
    end
    ) as time_of_day
from sales;


alter table sales add column time_of_day varchar(20);


update sales
set time_of_day=(
case
    when `time` between '00:00:00' and '12:00:00' then 'Morning'
    when `time` between '12:00:01' and '16:00:00' then 'Afternoon'
    else 'Evening'
    end
    )

-- Adding day_name ------------------------------------------------------

select date dayname(date) as day_time
 from sales;

alter table sales add column day_name varchar(10);

update sales 
set day_name=dayname(date);


-- Adding month_name ------------------------------------------------------

select date,
 monthname(date) as month_name
 from sales;

alter table sales add column month_name varchar(20);


update sales 
set month_name=monthname(date);

-- -----------------------------Generic questions-----------------------------------------------

-- How many unique cities

select distinct(city) from sales;

-- which city is each branch

select distinct(branch) from sales;

select distinct city, branch from sales;

-- ---------------------------------product questions-------------------------------------------------------------

-- 1.How many unique product

select count(distinct product_line) as total_products from sales

-- 2.common payment method

select 
payment,
count(payment)  as cnt from sales
group by payment
order by cnt desc
;


-- 3. most selling product

select 
product_line,
count(product_line) as pro_cnt
from sales
group by product_line
order by pro_cnt desc
;


-- 4. total revenue by month

select 
month_name as month,
sum(total) as total_revenue
 from sales
 group by month_name
 order by total_revenue desc;
 
 -- 5. what month had the largest cost of goods sold
 
 select 
 month_name as month,
 sum(cogs) as COGS
 from sales
 group by month
 order by COGS desc;
 
 
 -- 6.which product_line had largest revenue
 
 select 
 product_line as product,
 sum(total) as total_revenue
 from sales
 group by product
 order by total_revenue desc
 ;
 
 -- 7.which city had largest revenue
 
 select 
 city ,
 branch,
 sum(total) as total_revenue
 from sales
 group by city,branch
 order by total_revenue desc
 ;
 
 
 -- 8.which product_line had largest VAT
 
 select
 product_line,
 avg(tax_pct) as avg_tax
 from sales
 group by product_line
 order by avg_tax desc
 ;
 
 -- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
 
 
 
 -- 10.which branch sold products than average products
 
 select
 branch,
 sum(quantity) as qty
 from sales
 group by branch
 having sum(quantity)>(select avg(quantity) from sales);
 
 -- 11.what is the most common product_line of gender
 
 select 
 gender,
 product_line,
 count(gender) as total_cnt
 from sales
 group by gender,product_line
 order by total_cnt desc;
 
 -- 12.what is the average rating of each product_line
 
 select
 round(avg(rating),2) as rating_cnt,
 product_line
 from sales
 group by product_line
 order by rating_cnt desc;
 
 
 
 -- --------------------------Sales analysis-----------------------------------
 
 -- 1.Number of sales made in each time of the day per weekday-------------------
 
 select
 time_of_day,
 count(*) as total_sales
 from sales
 where day_name="sunday"
 group by time_of_day
 order by total_sales desc
 ;
 
 -- 2.Which of the customer types brings the most revenue-------------------------------
 
select 
customer_type,
sum(total) as total_rev
from sales
group by customer_type
order by total_rev desc

 
-- 3.Which city has the largest tax percent/ VAT (Value Added Tax)-----------------------

select 
city ,
round(avg(tax_pct),2) as VAT
from sales
group by city
order by VAT desc

-- 4.Which customer type pays the most in VAT-----------------------------------------

select
customer_type,
avg(tax_pct) as customer_tax
from sales
group by customer_type
order by customer_tax desc

-- -------------------------------------Customer Analysis------------------------------------------------

-- 1.How many unique customer types does the data have?--------------------------------------------------

select
distinct customer_type 
from sales


-- 2.How many unique payment methods does the data have--------------------------------------------------

select
distinct payment
from sales


-- 3.What is the most common customer type--------------------------------------------------

select
customer_type,
count(*) as count
from sales
group by customer_type
order by count desc


-- 4.Which customer type buys the most--------------------------------------------------

select 
customer_type,
count(*) as custm_cnt
from sales
group by customer_type
order by custm_cnt desc
;

-- 5.What is the gender of most of the customers-----------------------------------------

select 
gender,
count(*) as custm_gender
from sales
group by gender
order by custm_gender desc

-- 6.What is the gender distribution per branch------------------------------------------

select
gender,
count(*) as gender_cnt
from sales
where branch="B"
group by gender
order by gender_cnt desc

-- 7.Which time of the day do customers give most ratings--------------------------------

select 
time_of_day,
avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc

-- 8.Which time of the day do customers give most ratings per branch---------------------

select 
time_of_day,
avg(rating) as avg_rating
from sales
where branch="A"
group by time_of_day
order by avg_rating desc

-- 9.Which day of the week has the best avg ratings--------------------------------------

select
 day_name,
 avg(rating) as day_rtg
 from sales
 group by day_name
 order by day_rtg desc

-- 10.Which day of the week has the best average ratings per branch----------------------

select 
day_name,
avg(rating) as day_rating
from sales
where branch="A"
group by day_name
order by day_rating desc






 