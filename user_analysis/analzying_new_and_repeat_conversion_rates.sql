#business objective - comparison of conversion rates and revenue per session for repeat sessions vs. new sessions
#from '2014-01-01' through '2014-11-08'
#will need to pull revenue from orders table


SELECT is_repeat_session, COUNT(DISTINCT(website_session_id)) AS sessions,
       COUNT(DISTINCT(order_id))/COUNT(DISTINCT(website_session_id)) AS conversion_rate,
       SUM(price_usd)/COUNT(DISTINCT(website_session_id)) AS revenue_per_session
FROM(
SELECT
CASE
WHEN is_repeat_session = 0 THEN 'new_session'
WHEN is_repeat_session = 1 THEN 'repeat_session'
END AS is_repeat_session,
       website_sessions.website_session_id, orders.order_id, orders.price_usd

FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-11-08') AS session_order_grouping

GROUP BY is_repeat_session;