SELECT DATE(created_at) AS week_start_date, COUNT(DISTINCT(website_session_id)) AS sessions
FROM website_sessions
WHERE created_at < '2012-05-12'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY YEAR(week_start_date), WEEK(week_start_date);