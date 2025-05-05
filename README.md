# 🧾 Adidas Sales Analysis Project (SQL + Tableau)

This project focuses on analyzing Adidas U.S. Sales data using SQL for data cleaning, transformation, and exploratory analysis, followed by creating an interactive dashboard in Tableau for visualization and insight delivery.

---

## 📊 Dataset Overview
**Source:** Adidas U.S. Sales Dataset (structured retail sales data)  
**Format:** Table with the following key columns:
- Retailer, Retailer_ID
- Invoice Date, Region, State, City
- Product (e.g., "Men's Athletic Footwear")
- Price per Unit, Units Sold, Total Sales
- Operating Profit, Operating Margin
- Sales Method (In-Store or Outlet)

---

## 🛠️ Data Cleaning (SQL)
**Objective:** Prepare the dataset for accurate analysis and Tableau compatibility.

### Performed Tasks:
- Renamed table and cleaned column names (snake_case)
- Converted `Invoice Date` to proper `DATE` format using `STR_TO_DATE`
- Standardized financial columns by:
  - Removing `$`, `,`, and whitespace
  - Casting them into appropriate `DECIMAL` formats
- Created clean versions of key metrics:
  - `Price_per_Unit_clean`, `Units_Sold_clean`, `Total_Sales_clean`
  - `Operating_Profit_clean`, `Operating_Margin_clean`

**Result:** Clean, structured, and type-safe data stored in `adidas_sales_table`

---

## 📈 Key Business Questions + SQL Insights
### ✅ Performance Analysis
**1. Total Revenue Across All Countries**
- **Result:** Sum of `Total_Sales_clean` shows company-wide revenue

**2. Region with Highest/Lowest Profit**
- **Insight:** Region-level `Operating_Profit_clean` shows highest and lowest performing territories

**3. Sales Contribution by Region**
- **Insight:** % share of total sales per region helps evaluate market penetration

**4. Monthly Sales and Profit Trends**
- **Insight:** Revealed seasonal peaks and off-season performance per year

**5. Discounts Impact**
- **Finding:** No explicit discounts recorded; price per unit = total sales/units

**6. Top 5 Profitable Product Subcategories**
- **Insight:** Products contributing highest to bottom-line profitability

**7. Highest Sales Volume Product & Best Region**
- **Insight:** Identified top-selling product and region with most units sold

### ✨ Category & Channel Insights
**8. Revenue by Product Category**
- **Approach:** Grouped by string patterns in `Product` column

**9. Revenue by Sales Method (In-Store vs. Outlet)**
- **Insight:** Compared channel efficiency and profitability

**10. Avg Operating Margin by Product**
- **Insight:** Identified low vs. high-margin product categories

### 🌐 Regional & Temporal Trends
**11. Weekly/Monthly Revenue Trends**
- **Insight:** Seasonal behavior patterns and product launches

**12. Region Sales vs. Profit Alignment**
- **Insight:** Regions with high revenue but low profit (or vice versa) identified

### 💰 Profitability Breakdown
**13. Top Product Category by Profit Across Sales Methods**
- **Insight:** Which category generates the most operating profit regardless of channel

**14. Profit Margin by Sales Method**
- **Insight:** `In-Store` vs. `Outlet` efficiency in terms of margin %

**15. Product with Lowest Margin & Opportunity**
- **Insight:** Identified weak performer (likely high cost, low markup)

### 🎨 Product-Specific Analytics
**16. Men's Footwear Category Sales**
- **Insight:** Revenue drivers within a gender-focused segment

**17. Compare Women's Athletic vs. Street Footwear**
- **Insight:** Helped with marketing and inventory strategy

**18. Avg Units Sold per Day per Product**
- **Insight:** Product velocity metric for inventory planning

---

## 📊 Tableau Dashboard (Interactive Visualization)
You can explore the interactive dashboard hosted -https://public.tableau.com/app/profile/sanika.keshav.shinde8472/viz/AdidasSalesDashboard_17464039975940/AdidasSales

### Tableau Sheets Created:
- 📦 Units Sold Over Month per Product
- 💰 Total Profit by Product Category
- 🗺️ Total Sales by Region
- 📉 Operating Margin by Sales Method
- 🛍️ Operating Profit by Retailer and Sales Method

### Highlights:
- **Top Product:** Revealed strongest contributor to volume and revenue
- **Top Region:** Identified best-performing geographical market
- **High vs. Low Margin Products:** Helped visualize where cost-optimization or pricing changes are needed

---

## 🛠️ Tools Used
- MySQL 8.0
- Tableau Public
- GitHub for version control and documentation


