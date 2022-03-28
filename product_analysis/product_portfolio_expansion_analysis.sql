#business objective - On Dec 12, 2013, we launched a third product, Birthday Bear.
#we need to run a pre-post analysis comparing the month before vs. month after in terms of session to order conversion rate, AOV, products per order, and revenue per session

#find the relevant sessions & orders
CREATE TEMPORARY TABLE order_session_per_timepd
SELECT orders.order_id, website_sessions.website_session_id,
       CASE WHEN website_sessions.created_at < '2013-12-12' THEN 'A.Pre_Birthday_Bear'
            WHEN website_sessions.created_at >= '2013-12-12' THEN 'B.Post_Birthday_Bear'
            ELSE 'check_logic'
            END AS time_period
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at > '2013-11-12' AND website_sessions.created_at < '2014-01-12';

SELECT time_period, COUNT(DISTINCT(order_session_per_timepd.order_id)) / COUNT(DISTINCT(order_session_per_timepd.website_session_id)) AS conversion_rate,
       AVG(orders.price_usd) AS aov,
       SUM(orders.items_purchased)/COUNT(orders.order_id) AS products_per_order,
       SUM(orders.price_usd)/COUNT(order_session_per_timepd.website_session_id) AS revenue_per_session
FROM order_session_per_timepd
LEFT JOIN orders
ON orders.website_session_id = order_session_per_timepd.website_session_id
GROUP BY time_period