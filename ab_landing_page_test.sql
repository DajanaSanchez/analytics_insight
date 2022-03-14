#business context - we ran a custom landing page in a 50/50 test against the homepage for gsearch,non brand traffic
#we need to pull bounce rates for the two groups at the time period the new custom page was getting traffic
#landing_page, total_sessions, bounced_sessions, bounce_rate

#1. We need to find when the new custom page was created / created '2012-06-19'
#2. Then do the final analysis output

use mavenfuzzyfactory;
#finding /lander-1 creation date
SELECT MIN(website_pageview_id) AS first_pageview_id, MIN(created_at) AS first_created_date
FROM website_pageviews
WHERE pageview_url = '/lander-1';

#a/b test analysis

#temporary table for first pageview analysis
CREATE TEMPORARY TABLE first_view_by_sessionsssss
SELECT website_pageviews.website_session_id, MIN(website_pageviews.website_pageview_id) AS first_view
FROM website_pageviews
INNER JOIN website_sessions
ON website_sessions.website_session_id = website_pageviews.website_session_id
AND website_sessions.created_at < '2012-07-28'
AND website_pageviews.website_pageview_id > 23504
AND utm_source = 'gsearch' AND utm_campaign = 'nonbrand'
GROUP BY website_pageviews.website_session_id;

#finding the total sessions per url
CREATE TEMPORARY TABLE total_sessions_landing_pagessss
SELECT website_pageviews.pageview_url, COUNT(DISTINCT(first_view_by_sessionsssss.website_session_id)) AS total_sessions_per_url
FROM first_view_by_sessionsssss
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id = first_view_by_sessionsssss.first_view
GROUP BY pageview_url;


#finding the bounced_sessions (where is there only one website_pageview_id for website_sessions?)
#create temporary table showing landing page per session
CREATE TEMPORARY TABLE landing_page_per_seshh
    SELECT first_view_by_sessionsssss.website_session_id, website_pageviews.pageview_url AS landing_page
FROM first_view_by_sessionsssss
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id=first_view_by_sessionsssss.first_view
WHERE website_pageviews.pageview_url = '/home' OR website_pageviews.pageview_url = '/lander-1';

## create temporary table for bounced sessions
CREATE TEMPORARY TABLE bounced_sessionss
SELECT landing_page_per_seshh.landing_page,landing_page_per_seshh.website_session_id, COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM landing_page_per_seshh
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id=landing_page_per_seshh.website_session_id
GROUP BY landing_page_per_seshh.website_session_id, landing_page_per_seshh.landing_page
HAVING COUNT(website_pageviews.website_pageview_id) = 1;

#return a table with bounced sessions
SELECT landing_page_per_seshh.landing_page, COUNT(DISTINCT(landing_page_per_seshh.website_session_id)) AS total_sessions, COUNT(DISTINCT(bounced_sessionss.website_session_id)) AS bounced_sessions,
COUNT(DISTINCT(bounced_sessionss.website_session_id))/ COUNT(DISTINCT(landing_page_per_seshh.website_session_id)) AS bounce_rate
FROM landing_page_per_seshh
LEFT JOIN bounced_sessionss
ON landing_page_per_seshh.website_session_id = bounced_sessionss.website_session_id
GROUP BY landing_page_per_seshh.landing_page;