#gsearch visitors specifically
#build conversion funnel from lander-1 to thank you. Data between August 5th and September 5th.

#gather the session IDs and pageviews for each relevant session
# urls are lander1, products, mr.fuzzy, cart, shipping, billing, thanks for order



CREATE TEMPORARY TABLE session_made_it_flagsssss
SELECT website_session_id,
MAX(products_click) AS products_made,
MAX(fuzzy_click) AS fuzzy_made,
MAX(cart_click) AS cart_made,
MAX(shipping_click) AS shipping_made,
MAX(billing_click) AS billing_made,
MAX(order_click) AS order_made

FROM(

SELECT website_sessions.website_session_id, website_pageviews.pageview_url,
CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_click,
CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS fuzzy_click,
CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_click,
CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_click,
CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_click,
CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS order_click
FROM website_sessions
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE website_sessions.utm_source = 'gsearch'
  AND website_sessions.utm_campaign = 'nonbrand'
AND website_sessions.created_at BETWEEN '2012-08-05' AND '2012-09-05'
AND website_pageviews.pageview_url IN ('/lander-1', '/products', '/the-original-mr-fuzzy', '/cart', '/shipping', '/billing', '/thank-you-for-your-order')
ORDER BY website_sessions.website_session_id, website_sessions.created_at)

AS page_view_level
GROUP BY website_session_id;

#find amount of click throughs for each page

SELECT
COUNT(DISTINCT website_session_id) AS total_sessions,
COUNT(DISTINCT CASE WHEN products_made = 1 THEN website_session_id ELSE NULL END) AS to_products,
COUNT(DISTINCT CASE WHEN fuzzy_made = 1 THEN website_session_id ELSE NULL END) AS to_fuzzy,
COUNT(DISTINCT CASE WHEN cart_made = 1 THEN website_session_id ELSE NULL END) AS to_cart,
COUNT(DISTINCT CASE WHEN shipping_made = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
COUNT(DISTINCT CASE WHEN billing_made = 1 THEN website_session_id ELSE NULL END) as to_billing,
COUNT(DISTINCT CASE WHEN order_made = 1 THEN website_session_id ELSE NULL END) AS to_order
FROM session_made_it_flagsssss;

#find click through rate
SELECT
COUNT(DISTINCT CASE WHEN products_made = 1 THEN website_session_id ELSE NULL END) /COUNT(DISTINCT website_session_id) AS lander_clickthrough,
COUNT(DISTINCT CASE WHEN fuzzy_made = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN products_made = 1 THEN website_session_id ELSE NULL END) AS products_clickthrough,
COUNT(DISTINCT CASE WHEN cart_made = 1 THEN website_session_id ELSE NULL END)/ COUNT(DISTINCT CASE WHEN fuzzy_made = 1 THEN website_session_id ELSE NULL END) AS fuzzy_clickthrough,
COUNT(DISTINCT CASE WHEN shipping_made = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN cart_made = 1 THEN website_session_id ELSE NULL END) AS cart_clickthrough,
COUNT(DISTINCT CASE WHEN billing_made = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN shipping_made = 1 THEN website_session_id ELSE NULL END) AS shipping_clickthrough,
COUNT(DISTINCT CASE WHEN order_made = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN billing_made = 1 THEN website_session_id ELSE NULL END) AS billing_clickthrough
FROM session_made_it_flagsssss;
