#business objective - we're wondering if bsearch nonbrand should have the same bids as gsearch.
# pull nonbrand conversion rates from session to order for gsearch & bsearch and slice data by device type
# analyze data from August 22 to Sept 18


SELECT device_type, utm_source,
       COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
       COUNT(DISTINCT order_id) AS orders,
       COUNT(DISTINCT order_id)/ COUNT(DISTINCT website_sessions.website_session_id) AS conversion_rate
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-08-22' AND '2012-09-19'
AND utm_campaign = 'nonbrand'
GROUP BY device_type, utm_source;
