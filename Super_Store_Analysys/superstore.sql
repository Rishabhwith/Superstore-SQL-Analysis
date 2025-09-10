use superstoredb;
select * from store;
-- 1. Top 10 most profitable products
SELECT product_name, SUM(profit) AS total_profit
FROM superstore
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;

-- 2. Products causing the highest losses
SELECT product_name, SUM(profit) AS total_profit
FROM superstore
GROUP BY product_name
ORDER BY total_profit ASC
LIMIT 10;

-- 3. Total Sales And Profit
SELECT SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore;

-- 4. Region wise Sales
SELECT region, SUM(sales) AS total_sales
FROM superstore
GROUP BY region;

-- 5. Region Wise Total Profit
SELECT region, SUM(profit) AS total_profit
FROM superstore
GROUP BY region;

-- 6. Sales and profit by category
SELECT category, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY category;

-- 7. Sales and profit by sub-category
SELECT sub_category, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY sub_category;

-- 8. Top 10 states by sales
SELECT state, SUM(sales) AS total_sales
FROM superstore
GROUP BY state
ORDER BY total_sales DESC
LIMIT 10;

-- 9. Bottom 10 states by profit
SELECT state, SUM(profit) AS total_profit
FROM superstore
GROUP BY state
ORDER BY total_profit ASC
LIMIT 10;

-- 10. Average discount per category
SELECT category, AVG(discount) AS avg_discount
FROM superstore
GROUP BY category;

-- 11. Average discount per sub-category
SELECT sub_category, AVG(discount) AS avg_discount
FROM superstore
GROUP BY sub_category;

-- 12. Sales contribution by region (%)
SELECT region,
       ROUND(SUM(sales) * 100.0 / (SELECT SUM(sales) FROM superstore), 2) AS sales_percentage
FROM superstore
GROUP BY region;

-- 13. Profit margin by category
SELECT category,
       ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent
FROM superstore
GROUP BY category;

-- 14. State with maximum loss
SELECT state, SUM(profit) AS total_profit
FROM superstore
GROUP BY state
ORDER BY total_profit ASC
LIMIT 1;

-- 15. Segment-wise sales
SELECT segment, SUM(sales) AS total_sales
FROM superstore
GROUP BY segment;

-- 16. Segment-wise profit
SELECT segment, SUM(profit) AS total_profit
FROM superstore
GROUP BY segment;

-- 17. Orders where discount > 0.3 OR profit < 0
SELECT *
FROM superstore
WHERE discount > 0.3 OR profit < 0;

-- 18. Cities with sales above 50,000 AND profit margin below 5%
SELECT city,
       SUM(sales) AS total_sales,
       (SUM(profit) / SUM(sales)) * 100 AS profit_margin
FROM superstore
GROUP BY city
HAVING SUM(sales) > 50000 AND (SUM(profit) / SUM(sales)) * 100 < 5;

-- 19. Most profitable category in each segment
SELECT segment, category, SUM(profit) AS total_profit
FROM superstore
GROUP BY segment, category
HAVING SUM(profit) = (
   SELECT MAX(seg_profit) FROM (
       SELECT segment AS seg, category AS cat, SUM(profit) AS seg_profit
       FROM superstore
       GROUP BY segment, category
   ) t WHERE t.seg = superstore.segment
);

-- 20. Highest discount given in any state
SELECT state, MAX(discount) AS max_discount
FROM superstore
GROUP BY state
ORDER BY max_discount DESC
LIMIT 1;

-- 21. List states whose profit is higher than the average state profit
SELECT state, SUM(profit) AS total_profit
FROM superstore
GROUP BY state
HAVING SUM(profit) > (SELECT AVG(state_profit) 
                      FROM (SELECT SUM(profit) AS state_profit 
                            FROM superstore 
                            GROUP BY state) t);

-- 22. Sub-categories where average quantity ordered > average quantity across dataset
SELECT sub_category, AVG(quantity) AS avg_quantity
FROM superstore
GROUP BY sub_category
HAVING AVG(quantity) > (SELECT AVG(quantity) FROM superstore);

-- 23. States where total discount given is above the average total discount across all states
SELECT state, SUM(discount) AS total_discount
FROM superstore
GROUP BY state
HAVING SUM(discount) > (SELECT AVG(total_discount)
                        FROM (SELECT SUM(discount) AS total_discount
                              FROM superstore
                              GROUP BY state) t);

-- 24. Find postal codes where the total quantity sold is above the average quantity of all postal codes
SELECT postal_code, SUM(quantity) AS total_quantity
FROM superstore
GROUP BY postal_code
HAVING SUM(quantity) > (SELECT AVG(total_quantity)
                        FROM (SELECT SUM(quantity) AS total_quantity
                              FROM superstore
                              GROUP BY postal_code) t);

-- 25. Analyzing Shipping Modes with Above-Average Sales using Nested Subquery
SELECT ship_mode, SUM(sales) AS total_sales
FROM superstore
GROUP BY ship_mode
HAVING SUM(sales) > (SELECT AVG(sales_by_mode)
                     FROM (SELECT ship_mode, SUM(sales) AS sales_by_mode
                           FROM superstore
                           GROUP BY ship_mode) t);

