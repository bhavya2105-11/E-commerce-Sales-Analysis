CREATE TABLE final_Data(
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    ProductID INT,
    Quantity NUMERIC,
    Discount NUMERIC,
    PaymentMethod VARCHAR(50),
    Status VARCHAR(50),
    Age NUMERIC,
    City VARCHAR(100),
    SignupDate DATE,
    CustomerSegment VARCHAR(50),
    PaymentID INT,
    PaymentDate DATE,
    PaymentStatus VARCHAR(50),
    ProductName VARCHAR(100),
    Category VARCHAR(100),
    UnitPrice NUMERIC,
    Revenue NUMERIC
);

SELECT*FROM final_Data;

---BASIC KPI's

--Total revenue, total orders, AOV aur total units sold
SELECT
	SUM(revenue) AS Total_Revenue,
	COUNT(DISTINCT Orderid) AS Total_Orders,
	ROUND(SUM(revenue)/COUNT(DISTINCT orderid),2) AS AOV,
	SUM(quantity) AS Total_Units_Sold
FROM final_Data;


--How many unique customers are there (excluding the dummy ID 999999)??
SELECT DISTINCT customerid FROM final_Data
WHERE customerid <> 999999;


--What date range does the data cover?
SELECT MIN(orderdate),
	   MAX(orderdate)
FROM final_Data;



---Time analysis---

--What is the month-wise and year-wise revenue?
SELECT TO_CHAR(orderdate, 'YYYY') AS years,
       ROUND(SUM(revenue), 2) AS revenue
FROM final_Data
GROUP BY years
ORDER BY years;

SELECT TO_CHAR(orderdate, 'MM') AS months,
       ROUND(SUM(revenue), 2) AS revenue
FROM final_Data
GROUP BY months
ORDER BY months;


--Which months had the highest and lowest revenue?
SELECT
    TO_CHAR(orderdate, 'YYYY-MM') AS months,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM final_Data
GROUP BY 1
ORDER BY total_revenue DESC;



---Product and category---

--Which are the top 10 products by revenue?
SELECT productname,
	ROUND(SUM(revenue), 2) AS total_revenue
FROM final_Data
GROUP BY productname
ORDER BY total_revenue DESC
LIMIT 10;


--What is the revenue and percentage share of each category?
SELECT category,
	ROUND(SUM(revenue),2) AS category_revenue,
	ROUND(
SUM(revenue)*100.0/
(SELECT SUM(revenue) FROM final_Data),
2) AS percentage_revenue FROM final_Data
GROUP BY category
ORDER BY category_revenue DESC;

	
--What is the best-selling product in each category (using RANK)?
SELECT category, productname,Total_units_sold
FROM(
	SELECT category,productname,
	SUM(quantity) AS total_units_sold,
           RANK() OVER (PARTITION BY category ORDER BY SUM(quantity) DESC) AS rnk
	FROM final_Data
	GROUP BY category, productname
)
WHERE rnk =1;
--///////
SELECT category, productname,Total_units
FROM(
	SELECT category,productname, SUM(quantity) AS Total_units,
RANK() OVER(PARTITION BY category ORDER BY SUM(quantity) DESC) AS rnk
FROM final_Data
GROUP BY category, productname)
where rnk = 1;


--Which products have the highest average discount?
SELECT productname,
	ROUND(AVG(discount)*100, 2) AS Avg_discount_per
FROM final_Data
GROUP BY productname
ORDER BY Avg_discount_per DESC;



---Customer and city---

--Which are the top 10 cities by revenue?
SELECT city,
	ROUND(SUM(revenue), 2) AS total_revenue
FROM final_Data
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 10;


--What are the revenue and AOV by customer segment?
SELECT customersegment,
	SUM(revenue) AS Total_Revenue,
	ROUND(SUM(revenue)/COUNT(DISTINCT orderid),2) AS AOV
FROM final_Data
GROUP BY customersegment
ORDER BY Total_Revenue DESC;


--Who are the top 10 customers by total spend?
SELECT customerid,
	ROUND(SUM(revenue), 2) AS total_revenue
FROM final_Data
WHERE customerid <> 999999
GROUP BY customerid
ORDER BY total_revenue DESC
LIMIT 10;


--How many repeat customers (2+ orders) and one-time customers are there?


--What is the revenue by age group (18-25, 26-35, 36-50, 50+)?
SELECT 
	CASE 
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        WHEN age > 50 THEN '50+'
        ELSE 'Unknown'
    END AS age_group,
	ROUND(SUM(revenue),2) AS total_revenue
FROM final_Data
GROUP BY age_group
ORDER BY age_group;

SELECT * FROM final_Data;

---Payment and orders---

--What are the orders and revenue by payment method?
SELECT paymentmethod,
	SUM(revenue) AS Total_Revenue,
	COUNT(DISTINCT Orderid) AS Total_Orders
FROM final_Data
GROUP BY paymentmethod
ORDER BY paymentmethod;

--What are the orders and revenue by discount slab (0, 5%, 10%, 20%+)?
SELECT 
	CASE 
        WHEN discount = 0 THEN 'No discount'
		WHEN discount = 0.05 THEN '5%'
		WHEN discount = 0.10 THEN '10%'
		WHEN discount = 0.15 THEN '15%'
		WHEN discount = 0.20 THEN '20%'
        ELSE '20%+'
    END AS discount_slab,
	SUM(revenue) AS Total_Revenue,
	ROUND(SUM(revenue) / COUNT(DISTINCT orderid), 2) AS aov,
	COUNT(DISTINCT Orderid) AS Total_Orders
FROM final_Data
GROUP BY discount_slab
ORDER BY MIN(discount);





