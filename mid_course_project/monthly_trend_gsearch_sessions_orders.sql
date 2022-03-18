use mavenfuzzyfactory;
#business objective - gsearch seems to be biggest driver of business; pull monthly trends for gsearch
#sessions and orders to see growth.
#gather total sessions & total orders for month to month before 2012-11-27

SELECT MIN(DATE(orders.created_at)) AS month_start, COUNT(DISTINCT(website_sessions.website_session_id)) AS sessions, COUNT(DISTINCT(orders.order_id)) AS orders,
COUNT(DISTINCT(orders.website_session_id))/COUNT(DISTINCT(website_sessions.website_session_id)) AS order_rate
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
AND utm_source = 'gsearch'
GROUP BY YEAR(website_sessions.created_at), MONTH(website_sessions.created_at);