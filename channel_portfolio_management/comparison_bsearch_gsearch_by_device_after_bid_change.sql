#business objective - we bid down bsearch nonbrand on Dec 2nd.
#pull weekly session volume for gsearch & bsearch nonbrand by device since Nov 4th
# include comparison metric to show bsearch as a percent of gsearch
#through Dec 22, 2012

SELECT MIN(DATE(created_at)) AS week_start,
COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END) AS gsearch_mobile_sessions,
COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END) AS bsearch_mobile_sessions,
COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END) AS bmobile_percentof_g,
COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END) AS gsearch_desktop_sessions,
COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END) AS bsearch_desktop_sessions,
COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END) AS bdesk_percentof_g
FROM website_sessions
WHERE utm_campaign = 'nonbrand'
AND created_at > '2012-11-04'
AND created_at < '2012-12-22'
GROUP BY YEAR(created_at), WEEK(created_at)