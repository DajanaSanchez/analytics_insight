#business objective - want to look at 2012's monthly and weekly volume patterns - pull session volume & order volume

#monthly breakdown
SELECT MIN(DATE(website_sessions.created_at)) AS month,
       COUNT(website_sessions.website_session_id) AS sessions,
COUNT(DISTINCT(order_id)) AS orders
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at <'2013-01-01'
GROUP BY YEAR(website_sessions.created_at), MONTH(website_sessions.created_at);

#weekly breakdown
SELECT MIN(DATE(website_sessions.created_at)) AS week,
       COUNT(website_sessions.website_session_id) AS sessions,
COUNT(DISTINCT(order_id)) AS orders
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at <'2013-01-01'
GROUP BY YEAR(website_sessions.created_at), WEEK(website_sessions.created_at)