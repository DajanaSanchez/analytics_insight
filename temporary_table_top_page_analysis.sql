##  pull the most-viewed website pages ranked by session volume. through 2012-06-09

CREATE TEMPORARY TABLE most_viewed_pgs
SELECT website_pageview_id, pageview_url,website_session_id
       FROM website_pageviews
WHERE created_at < '2012-06-09';

SELECT pageview_url, COUNT(DISTINCT(website_session_id)) AS session_volume
FROM most_viewed_pgs
GROUP BY pageview_url
ORDER BY session_volume DESC;