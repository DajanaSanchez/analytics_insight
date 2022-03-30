#business objective - analyze the min., max, and avg time between first and second session from 2014-01-01 to 2014-11-03


CREATE TEMPORARY TABLE repeat_and_new_session
    #second query
SELECT new_sessions.user_id, new_sessions.website_session_id AS new_session_id, new_sessions.created_at AS first_session_created, website_sessions.website_session_id AS repeat_session_id,website_sessions.created_at AS repeat_session_created
FROM(
    #first query
SELECT website_session_id, user_id, created_at
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-03'
AND is_repeat_session = 0) AS new_sessions

LEFT JOIN website_sessions
ON website_sessions.user_id = new_sessions.user_id
AND website_sessions.is_repeat_session = 1
AND website_sessions.website_session_id > new_sessions.website_session_id
AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-11-03';


SELECT AVG(difference_in_time) AS avg_days_first_to_second, MIN(difference_in_time) AS min_days_first_to_second, MAX(difference_in_time) AS max_days_first_to_second
FROM(
SELECT first_session_created, second_session_created, DATEDIFF(second_session_created, first_session_created) AS difference_in_time
FROM(
SELECT user_id, new_session_id, first_session_created, MIN(repeat_session_created) AS second_session_created
FROM repeat_and_new_session
GROUP BY user_id, new_session_id, first_session_created) AS aggregated_time)
AS difference;