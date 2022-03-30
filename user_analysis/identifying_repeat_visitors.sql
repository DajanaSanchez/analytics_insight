#business objective - pull data on how many of our website visitors come back for another session. 2014 to date.

#1. We need to find count of website_sessions per user_id
#2. Then we need to determine how many repeat sessions per user_id



SELECT COUNT(DISTINCT website_session_id) AS total_sessions,
       COUNT(CASE WHEN is_repeat_session = 0 THEN user_id ELSE NULL END) AS no_repeat_sessions,
       COUNT(CASE WHEN is_repeat_session = 1 THEN user_id ELSE NULL END) AS repeat_session,
       COUNT(CASE WHEN is_repeat_session = 1 THEN user_id ELSE NULL END)  / COUNT(DISTINCT website_session_id) AS repeat_pct
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-01';




CREATE TEMPORARY TABLE sessions_with_repeatss

SELECT new_sessions.user_id, new_sessions.website_session_id AS new_session_id,
       website_sessions.website_session_id AS repeat_session
FROM(
SELECT website_session_id, user_id
FROM website_sessions
WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-11-01'
AND is_repeat_session = 0) AS new_sessions
LEFT JOIN website_sessions
ON website_sessions.user_id = new_sessions.user_id
AND website_sessions.is_repeat_session = 1
AND website_sessions.website_session_id > new_sessions.website_session_id
AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-11-01';




SELECT repeat_sessions, COUNT(DISTINCT user_id) AS users
FROM(

SELECT user_id, COUNT(DISTINCT new_session_id) AS new_sessions, COUNT(DISTINCT repeat_session) AS repeat_sessions
FROM sessions_with_repeatss
GROUP BY user_id) AS repeat_sessions_total
GROUP BY repeat_sessions;