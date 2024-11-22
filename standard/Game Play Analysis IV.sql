-- Q. 550
-- MySQL

--Approach 1
WITH firstLogin AS (
    SELECT player_id, MIN(event_date) AS first_login
    FROM Activity
    GROUP BY player_id
),
secondDayLogin AS (
    SELECT DISTINCT A.player_id
    FROM Activity A
    JOIN firstLogin F
    ON A.player_id = F.player_id
    WHERE DATEDIFF(A.event_date, F.first_login) = 1
)
SELECT 
    ROUND(
        (SELECT COUNT(*) FROM secondDayLogin) / 
        (SELECT COUNT(DISTINCT player_id) FROM Activity), 
        2
    ) AS fraction;


--Approach 2
SELECT
  ROUND(COUNT(DISTINCT player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) AS fraction
FROM
  Activity
WHERE
  (player_id, DATE_SUB(event_date, INTERVAL 1 DAY))
  IN (
    SELECT player_id, MIN(event_date) AS first_login FROM Activity GROUP BY player_id
  )
