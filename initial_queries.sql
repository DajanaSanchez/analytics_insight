## bid down on 2012-04-15; pull gsearch nonbrand trended session volume by week
## emailed on 2012-05-10

SELECT DATE(created_at) AS week_start_date, COUNT(DISTINCT(website_session_id)) AS sessions
FROM website_sessions
WHERE created_at < '2012-10-05'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY YEAR(week_start_date), WEEK(week_start_date);