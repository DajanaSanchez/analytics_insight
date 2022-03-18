#business objective - pull monthly trends for gsearch alongside monthly sessions, orders for all the other channels
# through 2012-11-27; 'gsearch' 'bsearch' 'socialbook'

SELECT MIN(DATE(website_sessions.created_at)) AS month_started,
       COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS gsearch_paid_sessions,
       COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END) AS bsearch_paid_sessions,
       COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END) AS organic_search_session,
       COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_sessions.website_session_id ELSE NULL END) AS direct_type_session,

       COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN orders.order_id ELSE NULL END) AS bsearch_orders,
       COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN orders.order_id ELSE NULL END) AS gsearch_orders
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
GROUP BY YEAR(website_sessions.created_at), MONTH(website_sessions.created_at);


SELECT DISTINCT (utm_source),(utm_campaign),(http_referer)
FROM website_sessions
WHERE created_at < '2012-11-27';
