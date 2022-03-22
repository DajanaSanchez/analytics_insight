#business objective - we're considering adding a live chat support to website
#need to analyze average website sessions by hour of day and by day week
#use timeframe of Sept 15 - Nov 15


SELECT hour,
       AVG(CASE WHEN wkday = 0 THEN sessions ElSE NULL END) AS monday,
AVG(CASE WHEN wkday = 1 THEN sessions ElSE NULL END) AS tuesday,
AVG(CASE WHEN wkday = 2 THEN sessions ELSE NULL END) AS wednesday,
AVG(CASE WHEN wkday = 3 THEN sessions ELSE NULL END) AS thursday,
AVG(CASE WHEN wkday = 4 THEN sessions ELSE NULL END) AS friday,
AVG(CASE WHEN wkday = 5 THEN sessions ELSE NULL END) AS saturday,
AVG(CASE WHEN wkday = 6 THEN sessions ELSE NULL END) AS sunday
FROM (
      SELECT DATE(created_at) AS created_date,
             WEEKDAY(created_at) AS wkday,
             HOUR(created_at) AS hour,
             COUNT(DISTINCT website_session_id) AS sessions
             FROM website_sessions
WHERE created_at BETWEEN '2012-09-15' AND '2012-11-15'
GROUP BY 1,2,3) AS daily_hourly_sessions
GROUP BY 1
ORDER BY 1,2;