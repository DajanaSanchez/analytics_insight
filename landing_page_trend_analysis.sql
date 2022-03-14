#business objective - pull the volume of the paid search for nonbrand traffic landing on /home and /lander -1, trended weekly since June 1st
# pull overall paid search bounce rate trended weekly
#columns: week_start_date, bounce_rate, home_sessions, lander_sessions

#find the min pageview_id for each session & total count
CREATE TEMPORARY TABLE min_pv_and_view_countss
SELECT website_sessions.website_session_id, MIN(website_pageviews.website_pageview_id) AS min_pageview_id, COUNT(website_pageviews.website_pageview_id) AS count_pageviews
FROM website_pageviews
LEFT JOIN website_sessions
ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at > '2012-06-01'
AND website_sessions.created_at < '2012-08-31'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY website_pageviews.website_session_id;

#show count by landing page and created_at
CREATE TEMPORARY TABLE sessions_w_counts_and_lander_pagess
SELECT website_pageviews.created_at AS session_created_date, website_pageviews.pageview_url AS landing_page,min_pv_and_view_countss.website_session_id, min_pv_and_view_countss.min_pageview_id, min_pv_and_view_countss.count_pageviews
FROM min_pv_and_view_countss
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id = min_pv_and_view_countss.min_pageview_id;

SELECT MIN(DATE(session_created_date)) as week_start_date,
#COUNT(DISTINCT(website_session_id)) AS total_sessions
#COUNT(DISTINCT CASE WHEN count_pageviews = 1 THEN website_session_id ELSE NULL END) AS bounced_sessions,
       COUNT(DISTINCT CASE WHEN count_pageviews = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT(website_session_id)) AS bounce_rate,
COUNT(DISTINCT CASE WHEN landing_page = '/home' THEN website_session_id ELSE NULL END) AS home_sessions,
COUNT(DISTINCT CASE WHEN landing_page = '/lander-1' THEN website_session_id ELSE NULL END) AS lander_sessions
FROM sessions_w_counts_and_lander_pagess
GROUP BY YEAR(session_created_date), WEEK(session_created_date);

