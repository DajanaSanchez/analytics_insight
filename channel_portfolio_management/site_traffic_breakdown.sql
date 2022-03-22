#business objective - potential investor is asking if we're building momentum with the brand or if we'll need to keep relying on paid traffic
# pull organic search, direct type in, and paid brand search sessions by month & show the sessions as a percentage of paid search nonbrand
# through Dec 23, 2012
#organic search - http_referer not null / utm source is null
#direct type in - http referer is null / utm source is null
#paid - utm source is NOT NULL

SELECT MIN(DATE(created_at)) AS month_start_date,
COUNT(DISTINCT CASE WHEN utm_source IS NOT NULL AND utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS paid_nonbrand,
COUNT(DISTINCT CASE WHEN utm_source IS NOT NULL AND utm_campaign = 'brand' THEN website_session_id ELSE NULL END) AS paid_brand,
COUNT(DISTINCT CASE WHEN utm_source IS NOT NULL AND utm_campaign = 'brand' THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN utm_source IS NOT NULL AND utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END)  AS brand_to_nonbrand,

COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_session_id ELSE NULL END) AS organic_search,
COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_source IS NOT NULL AND utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS organic_to_nonbrand,

COUNT(DISTINCT CASE WHEN utm_source IS NULL and http_referer IS NULL THEN website_session_id ELSE NULL END) AS direct_search,
 COUNT(DISTINCT CASE WHEN utm_source IS NULL and http_referer IS NULL THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_source IS NOT NULL AND utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS direct_to_nonbrand

FROM website_sessions
WHERE created_at < '2012-12-23'
GROUP BY YEAR(created_at), MONTH(created_at)