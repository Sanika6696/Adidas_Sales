
-- Cleaning Data

SELECT * FROM adidas_sales.`adidas us sales datasets`;
Rename table adidas_sales.`adidas us sales datasets` to adidas_sales.adidas_sales_table;

Select * from adidas_sales.adidas_sales_table limit 5;

-- ALTER TABLE adidas_sales.adidas_sales_table 
-- CHANGE `Invoice Date` Invoice_Date DATETIME; 

describe adidas_sales.adidas_sales_table;


ALTER TABLE adidas_sales.adidas_sales_table ADD COLUMN Invoice_Date_Parsed DATE;

UPDATE adidas_sales.adidas_sales_table
SET Invoice_Date_Parsed = STR_TO_DATE(`Invoice Date`, '%m/%d/%Y');

ALTER TABLE adidas_sales.adidas_sales_table RENAME COLUMN Invoice_Date_Parsed TO New_Invoice_Date;

ALTER TABLE adidas_sales.adidas_sales_table
RENAME COLUMN `Retailer ID` TO `Retailer_ID`;


ALTER TABLE adidas_sales.adidas_sales_table 
CHANGE `Price per Unit` Price_per_Unit DECIMAL(10,2),
CHANGE `Units Sold` Units_Sold DECIMAL(10,2),
CHANGE `Total Sales` Total_Sales DECIMAL(10,2),
CHANGE `Operating Profit` Operating_Profit DECIMAL(10,2),
CHANGE `Operating Margin` Operating_Margin DECIMAL(5,2),
CHANGE `Sales Method` Sales_Method VARCHAR(50);
 

ALTER TABLE adidas_sales.adidas_sales_table
  ADD COLUMN Units_Sold_clean DECIMAL(10,2),
  ADD COLUMN Price_per_Unit_clean DECIMAL(10,2),
  ADD COLUMN Total_Sales_clean DECIMAL(10,2),
  ADD COLUMN Operating_Profit_clean DECIMAL(10,2),
  ADD COLUMN Operating_Margin_clean DECIMAL(5,2);


Select * from adidas_sales.adidas_sales_table limit 5;

UPDATE adidas_sales.adidas_sales_table
SET Units_Sold_clean = CAST(
  NULLIF(
    REPLACE(REPLACE(REPLACE(TRIM(`Units Sold`), '$', ''), ',', ''), ' ', ''),
    ''
  ) AS DECIMAL(10,2)
);


UPDATE adidas_sales.adidas_sales_table
SET Price_per_Unit_clean = CAST(
  NULLIF(
    REPLACE(REPLACE(REPLACE(TRIM(`Price per Unit`), '$', ''), ',', ''), ' ', ''),
    ''
  ) AS DECIMAL(10,2)
);


UPDATE adidas_sales.adidas_sales_table
SET Total_Sales_clean = CAST(
  NULLIF(
    REPLACE(REPLACE(REPLACE(TRIM(`Total Sales`), '$', ''), ',', ''), ' ', ''),
    ''
  ) AS DECIMAL(10,2)
);


UPDATE adidas_sales.adidas_sales_table
SET Operating_Profit_clean = CAST(
  NULLIF(
    REPLACE(REPLACE(REPLACE(TRIM(`Operating Profit`), '$', ''), ',', ''), ' ', ''),
    ''
  ) AS DECIMAL(10,2)
);


UPDATE adidas_sales.adidas_sales_table
SET Operating_Margin_clean = CAST(
  NULLIF(
    REPLACE(REPLACE(REPLACE(TRIM(`Operating Margin`), '$', ''), ',', ''), ' ', ''),
    ''
  ) AS DECIMAL(5,2)
);


ALTER TABLE adidas_sales.adidas_sales_table
  RENAME COLUMN `Sales Method` TO Sales_Method;

Select * from adidas_sales.adidas_sales_table limit 5;

SELECT * FROM adidas_sales.adidas_sales_table;


-- Cleaning Done

-- Starting Exploration

-- Checking Data types
describe adidas_sales.adidas_sales_table;

Select * from adidas_sales.adidas_sales_table limit 5;

-- 1. What is the total sales revenue across all countries?
Select SUM(Total_Sales_clean) AS Total_Revenue 
from adidas_sales.adidas_sales_table;

-- 2. Which region generates the highest profit, and which has the lowest?

Select Region, SUM(Operating_Profit_clean) AS total_profit
FROM adidas_sales.adidas_sales_table
GROUP BY Region
ORDER BY total_profit DESC; 


-- Highest Profit
Select Region, SUM(Operating_Profit_clean) AS total_profit
FROM adidas_sales.adidas_sales_table
GROUP BY Region
ORDER BY total_profit DESC
limit 1; 

-- Lowest Profit
Select Region, SUM(Operating_Profit_clean) AS total_profit
FROM adidas_sales.adidas_sales_table
GROUP BY Region
ORDER BY total_profit ASC
limit 1; 

