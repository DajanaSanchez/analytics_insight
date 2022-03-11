##bid on nonbrand desktop on 2012-05-19; pull weekly trends for both desktop and mobile
##use 2012-04-15 until bid change as baseline

SELECT MIN(DATE(created_at)) AS week_start,
COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) AS desktop_sessions,
COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions
FROM website_sessions
WHERE website_sessions.created_at < '2012-06-09'
  AND website_sessions.created_at > '2012-04-15'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY
YEAR(created_at),
WEEK(created_at);
