## calculate conversion rate from session to order for gsearch nonbrand
SELECT COUNT(DISTINCT(website_sessions.website_session_id)) AS sessions, COUNT(DISTINCT(orders.website_session_id)) AS orders,
COUNT(orders.website_session_id) / COUNT(website_sessions.website_session_id) AS conversion_rate
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-04-14'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand';