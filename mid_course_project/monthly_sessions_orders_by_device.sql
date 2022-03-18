#business objective - dive into non-brand, gsearch; pull monthly sessions, orders by device

SELECT MIN(DATE(website_sessions.created_at)) AS month_start,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN orders.order_id ELSE NULL END) AS mobile_orders,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS desktop_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN orders.order_id ELSE NULL END) AS desktop_orders
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY YEAR(website_sessions.created_at), MONTH(website_sessions.created_at);

SELECT DISTINCT(device_type)
FROM website_sessions;