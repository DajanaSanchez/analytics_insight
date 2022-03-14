#business context - we ran a custom landing page in a 50/50 test against the homepage for gsearch,non brand traffic
#we need to pull bounce rates for the two groups at the time period the new custom page was getting traffic
#landing_page, total_sessions, bounced_sessions, bounce_rate

#1. We need to find when the new custom page was created / created '2012-06-19'
#2. Then do the final analysis output

##finding /lander-1 creation date
SELECT MIN(website_pageview_id) AS first_pageview_id, MIN(created_at) AS first_created_date
FROM website_pageviews
WHERE pageview_url = '/lander-1'
AND created_at IS NOT NULL;

#ab test analysis
#first view analysis (find min pageview_id for each session)
SELECT website_pageviews.website_session_id, MIN(website_pageviews.website_pageview_id) AS first_page_view
FROM website_pageviews
INNER JOIN website_sessions
ON website_sessions.website_session_id = website_pageviews.website_session_id
AND website_sessions.created_at < '2012-07-28'
AND website_pageviews.website_pageview_id > 23504
AND utm_source = 'gsearch' AND utm_campaign = 'nonbrand'
GROUP BY website_pageviews.website_session_id;

#create temporary table for minimum pageview_id for sessions
CREATE TEMPORARY TABLE first_pv_each_seshh
SELECT website_pageviews.website_session_id, MIN(website_pageviews.website_pageview_id) AS first_page_view
FROM website_pageviews
INNER JOIN website_sessions
ON website_sessions.website_session_id = website_pageviews.website_session_id
AND website_sessions.created_at < '2012-07-28'
AND website_pageviews.website_pageview_id > 23504
AND utm_source = 'gsearch' AND utm_campaign = 'nonbrand'
GROUP BY website_pageviews.website_session_id;

#show landing page per session_id
CREATE TEMPORARY TABLE landing_page_per_sesh_nonbrand
SELECT first_pv_each_seshh.website_session_id, website_pageviews.pageview_url AS landing_page
FROM first_pv_each_seshh
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id = first_pv_each_seshh.first_page_view
WHERE website_pageviews.pageview_url = '/home' OR website_pageviews.pageview_url = '/lander-1';

#create bounced_sessions
CREATE TEMPORARY TABLE nonbrand_bounced_sessions
SELECT landing_page_per_sesh_nonbrand.landing_page, landing_page_per_sesh_nonbrand.website_session_id, COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM landing_page_per_sesh_nonbrand
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = landing_page_per_sesh_nonbrand.website_session_id
GROUP BY landing_page_per_sesh_nonbrand.website_session_id, landing_page_per_sesh_nonbrand.landing_page
HAVING COUNT(website_pageviews.website_pageview_id) = 1;

#find total count of bounced sessions & non-bounced sessions, bounce_rate
SELECT landing_page_per_sesh_nonbrand.landing_page, COUNT(DISTINCT landing_page_per_sesh_nonbrand.website_session_id) AS sessions, COUNT(DISTINCT nonbrand_bounced_sessions.website_session_id) AS bounced_sessions,
COUNT(DISTINCT nonbrand_bounced_sessions.website_session_id)/COUNT(DISTINCT landing_page_per_sesh_nonbrand.website_session_id) AS bounce_rate
FROM landing_page_per_sesh_nonbrand
LEFT JOIN nonbrand_bounced_sessions
ON nonbrand_bounced_sessions.website_session_id = landing_page_per_sesh_nonbrand.website_session_id
GROUP BY landing_page_per_sesh_nonbrand.landing_page;


