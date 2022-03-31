#business objective - show quarterly figures since launch for session to order conversion rate, revenue per order, revenue per session

SELECT YEAR(website_sessions.created_at) AS yr, QUARTER(website_sessions.created_at) AS qtr, COUNT(DISTINCT(orders.order_id))/COUNT(DISTINCT(website_sessions.website_session_id)) AS conversion_rate, SUM(price_usd)/COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session, SUM(price_usd)/COUNT(DISTINCT orders.order_id) AS revenue_per_order
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
GROUP BY YEAR(website_sessions.created_at), QUARTER(website_sessions.created_at)
ORDER BY YEAR(website_sessions.created_at), QUARTER(website_sessions.created_at);