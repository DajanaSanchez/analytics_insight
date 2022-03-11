#Business Context: we want to see landing page performance for a certain period of time
#Step 1 - find the first pageview for relevant sessions
#Step 2 - identify the landing page of each session
#Step 3 - count the pageviews for each session to identify bounces
#Step 4 - summarize total sessions & bounced sessions by landing page

#finding the minimum website pageview id associated with each session
SELECT website_pageviews.website_session_id, MIN(website_pageviews.website_pageview_id) AS min_page_view_id
FROM website_pageviews
INNER JOIN website_sessions
ON website_sessions.website_session_id = website_pageviews.website_session_id
AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY website_pageviews.website_session_id;

#same query as above but we are storing dataset as a temporary table

CREATE TEMPORARY TABLE first_pageviews_demo
SELECT website_pageviews.website_session_id, MIN(website_pageviews.website_pageview_id) AS min_page_view_id
FROM website_pageviews
INNER JOIN website_sessions
ON website_sessions.website_session_id = website_pageviews.website_session_id
AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY website_pageviews.website_session_id;
#next, we'll bring in the landing page to each session
CREATE TEMPORARY TABLE sessions_with_landing_pagess
SELECT first_pageviews_demo.website_session_id, website_pageviews.pageview_url AS landing_page
FROM first_pageviews_demo
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id = first_pageviews_demo.min_page_view_id; #website pageview is the landing page

#next, we make a table to include a count of pageviews per session

SELECT sessions_with_landing_pagess.website_session_id, sessions_with_landing_pagess.landing_page,
COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM sessions_with_landing_pagess
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = sessions_with_landing_pagess.website_session_id
GROUP BY sessions_with_landing_pagess.website_session_id, sessions_with_landing_pagess.landing_page
HAVING COUNT(website_pageviews.website_pageview_id) = 1;

CREATE TEMPORARY TABLE bounced_sessions_only
SELECT sessions_with_landing_pagess.website_session_id, sessions_with_landing_pagess.landing_page,
COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM sessions_with_landing_pagess
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = sessions_with_landing_pagess.website_session_id
GROUP BY sessions_with_landing_pagess.website_session_id, sessions_with_landing_pagess.landing_page
HAVING COUNT(website_pageviews.website_pageview_id) = 1;

#returning a table with bounced sessions per landing page & session

SELECT sessions_with_landing_pagess.landing_page,
       sessions_with_landing_pagess.website_session_id,
       bounced_sessions_only.website_session_id AS bounced_website_session_id
FROM sessions_with_landing_pagess
LEFT JOIN bounced_sessions_only
ON sessions_with_landing_pagess.website_session_id = bounced_sessions_only.website_session_id
ORDER BY sessions_with_landing_pagess.website_session_id;

# final output - we will use the same query we previously ran, and run a count of records.
# we will group by landing page, and then we'll add a bounce rate column

SELECT sessions_with_landing_pagess.landing_page,
      COUNT(DISTINCT(sessions_with_landing_pagess.website_session_id)) AS sessions,
     COUNT(DISTINCT(bounced_sessions_only.website_session_id)) AS bounced_sessions,
COUNT(DISTINCT(bounced_sessions_only.website_session_id))/COUNT(DISTINCT(sessions_with_landing_pagess.website_session_id)) AS bounce_rate
FROM sessions_with_landing_pagess
LEFT JOIN bounced_sessions_only
ON sessions_with_landing_pagess.website_session_id = bounced_sessions_only.website_session_id
GROUP BY sessions_with_landing_pagess.landing_page
ORDER BY sessions_with_landing_pagess.website_session_id DESC;