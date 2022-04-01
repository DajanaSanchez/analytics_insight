#business objective - pull monthly sessions to the /products page and show how the % of those sessions clicking through another page has changed over time
#also show a view of how conversion from /products to placing an order has improved


SELECT yr, mo,
       COUNT(DISTINCT(products_sessions.website_session_id)) AS products_sessions,
       COUNT(DISTINCT(CASE WHEN website_pageviews.website_pageview_id > products_sessions.website_pageview_id THEN website_pageviews.website_session_id ELSE NULL END))/COUNT(DISTINCT(products_sessions.website_session_id)) AS click_through,
       COUNT(DISTINCT orders.order_id)/(COUNT(DISTINCT products_sessions.website_session_id)) AS product_to_order_cr
FROM(
SELECT YEAR(website_pageviews.created_at) AS yr, MONTH(website_pageviews.created_at) AS mo,
       website_pageview_id,
       website_pageviews.website_session_id
FROM website_pageviews
LEFT JOIN orders
ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.pageview_url = '/products'
    GROUP BY yr, mo, website_pageview_id, website_pageviews.website_session_id) AS products_sessions

LEFT JOIN orders
ON orders.website_session_id = products_sessions.website_session_id
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = products_sessions.website_session_id
GROUP BY yr, mo;