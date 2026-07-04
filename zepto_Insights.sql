
CREATE TABLE zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(150),
NAME VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(8,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity Inte
)

-- SAMPLE DATA
SELECT * FROM zepto
LIMIT 10;

-- COUNT OF ROWS
SELECT  COUNT(*) FROM zepto;

-- NULL VALUES
SELECT * FROM zepto 
WHERE name IS NULL
OR 
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR 
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

-- DIFFERENT PRODUCT CATEGORIES
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- PRODUCTS IN STOCK
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

-- PRODUCT NAME PRESENT MULTIPLE TIMES
SELECT name, COUNT(sku_id) AS "Number of skus"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

-- DATA CLEANING
-- product with price  = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto WHERE mrp = 0;

-- CONVERT paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto;

-- Bussiness Insights questions

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;
-- Q2. What are the products with High MRP but Out of Stock.
SELECT DISTINCT name, mrp
FROM zepto
where outOfStock = TRUE AND mrp > 300
order by mrp desc;
-- Q3. Calculate Estimated Revenue for each category.
SELECT category, 
SUM(discountedSellingPrice * availableQuantity) AS total_Revenue
FROM zepto
GROUP BY category
ORDER BY total_Revenue;
-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.

SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category , 
ROUND(AVG(discountPercent),2) AS Avg_Discount
FROM zepto
GROUP BY category
ORDER BY Avg_Discount DESC
LIMIT 5;
-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS Price_Per_Gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q7. Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'low'
	 WHEN weightInGms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
FROM zepto;

-- Q8. What is the Total Inventory Weight Per Category
SELECT category ,
SUM(weightInGms * availableQuantity) AS Total_Weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

