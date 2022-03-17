use mavenfuzzyfactory;
#business objective: we've tested a new billing page; need to see whether /billing-2 is doing any better than /billing
#what percentage of sessions on those pages end up placing an order; can run for all traffic; data through 2012-11-10

#find the first time /billing-2 was seen
SELECT created_at, pageview_url
FROM website_pageviews
WHERE pageview_url = '/billing-2'
ORDER BY created_at
#2012-09-10

#final analysis output

SELECT billing_version,
COUNT(DISTINCT website_session_id) AS sessions,
COUNT(DISTINCT order_id) AS orders,
 COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id) AS billing_to_order_rate

FROM(
SELECT website_pageviews.website_session_id, website_pageviews.pageview_url AS billing_version, orders.order_id
FROM website_pageviews
LEFT JOIN orders
ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at > '2012-09-10' AND website_pageviews.created_at < '2012-11-10'
AND website_pageviews.pageview_url IN ('/billing', '/billing-2'))

AS conversion_funnel
GROUP BY billing_version;