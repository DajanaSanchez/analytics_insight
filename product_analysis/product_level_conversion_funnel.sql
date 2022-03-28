#conversion funnel for both products from each product page through april 10, 2014
# sessions, /cart, /shipping, /billing, /thank-you-for-your-order
# /the-original-mr-fuzzy, /the-forever-love-bear

#Select all pageviews for relevant sessions

CREATE TEMPORARY TABLE sessions_seeing_product_pages
SELECT website_session_id, website_pageview_id, pageview_url AS product_page_seen
FROM website_pageviews
WHERE created_at < '2013-04-10'
AND created_at > '2013-01-06'
AND pageview_url IN ('/the-original-mr-fuzzy', '/the-forever-love-bear');

#find the pageview url for each session
SELECT DISTINCT(website_pageviews.pageview_url)
FROM sessions_seeing_product_pages
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = sessions_seeing_product_pages.website_session_id
AND website_pageviews.website_pageview_id > sessions_seeing_product_pages.website_pageview_id;

#create funnel
SELECT sessions_seeing_product_pages.website_session_id, sessions_seeing_product_pages.product_page_seen,
CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing_page,
CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thank_you_page
FROM sessions_seeing_product_pages
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = sessions_seeing_product_pages.website_session_id
AND website_pageviews.website_pageview_id > sessions_seeing_product_pages.website_pageview_id
ORDER BY sessions_seeing_product_pages.website_session_id, website_pageviews.created_at;

#find session and funnel counts
CREATE TEMPORARY TABLE session_product_made
SELECT
website_session_id,
CASE WHEN product_page_seen = '/the-original-mr-fuzzy' THEN 'mr_fuzzy'
     WHEN product_page_seen = '/the-forever-love-bear' THEN 'lovebear'
     ELSE 'check_logic'
    END AS product_seen,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thank_you_page) AS thankyou_made_it
FROM(SELECT sessions_seeing_product_pages.website_session_id, sessions_seeing_product_pages.product_page_seen,
CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing_page,
CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thank_you_page
FROM sessions_seeing_product_pages
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = sessions_seeing_product_pages.website_session_id
AND website_pageviews.website_pageview_id > sessions_seeing_product_pages.website_pageview_id) AS page_view_level
GROUP BY website_session_id,
    CASE WHEN product_page_seen = '/the-original-mr-fuzzy' THEN 'mr_fuzzy'
     WHEN product_page_seen = '/the-forever-love-bear' THEN 'lovebear'
     ELSE 'check_logic'
    END;


#find count of each page

SELECT product_seen, COUNT(DISTINCT website_session_id) AS sessions,
       COUNT(CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS cart_page,
       COUNT(CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS shipping_page,
       COUNT(CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS billing_page,
       COUNT(CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS thank_you_page
       FROM session_product_made
GROUP BY product_seen;

#find click through rate
SELECT product_seen, COUNT(DISTINCT website_session_id) AS sessions,
       COUNT(CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id)  AS product_clickthrough,
       COUNT(CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS cart_clickthrough,
       COUNT(CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END)/ COUNT(CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS shipping_clickthrough,
       COUNT(CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END)/ COUNT(CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS billing_clickthrough
FROM session_product_made
GROUP BY product_seen;