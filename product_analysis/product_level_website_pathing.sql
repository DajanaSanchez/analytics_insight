#business objective - look at sessions which hit the /products page and see where they went next
#pull click through rates from /products since the new product launch on january 6th 2013 by product
#compare to the 3 months leading up to launch as a baseline; data through april 6, 2013

#STEP 1 - find relevant products pageviews with website session
#STEP 2- find the next pageview id that occurs after the product pageview
#STEP 3 - find the pageview url associated with each next pageview id
#STEP 4 - summarize the data
#gather website sessions and products pageview per session
CREATE TEMPORARY TABLE products_pageviews
SELECT website_session_id, website_pageview_id, created_at,
      CASE
          WHEN created_at < '2013-01-06' THEN 'pre_product_2'
        WHEN created_at >= '2013-01-06' THEN 'post_product_2'
       ELSE 'check_logic'
       END AS time_period
FROM website_pageviews
WHERE created_at < '2013-04-06'
AND created_at > '2012-10-06'
AND pageview_url = '/products';

#find the next pageview id that occurs after product pageview
    CREATE TEMPORARY TABLE sessions_w_nxt_pvids
    SELECT products_pageviews.time_period, products_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_next_pv_id
    FROM products_pageviews
    LEFT JOIN website_pageviews
    ON website_pageviews.website_session_id = products_pageviews.website_session_id
    AND website_pageviews.website_pageview_id > products_pageviews.website_pageview_id
    GROUP BY time_period, products_pageviews.website_session_id;

#find the products pageviews associated with next pageviews
CREATE TEMPORARY TABLE sessions_with_pageview_url
SELECT sessions_w_nxt_pvids.time_period, sessions_w_nxt_pvids.website_session_id, website_pageviews.pageview_url
FROM sessions_w_nxt_pvids
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id = sessions_w_nxt_pvids.min_next_pv_id;

#summarize the data and analyze pre and post products
SELECT time_period,
       COUNT(DISTINCT website_session_id) AS sessions,
       COUNT(DISTINCT CASE WHEN pageview_url IS NOT NULL THEN website_session_id ELSE NULL END) AS w_next_page,
       COUNT(DISTINCT CASE WHEN pageview_url IS NOT NULL THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS pct_next_page,
       COUNT(DISTINCT CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END) AS fuzzy_page,
       COUNT(DISTINCT CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS pct_to_fuzzy,
       COUNT(DISTINCT CASE WHEn pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END) AS love_bear_page,
       COUNT(DISTINCT CASE WHEn pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS pct_to_love_bear
FROM sessions_with_pageview_url
GROUP BY time_period;