#business objective - we launched a second product on Jan 6th.
#want to see monthly order volume, overall conversion rates, revenue per session, breakdown of sales by product
#time period since april 1, 2012 through april 05, 2013

SELECT MIN(DATE(website_sessions.created_at)) AS month,
       COUNT(orders.order_id) AS order_volume,
       COUNT(orders.order_id) / COUNT(website_sessions.website_session_id) AS conversion_rate,
       SUM(orders.price_usd) / COUNT(website_sessions.website_session_id)  AS revenue_per_session,
       SUM(CASE WHEN orders.primary_product_id = 1 THEN price_usd ELSE NULL END) AS product_one_sales,
       SUM(CASE WHEN orders.primary_product_id = 2 THEN price_usd ELSE NULL END) AS product_two_sales
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-04-01' AND '2013-04-05'
GROUP BY YEAR(website_sessions.created_at), MONTH(website_sessions.created_at);

SELECT DISTINCT(primary_product_id)
FROM orders;