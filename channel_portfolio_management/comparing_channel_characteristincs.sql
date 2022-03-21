#business objective - want to learn more about bsearch nonbrand campaign
#pull percentage of traffic coming on mobile & compare that to gsearch
#aggregate data from August 22 to Nov 30

SELECT utm_source,
COUNT(DISTINCT website_session_id) AS sessions,
COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions,
COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS percent_mobile
FROM website_sessions
WHERE created_at > '2012-08-22' AND created_at < '2012-11-30'
AND utm_source IN ('bsearch', 'gsearch')
AND utm_campaign = 'nonbrand'
GROUP BY utm_source;