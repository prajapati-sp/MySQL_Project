create database SQL_Project_1;
use SQL_Project_1;
select * from `walmartsalesdata-2024`;



-- Generic Question

-- 1. How many unique cities does the data have?
select distinct(city) from `walmartsalesdata-2024`;


-- 2. In which city is each branch?
select distinct(branch), city from `walmartsalesdata-2024`;

### Product

-- 1. How many unique product lines does the data have?
select distinct(`Product line`) from `walmartsalesdata-2024`;

-- 2. What is the most common payment method?
select * from (select distinct(`Payment`), count(payment) as Common  from `walmartsalesdata-2024` group by 1) x order by common desc limit 1;

-- 3. What is the most selling product line?
select * from (select distinct(`Product line`), count(`Product line`) as Highest  from `walmartsalesdata-2024` group by 1) x order by Highest desc limit 1;

-- 4. What is the total revenue by month?
select distinct(Month), round(sum(Total)) as Total_Revenue from (select  monthname(Date) as Month,Total from  `walmartsalesdata-2024`)x group by 1 order by Month asc;

-- 5. What month had the largest COGS?
select distinct(Month), round(sum(cogs)) as highest_cogs from (select  monthname(Date) as Month,cogs from  `walmartsalesdata-2024`)x group by 1 order by highest_cogs desc limit 1 ;


-- 6. What product line had the largest revenue?
select  distinct(`Product line`),round(sum(Total)) as Revenue from  `walmartsalesdata-2024`group by 1 order by 2 desc limit 1;


-- 5. What is the city with the largest revenue?
select distinct(city),round(sum(total)) as Largest_Revenue from `walmartsalesdata-2024`group by 1 order by 2 desc limit 1;


-- 6. What product line had the largest VAT?
select  distinct(`Product line`),round(sum(`Tax 5%`)) as Highest_vat from  `walmartsalesdata-2024`group by 1 order by 2 desc limit 1;

-- 7. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

select `Product line`,
case 
when Sales>(select avg(Sales) from (select  distinct(`Product line`),round(sum(Total)) as Sales from  `walmartsalesdata-2024`group by 1 order by 2 desc)c) 
then 'Good' else 'Bad' end as Product_Line 
from
(select  distinct(`Product line`),round(sum(Total)) as Sales from  `walmartsalesdata-2024`group by 1 order by 2 desc) xx 
group by 1 ;

-- 8. Which branch sold more products than average product sold?
select * from (select distinct(Branch),count(`Product line`) as Product_sale from  `walmartsalesdata-2024` group by 1)oo 
where 
Product_sale  >(select avg(Product_sale) from(select distinct(Branch),count(`Product line`) as Product_sale from  `walmartsalesdata-2024` group by 1)xx);

-- 9. What is the most common product line by gender?
select distinct(Gender),`Product line`,count(`Product line`) as frequency from `walmartsalesdata-2024` group by 1,2 order by 2,1; 


-- 10. What is the average rating of each product line?

select * from 
(select distinct(`Product line`),round(sum(Rating)) as Rating from `walmartsalesdata-2024` group by 1)xx
where
Rating > (select round(avg(Rating)) as Average from (select distinct(`Product line`),round(sum(Rating)) as Rating from `walmartsalesdata-2024` group by 1)cc);


### Sales

-- 1. Number of sales made in each time of the day per weekday

select 
Day,
case 
when Weekname = 0 then 'Sunday' 
when Weekname = 1 then 'Monday' 
when Weekname = 2 then 'Tuesday' 
when Weekname = 3 then 'Wednesday' 
when Weekname = 4 then 'Thursday' 
when Weekname = 5 then 'Friday' 
when Weekname = 6 then 'Saturday' end as WeekName,
Hour,
Sales_Count 
from (SELECT 
    SUBSTR(Date, 9, 2) AS Day,weekday(date) as Weekname,Time AS Hour,COUNT(Total) AS Sales_Count
FROM 
    `walmartsalesdata-2024`
GROUP BY 
    1,2,3
ORDER BY 
    1,2,3)xx;


-- 2. Which of the customer types brings the most revenue?
Select distinct(`Customer type`),round(sum(total)) as Revenue FROM `walmartsalesdata-2024` group by 1 order by 2 desc limit 1;

-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
Select distinct(City),round(sum(`Tax 5%`)) as VAt FROM `walmartsalesdata-2024` group by 1 order by 2 desc limit 1;

-- 4. Which customer type pays the most in VAT?
Select distinct(`Customer type`),round(sum(`Tax 5%`)) as Revenue FROM `walmartsalesdata-2024` group by 1 order by 2 desc limit 1;

### Customer

-- 1. How many unique customer types does the data have?
Select distinct(`Customer type`) as Unique_Customer_Type, count(`Customer type`) as Data  FROM `walmartsalesdata-2024` group by 1;

-- 2. How many unique payment methods does the data have?
Select distinct(Payment) as Unique_Payment_Method , count(`Customer type`) as Data FROM `walmartsalesdata-2024` group by 1;

-- 3. What is the most common customer type?
select Most_Common_Customer_Type from (Select distinct(`Customer type`) as Most_Common_Customer_Type,count(`Customer type`) as Number_of_Customer FROM `walmartsalesdata-2024` group by 1 order by 2 desc limit 1)xx;

-- 4. Which customer type buys the most?
Select distinct(`Customer type`) as Most_Buy_Customer,count(`Invoice ID`) as Number_of_Orders FROM `walmartsalesdata-2024` group by 1 order by 2 desc limit 1;

-- 5. What is the gender of most of the customers?
Select distinct(`Gender`) as Most_Gender,count(`Customer type`) as Number_of_Orders FROM `walmartsalesdata-2024` group by 1 order by 2 desc limit 1;

-- 6. What is the gender distribution per branch?
select distinct(`Gender`),branch,count(gender) as Count FROM `walmartsalesdata-2024` group by 1,2 order by 1;

-- 7. Which time of the day do customers give most ratings?

Select Time , count(Rating) as Rating_Count  from  `walmartsalesdata-2024`group by 1 order by 2 desc limit 1 ;



-- 8. Which time of the day do customers give most ratings per branch?
Select Time , count(Rating) as Rating_Count , Branch from  `walmartsalesdata-2024`group by 1,3 order by 2 desc limit 1;

-- 9. Which day of the week has the best avg ratings?

Select Date as Day_of_Week,
round(Avg(Rating)) as  Avg_Rating
From `walmartsalesdata-2024`
Group by 1
Order By Avg_Rating Desc limit 1;


-- 10. Which day of the week has the best average ratings per branch?


Select Branch, Date as Day_of_Week,
round(Avg(Rating)) as  Avg_Rating
From `walmartsalesdata-2024`
Group by 1,2
Order By Avg_Rating Desc limit 3;



## Revenue And Profit Calculations

-- $ COGS = unitsPrice * quantity $

-- $ VAT = 5\% * COGS $

-- $VAT$ is added to the $COGS$ and this is what is billed to the customer.

-- $ total(gross_sales) = VAT + COGS $

-- $ grossProfit(grossIncome) = total(gross_sales) - COGS $

-- **Gross Margin** is gross profit expressed in percentage of the total(gross profit/revenue)

-- $ \text{Gross Margin} = \frac{\text{gross income}}{\text{total revenue}} $

-- <u>**Example with the first row in our DB:**</u>

-- **Data given:**

-- - $ \text{Unite Price} = 45.79 $
-- - $ \text{Quantity} = 7 $

-- $ COGS = 45.79 * 7 = 320.53 $

-- $ \text{VAT} = 5\% * COGS\\= 5\%  320.53 = 16.0265 $

-- $ total = VAT + COGS\\= 16.0265 + 320.53 = $336.5565$

-- $ \text{Gross Margin Percentage} = \frac{\text{gross income}}{\text{total revenue}}\\=\frac{16.0265}{336.5565} = 0.047619\\\approx 4.7619\% $


