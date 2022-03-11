## pull all pages where customer lands and rank by entry volume, created less than 2012-06-12
## find the first pageviw for each session and then find the url that customer saw on that first pageview

CREATE TEMPORARY TABLE first_view_by_session
SELECT website_session_id, MIN(website_pageview_id) AS first_view
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY website_session_id;

SELECT website_pageviews.pageview_url, COUNT(DISTINCT(first_view_by_session.website_session_id)) AS sessions
FROM first_view_by_session
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id = first_view_by_session.first_view
GROUP BY website_pageviews.pageview_url;