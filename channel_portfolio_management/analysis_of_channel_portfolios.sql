#business objective - we launched a second paid search channel, bsearch, around August 22nd
#pull weekly trended session volume since and compare to gsearch nonbrand

#1. find the exact date bsearch was created
#2. case distinct sessions for each search channel
#3. find totals of sessions per week

SELECT MIN(created_at)
FROM website_sessions
WHERE utm_source = 'bsearch'
AND utm_campaign = 'nonbrand'; #2012-08-19

SELECT MIN(DATE(created_at)) AS start_of_week,
COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS gsearch_sessions,
COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_session_id ELSE NULL END) AS bsearch_sessions
FROM website_sessions
WHERE created_at > '2012-08-19'
AND created_at < '2012-11-29'
AND utm_campaign = 'nonbrand'
GROUP BY YEAR(created_at), WEEK(created_at)
