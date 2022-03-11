##bid on nonbrand desktop on 2012-05-19; pull weekly trends for both desktop and mobile
##use 2012-04-15 until bid change as baseline

SELECT MIN(DATE(created_at)) AS week_start,
COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id END) AS mobile_session,
COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_session_id END) AS desktop_session
FROM website_sessions
WHERE created_at < '2012-06-09' AND created_at > '2012-04-15'
AND utm_source = 'gsearch' AND utm_campaign = 'nonbrand'
GROUP BY
YEAR(created_at),
WEEK(created_at);

