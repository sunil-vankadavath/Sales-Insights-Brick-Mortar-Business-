
#inner join between transactions table and date table
SELECT sales.transactions.*,sales.date.* FROM sales.transactions inner join sales.date on sales.transactions.order_date= sales.date.date
 where sales.date.year = 2020;
 
 #sum of sales amount in year 2019
 SELECT sum(sales.transactions.sales_amount) FROM sales.transactions inner join sales.date on sales.transactions.order_date= sales.date.date
 where sales.date.year = 2019;
 
 #sum of sales in chennai
 SELECT sum(sales.transactions.sales_amount) FROM sales.transactions inner join sales.date on sales.transactions.order_date= sales.date.date
 where sales.date.year = 2019 and sales.transactions.market_code = "Mark001";
 
 #unique products from chennai
 select distinct product_code from sales.transactions where market_code = "Mark001";
 
 #Total Sales Amount
 SELECT SUM(sales_amount) AS total_sales FROM transactions;
 
 #Top 5 Customers by Sales
 SELECT c.custmer_name, SUM(t.sales_amount) AS total_spent
FROM transactions t
JOIN customers c ON t.customer_code = c.customer_code
GROUP BY c.custmer_name
ORDER BY total_spent DESC
LIMIT 5;

#Top Performing Product
SELECT p.product_code, SUM(t.sales_amount) AS total_sales
FROM transactions t
JOIN products p ON t.product_code = p.product_code
GROUP BY p.product_code
ORDER BY total_sales DESC
LIMIT 1;

# Annual growth trend.
SELECT d.year, SUM(t.sales_amount) AS total_sales,
       LAG(SUM(t.sales_amount)) OVER (ORDER BY d.year) AS previous_year_sales,
       (SUM(t.sales_amount) - LAG(SUM(t.sales_amount)) OVER (ORDER BY d.year)) / 
       LAG(SUM(t.sales_amount)) OVER (ORDER BY d.year) * 100 AS growth_percentage
FROM transactions t
JOIN date d ON t.order_date = d.date
GROUP BY d.year;

# High-demand product.
SELECT p.product_code, SUM(t.sales_qty) AS total_quantity
FROM transactions t
JOIN products p ON t.product_code = p.product_code
GROUP BY p.product_code
ORDER BY total_quantity DESC
LIMIT 1;

#Total Revenue by Product Category
SELECT p.product_code, SUM(t.sales_amount) AS total_sales
FROM transactions t
JOIN products p ON t.product_code = p.product_code
GROUP BY p.product_code;

#Zone-wise Sales
SELECT m.zone, SUM(t.sales_amount) AS total_sales
FROM transactions t
JOIN markets m ON t.markets_code = m.markets_code
GROUP BY m.zone;

# Repeat Customers
SELECT customer_code, COUNT(*) AS repeat_cus
FROM transactions
GROUP BY customer_code
HAVING COUNT(*) > 1;

#New vs Returning Customers
SELECT
  CASE WHEN order_count = 1 THEN 'New'
  ELSE 'Returning' 
  END AS customer_type,
  COUNT(*) AS customer_count
FROM (
  SELECT customer_code, COUNT(*) AS order_count
  FROM transactions
  GROUP BY customer_code
) sub
GROUP BY customer_type;


#Top 3 Markets per Year
SELECT *
FROM (
  SELECT d.year, m.markets_name, SUM(t.sales_amount) AS total_sales,
         RANK() OVER (PARTITION BY d.year ORDER BY SUM(t.sales_amount) DESC) AS rnk
  FROM transactions t
  JOIN date d ON t.order_date = d.date
  JOIN markets m ON t.market_code = m.markets_code
  GROUP BY d.year, m.markets_name
) ranked
WHERE rnk <= 3;


