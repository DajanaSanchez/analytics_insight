#business objective - On Sept 25th, we started giving customers the option to add a second product while on the /cart page.
#we need to compare the month before vs the month after the change.
#want to see CTR from the /cart page, AVG products per order, Avg order value, revenue per /cart pageview

#1. Need to find the relevant sessions for order pageviews
#2. Need to find the count of next pageview that occurs after the cart for each session
#3. Need to find the average products per order as well as the value and revenue per cart session

#find the sessions and pageview ids for /cart
CREATE TEMPORARY TABLE session_pageviews
SELECT website_session_id, pageview_url, website_pageview_id,
CASE
WHEN created_at < '2013-09-25' THEN 'A.Pre_Cross_Sell'
WHEN created_at >= '2013-09-25' THEN 'B.Post_Cross_Sell'
ELSE 'check logic'
END AS time_period
FROM website_pageviews
WHERE created_at > '2013-08-25'
  AND created_at < '2013-10-25'
AND pageview_url = '/cart';

#find the next pageview id that occurs after /cart
CREATE TEMPORARY TABLE sessions_with_nxt_pv
SELECT time_period, session_pageviews.website_session_id, MIN(website_pageviews.website_pageview_id) AS min_next_pv_id
FROM session_pageviews
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = session_pageviews.website_session_id
AND website_pageviews.website_pageview_id > session_pageviews.website_pageview_id
GROUP BY time_period, session_pageviews.website_session_id;

#find the clickthrough rate for /cart

SELECT time_period, COUNT(DISTINCT sessions_with_nxt_pv.website_session_id) AS cart_sessions,
       COUNT(DISTINCT CASE WHEN min_next_pv_id IS NOT NULL THEN sessions_with_nxt_pv.website_session_id END) AS clickthroughs,
       COUNT(DISTINCT CASE WHEN min_next_pv_id IS NOT NULL THEN sessions_with_nxt_pv.website_session_id END)/COUNT(DISTINCT sessions_with_nxt_pv.website_session_id) AS cart_ctr,
       AVG(orders.items_purchased) AS products_per_order,
       AVG(price_usd) AS AOV,
       SUM(price_usd)/COUNT(sessions_with_nxt_pv.website_session_id) AS rev_per_sesh
FROM sessions_with_nxt_pv
LEFT JOIN orders
ON orders.website_session_id = sessions_with_nxt_pv.website_session_id
GROUP BY time_period;

