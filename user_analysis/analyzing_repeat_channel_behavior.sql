#business objective - we want to understand the channels users use when they come back to the site
#compare new vs. repeat sessions by channel group; 2014-01-01 through 2014-11-05
#channel groups - organic search, paid search(brand), paid search(nonbrand), paid social, direct type in
# if UTM and http_referer is NULL then direct type in
# if http_referer is gsearch or bsearch and UTM is NULL then organic search
# if http_referer is socialbook and UTM is NOT NULL then paid social
# if http_referer is NOT NULL, utm source is gsearch/bsearch and utmcontent is BRAND then paid brand
# if http_referer is NOT NULL, utm source is gsearch/bsearch and utmcontent is NONBRAND then paidnonbrand


SELECT channel_groups,
       COUNT(CASE WHEN is_repeat_session = 0  THEN website_session_id ELSE NULL END) AS new_sessions,
       COUNT(CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END) AS repeat_sessions

FROM(
SELECT
CASE
WHEN http_referer IS NULL and utm_source IS NULL THEN 'direct_type_in'
WHEN http_referer IS NOT NULL and utm_source IS NULL THEN 'organic_search'
WHEN http_referer IS NOT NULL AND utm_source = 'socialbook' THEN 'paid_social'
WHEN http_referer IS NOT NULL AND utm_source IS NOT NULL AND utm_campaign = 'brand' THEN 'paid_brand'
WHEN http_referer IS NOT NULL AND utm_source IS NOT NULL AND utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
    ELSE 'check_logic' END AS channel_groups,
      website_session_id, user_id, is_repeat_session
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-05') AS total_sessions
GROUP BY channel_groups;
