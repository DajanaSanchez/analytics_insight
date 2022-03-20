#business objective - quantify the impact of the billing test; analyze the lift generated from the test (Sept 10-Nov 10)
# analyze in terms of revenue per billing page session and pull # of billing page sessions for the past month to understand monthly impact
#as of Nov 27th, 2012

#find the billing pages in sessions (/billing & /billing-2) - billing 2 min ID - 53550
SELECT
MIN(website_pageview_id) AS first_pv_id
FROM website_pageviews
WHERE pageview_url = '/billing-2';

SELECT billing_page_seen,
       COUNT(DISTINCT website_session_id) AS sessions,
       SUM(price_usd)/COUNT(DISTINCT website_session_id) AS revenue_per_billing_page

FROM(
SELECT website_pageviews.website_session_id, website_pageviews.pageview_url AS billing_page_seen, orders.order_id, orders.price_usd
FROM website_pageviews
LEFT JOIN orders
ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at > '2012-09-10'
AND website_pageviews.created_at < '2012-11-10'
AND website_pageviews.pageview_url IN ('/billing', '/billing-2'))

AS revenue_per_billing
GROUP BY billing_page_seen; # LIFT OF 8.51 per billing pageview

SELECT COUNT(website_session_id) AS billing_sessions_past_month
FROM website_pageviews
WHERE created_at BETWEEN '2012-10-27' AND '2012-11-27'
AND pageview_url IN ('/billing', '/billing-2')

#total of 1,194 billing sessions in the past month
# lift - $8.51 per billing session
#value of billing test - $10,160 past month