#business objective - show overall session to order conversion rate trends for the same channels by quarter.
#gsearch nonbrand, bsearch nonbrand, brand search overall, organic search, direct type-in





SELECT
YEAR(website_sessions.created_at) AS yr, QUARTER(website_sessions.created_at) AS qrt,
COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) AS 'gsearch_nonbrand_conversion',
COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) AS 'bsearch_nonbrand_conversion',
COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END) AS 'brand_search_conversion',
COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END) AS 'organic_search_conversion',
COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer iS NULL THEN orders.order_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer iS NULL THEN website_sessions.website_session_id ELSE NULL END) AS 'direct_type_in'
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
GROUP BY yr, qrt;

#saw improvements in 1st quarter of 2013 for gsearch nonbrand and in the 1st quarter of 2015
# saw improvements in 1st quarter of 2013 for bsearch nonbrand  and another jump in 4th quarter 2014
#brand search has remained consistent after 4th quarter 2012
#organic search has doubled since 2012 4th quarter

SELECT DISTINCT utm_source, utm_campaign, utm_content, http_referer
FROM website_sessions;