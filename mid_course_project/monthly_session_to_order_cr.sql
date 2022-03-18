#business objective - tell the story of website performance improvements; pull session to order conversion rates by month
# through '2012-11-27'

SELECT MIN(DATE(website_sessions.created_at)) AS month_start, COUNT(website_sessions.website_session_id) AS sessions, COUNT(orders.order_id) AS orders,
COUNT(DISTINCT(orders.order_id))/COUNT(DISTINCT(website_sessions.website_session_id)) AS session_to_order_cr
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
GROUP BY YEAR(website_sessions.created_at), MONTH(website_sessions.created_at);