#business objective - for the home and lander page, show conversion funnel from the pages to the order page
#time period from Jun 19 to Jul 28
#/products, /the-original-mr-fuzzy, /cart, /shipping, /billing, /thank-you-for-your-order

CREATE TEMPORARY TABLE conversion_per_session_id
SELECT
       website_session_id,
    landing_page,
       MAX(products_page) AS products_made,
       MAX(fuzzy_page) AS fuzzy_made,
       MAX(cart_page) AS cart_made,
       MAX(shipping_page) AS shipping_made,
       MAX(billing_page) AS billing_made,
       MAX(order_page) AS order_made
FROM(

SELECT website_sessions.website_session_id, website_pageviews.pageview_url AS landing_page,
COUNT(DISTINCT(CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END)) AS products_page,
COUNT(DISTINCT(CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END)) AS fuzzy_page,
COUNT(DISTINCT (CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END)) AS cart_page,
COUNT(DISTINCT (CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END)) AS shipping_page,
COUNT(DISTINCT(CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END)) AS billing_page,
COUNT(DISTINCT(CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END)) AS order_page
FROM website_sessions
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE website_sessions.utm_source = 'gsearch'
AND website_sessions.utm_campaign = 'nonbrand'
AND website_sessions.created_at BETWEEN '2012-06-19' AND '2012-07-28'
AND website_pageviews.pageview_url IN ('/home', '/lander-1', '/products', '/the-original-mr-fuzzy', '/cart', '/shipping', '/billing', '/thank-you-for-your-order'))

AS pageview_level
GROUP BY landing_page;

SELECT landing_page,
    COUNT(DISTINCT CASE WHEN products_made = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS lander_clickthrough,
    COUNT(DISTINCT CASE WHEN fuzzy_made = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN products_made = 1 THEN website_session_id ELSE NULL END) AS products_clickthrough,
    COUNT(DISTINCT CASE WHEN cart_made = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN fuzzy_made = 1 THEN website_session_id ELSE NULL END) AS fuzzy_clickthrough,
    COUNT(DISTINCT CASE WHEN shipping_made = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN cart_made = 1 THEN website_session_id ELSE NULL END) AS cart_clickthrough,
    COUNT(DISTINCT CASE WHEN billing_made = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN shipping_made = 1 THEN website_session_id ELSE NULL END) AS shipping_clickthrough,
       COUNT(DISTINCT CASE WHEN order_made = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN billing_made = 1 THEN website_session_id ELSE NULL END) AS billing_clickthrough
FROM conversion_per_session_id
GROUP BY landing_page;

