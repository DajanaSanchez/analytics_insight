#business objective - for gsearch lander test, estimate revenue
#look at increase in CVR from test (June 19th - Jul 28th) and use nonbrand sessions & revenue since then to calculate incremental value
#Compare the new lander with the previous lander, which one makes us more money? How much more? Quantify this in terms of monthly revenue.
USE mavenfuzzyfactory;

SELECT
MIN(website_pageview_id) AS first_pv_id
FROM website_pageviews
WHERE pageview_url = '/lander-1'; #23504

CREATE TEMPORARY TABLE min_pv_per_sesh
SELECT MIN(website_pageviews.website_pageview_id) AS min_pv_id, website_sessions.website_session_id
FROM website_pageviews
INNER JOIN website_sessions
ON website_sessions.website_session_id = website_pageviews.website_session_id
AND website_sessions.utm_source = 'gsearch'
AND website_sessions.utm_campaign = 'nonbrand'
AND website_sessions.created_at < '2012-07-28'
AND website_pageviews.website_pageview_id > '23504'
GROUP BY website_sessions.website_session_id;

#find the landing page per sesh
CREATE TEMPORARY TABLE nonbrand_test_sessions_landing_pages
SELECT pageview_url, min_pv_per_sesh.website_session_id
FROM min_pv_per_sesh
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = min_pv_per_sesh.website_session_id
WHERE website_pageviews.pageview_url IN ('/home', '/lander-1');

#bring the orders page in
CREATE TEMPORARY TABLE nonbrand_test_sessions_w_orders
SELECT nonbrand_test_sessions_landing_pages.website_session_id, nonbrand_test_sessions_landing_pages.pageview_url, orders.order_id
FROM nonbrand_test_sessions_landing_pages
LEFT JOIN orders
ON orders.website_session_id = nonbrand_test_sessions_landing_pages.website_session_id;

#find the conversion rate
SELECT pageview_url, COUNT(DISTINCT website_session_id) AS sessions, COUNT(DISTINCT order_id) AS orders,
COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id) AS conversion_rate
FROM nonbrand_test_sessions_w_orders
GROUP BY pageview_url; #conversion difference - .0087

#find the most recent pageview for gsearch nonbrand where traffic was sent to home

SELECT MAX(website_sessions.website_session_id) AS most_recent_pageview_session
FROM website_sessions
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
AND pageview_url = '/home'
AND website_sessions.created_at < '2012-11-27';
#max web session id = 17145

SELECT COUNT(website_session_id) AS sessions_since_test
FROM website_sessions
WHERE utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
AND created_at < '2012-11-27'
AND website_session_id > '17145' #22972

# 22,972 * .0048  = 199.8564; 202 incremental orders since 7/29; 50 extra orders per month