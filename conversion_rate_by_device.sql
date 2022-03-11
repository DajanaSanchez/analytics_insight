##pull conversion rate from session to order by device through 2012-05-11

SELECT device_type, COUNT(DISTINCT(website_sessions.website_session_id)) AS sessions, COUNT(DISTINCT(orders.order_id)) AS orders,
COUNT(DISTINCT(orders.order_id))/COUNT(DISTINCT(website_sessions.website_session_id)) AS conversion_rate
FROM website_sessions
LEFT JOIN (orders)
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-05-11'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY device_type;