-- 3. What is the sales contribution (%) of each market?
Select Region,
Sum(Total_Sales_clean) as Region_Sales,
Round(sum(Total_Sales_clean) * 100 / (SELECT SUM(Total_Sales_clean) FROM adidas_sales_table), 2) AS sales_contribution 
FROM adidas_sales.adidas_sales_table
GROUP BY Region;


-- 4. How do monthly sales and profits vary across the year?

Select monthname(New_Invoice_Date) as sale_month,
extract(Year from New_Invoice_Date) as sale_year, 
sum(Total_Sales_clean) as monthly_sales,
sum(Operating_Profit_clean) as monthly_profit
from adidas_sales_table
group by sale_year, sale_month
order by sale_year, sale_month;

-- 5. Which months show the highest discounts given, and how does this impact profit?

SELECT 
  Price_per_Unit_clean, 
  Units_Sold_clean, 
  Total_Sales_clean,
  ROUND(Price_per_Unit_clean * Units_Sold_clean, 2) AS derived_total_price
FROM adidas_sales_table;

-- No discount values were present in the dataset. 
-- Price per unit and total sales matched exactly, indicating that discounts were either not applied or already baked into the reported price.

-- 6. What are the top 5 most profitable product subcategories?

Select Product, 
sum(Operating_Profit_clean) as Profit
from adidas_sales_table
group by Product
order by Profit desc
limit 5;


-- 7. Which product has the highest sales volume, and in which market is it sold the most?

-- For just 1 product
Select Product,
sum(Units_sold_clean) as units, Region
from adidas_sales_table
group by Product, Region
order by units desc
limit 1;

-- For top selling product and the units sold in each region for it. 
WITH top_product AS (
  SELECT Product, SUM(Units_Sold_clean) AS total_units
  FROM adidas_sales_table
  GROUP BY Product
  ORDER BY total_units DESC
  LIMIT 1
)
SELECT 
  a.Product, 
  Region, 
  SUM(Units_Sold_clean) AS units_in_region
FROM adidas_sales_table a
JOIN top_product t ON a.Product = t.Product
GROUP BY a.Product, Region
ORDER BY units_in_region DESC;

-- 8. What is the total revenue generated by each product category (e.g., Men's Street Footwear, Women's Apparel)?
SELECT Product,
       SUM(Operating_Profit_clean) AS Total_Profit
FROM adidas_sales_table
GROUP BY Product
ORDER BY Total_Profit DESC;


-- 9. Which sales method (In-store vs. Outlet) generates the highest revenue across all products?

Select Sales_Method,
sum(Operating_Profit_clean) as Total_Profit
from adidas_sales_table
group by Sales_Method
order by Total_Profit desc;

-- 10. What is the average operating margin across all product categories?

Select Product,
avg(Operating_Margin_clean) as Margin
from adidas_sales_table
group by Product
order by Margin;

-- 11. How does the total revenue change across different weeks or months?

Select Product, sum(Operating_Profit_clean) as Profit,
monthname(New_Invoice_Date) as Month,
extract(Year from New_Invoice_Date) as Year
from adidas_sales_table
group by Product, Year, Month
order by Profit, Year, Month;

-- 12. Which region contributes the most to the total sales, and does it align with the highest profitability?
Select Region, 
sum(Total_Sales_clean) as Total_Sales,
sum(Operating_Profit_clean) as Total_Profit
from adidas_sales_table
group by region
order by Total_Sales, Total_Profit; 

-- 13. Which product category has the highest operating profit across both sales methods?
Select Product, 
SUM(Operating_Profit_clean) as Total_Profit,
Sales_Method
from adidas_sales_table
group by Product, Sales_Method
order by Total_Profit desc;

-- 14. What is the average profit margin for products sold via In-store vs. Outlet methods?
Select Sales_Method,
ROUND(SUM(Operating_Profit_clean) * 100 / SUM(Total_Sales_clean), 2) as Profit_Margin_pct
from adidas_sales_table
where Sales_Method = 'In-Store' or Sales_Method = 'Outlet'
group by Sales_Method
order by Profit_Margin_pct desc;

-- 15. Which product had the lowest operating margin, and how can this be improved?

Select Product,
avg(Operating_Margin_clean) as Margin
from adidas_sales_table
group by Product
order by Margin
limit 1;

-- 16. What is the total revenue generated from each product in the Men's Footwear category?

Select Product,
SUM(Total_Sales_clean) as Total_Sales
from adidas_sales_table
where Product like 'Men\'s %Footwear'
group by Product;

-- 17. How does the performance of Women's Athletic Footwear compare to Women's Street Footwear in terms of sales and profit?

Select Product,
SUM(Total_Sales_clean) as Total_Sales,
SUM(Operating_Profit_clean) as Profit
from adidas_sales_table
where Product like 'Women\'s %Footwear'
group by Product;

-- 18. What is the average units sold per day for each product category?
Select Product,
avg(Units_Sold_clean) as Avg_Units_Sold,
New_Invoice_Date as Daily
from adidas_sales_table
group by Product, Daily
order by Avg_Units_Sold desc;


 














