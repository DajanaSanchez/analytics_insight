
#Business Context: all traffic is landing on homepage; want to check how homepage is performing
# pull bounce rates for traffic landing on homepage: want to see sessions, bounced sessions, and % of sessions which bounced(bounce_rate)

#1: need to pull the count of homepage landing sessions (# of sessions, where page_view = '/home'
#2: need to pull total count of bounced_sessions of homepage (COUNT =1)
#3: need to calculate the bounce rate of homepage

# find the minimum website pageview id associated with each session
SELECT website_pageviews.website_session_id, MIN(website_pageviews.website_pageview_id) AS first_pageview_id
FROM website_pageviews
         INNER JOIN website_sessions
                    ON website_pageviews.website_session_id = website_sessions.website_session_id
                        AND website_sessions.created_at < '2012-06-14'
WHERE pageview_url = '/home'
GROUP BY website_pageviews.website_session_id;

# create the temporary table for first pageview
CREATE TEMPORARY TABLE first_pv_demoss
SELECT website_pageviews.website_session_id, MIN(website_pageviews.website_pageview_id) AS first_pageview_id
FROM website_pageviews
         INNER JOIN website_sessions
                    ON website_pageviews.website_session_id = website_sessions.website_session_id
                        AND website_sessions.created_at < '2012-06-14'
GROUP BY website_pageviews.website_session_id;

#want to create temporary table showing the landing page per session_id
CREATE TEMPORARY TABLE landing_page_seshhhh
SELECT first_pv_demoss.website_session_id, website_pageviews.pageview_url AS landing_page
FROM first_pv_demoss
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id = first_pv_demoss.first_pageview_id
WHERE website_pageviews.pageview_url = '/home';

#next we want to include the total count of sessions for home page
CREATE TEMPORARY TABLE total_home_sesh
    SELECT landing_page_seshhhh.landing_page, website_pageviews.website_pageview_id, COUNT(landing_page_seshhhh.website_session_id) AS total_sessions
FROM landing_page_seshhhh
    LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = landing_page_seshhhh.website_session_id
WHERE website_pageviews.pageview_url = '/home';

#create temporary table for bounced sessions only
CREATE TEMPORARY TABLE bounced_sessions
SELECT landing_page_seshhhh.website_session_id, landing_page_seshhhh.landing_page, COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM landing_page_seshhhh
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = landing_page_seshhhh.website_session_id
GROUP BY landing_page_seshhhh.website_session_id, landing_page_seshhhh.landing_page, landing_page_seshhhh.landing_page
HAVING COUNT(website_pageviews.website_pageview_id) = 1;
#return a table with bounced sessions
SELECT COUNT(DISTINCT(landing_page_seshhhh.website_session_id)) AS sessions, COUNT(DISTINCT(bounced_sessions.website_session_id)) AS bounced_session,
       COUNT(DISTINCT(bounced_sessions.website_session_id)) / COUNT(DISTINCT(landing_page_seshhhh.website_session_id)) AS bounced_rate
FROM landing_page_seshhhh
LEFT JOIN bounced_sessions
ON landing_page_seshhhh.website_session_id = bounced_sessions.website_session_id
ORDER BY landing_page_seshhhh.website_session_id;

