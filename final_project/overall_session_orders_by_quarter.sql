#business objective -  want to show volume growth. pull overall session and order volume trended by quarter for life of business

SELECT YEAR(website_sessions.created_at) AS year, QUARTER(website_sessions.created_at) AS quarter, COUNT(DISTINCT(website_sessions.website_session_id)) AS sessions, COUNT(DISTINCT(orders.order_id)) AS orders
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
GROUP BY YEAR(website_sessions.created_at), QUARTER(website_sessions.created_at)
ORDER BY YEAR(website_sessions.created_at), QUARTER(website_sessions.created_at);