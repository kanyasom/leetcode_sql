--1212 (amazon, wayfair)

/*
Teams

+---------------+----------+
| Column Name   | Type     |
+---------------+----------+
| team_id       | int      |
| team_name     | varchar  |
+---------------+----------+
team_id is the column with unique values of this table.
Each row of this table represents a single football team.
 

Table: Matches

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| match_id      | int     |
| host_team     | int     |
| guest_team    | int     | 
| host_goals    | int     |
| guest_goals   | int     |
+---------------+---------+
match_id is the column of unique values of this table.
Each row is a record of a finished match between two different teams. 
Teams host_team and guest_team are represented by their IDs in the Teams table (team_id), and they scored host_goals and guest_goals goals, respectively.
 

You would like to compute the scores of all teams after all matches. Points are awarded as follows:
A team receives three points if they win a match (i.e., Scored more goals than the opponent team).
A team receives one point if they draw a match (i.e., Scored the same number of goals as the opponent team).
A team receives no points if they lose a match (i.e., Scored fewer goals than the opponent team).
Write a solution that selects the team_id, team_name and num_points of each team in the tournament after all described matches.

Return the result table ordered by num_points in decreasing order. In case of a tie, order the records by team_id in increasing order.

The result format is in the following example.

 

Example 1:

Input: 
Teams table:
+-----------+--------------+
| team_id   | team_name    |
+-----------+--------------+
| 10        | Leetcode FC  |
| 20        | NewYork FC   |
| 30        | Atlanta FC   |
| 40        | Chicago FC   |
| 50        | Toronto FC   |
+-----------+--------------+
Matches table:
+------------+--------------+---------------+-------------+--------------+
| match_id   | host_team    | guest_team    | host_goals  | guest_goals  |
+------------+--------------+---------------+-------------+--------------+
| 1          | 10           | 20            | 3           | 0            |
| 2          | 30           | 10            | 2           | 2            |
| 3          | 10           | 50            | 5           | 1            |
| 4          | 20           | 30            | 1           | 0            |
| 5          | 50           | 30            | 1           | 0            |
+------------+--------------+---------------+-------------+--------------+
Output: 
+------------+--------------+---------------+
| team_id    | team_name    | num_points    |
+------------+--------------+---------------+
| 10         | Leetcode FC  | 7             |
| 20         | NewYork FC   | 3             |
| 50         | Toronto FC   | 3             |
| 30         | Atlanta FC   | 1             |
| 40         | Chicago FC   | 0             |
+------------+--------------+---------------+

*/


--- Ans
WITH Points AS (
    SELECT
        t.team_id,
        t.team_name,
        SUM(CASE
            WHEN (m.host_team = t.team_id AND m.host_goals > m.guest_goals) OR
                 (m.guest_team = t.team_id AND m.guest_goals > m.host_goals) THEN 3
            WHEN (m.host_team = t.team_id AND m.host_goals = m.guest_goals) OR
                 (m.guest_team = t.team_id AND m.guest_goals = m.host_goals) THEN 1
            ELSE 0
        END) AS points
    FROM Teams t
    LEFT JOIN Matches m ON t.team_id = m.host_team OR t.team_id = m.guest_team
    GROUP BY t.team_id, t.team_name
)

SELECT team_id, team_name, points AS num_points
FROM Points
ORDER BY num_points DESC, team_id;


--- compact
WITH Points AS (
    SELECT
        t.team_id,
        t.team_name,
        SUM(CASE
            WHEN m.host_team = t.team_id AND m.host_goals > m.guest_goals THEN 3
            WHEN m.guest_team = t.team_id AND m.guest_goals > m.host_goals THEN 3
            WHEN m.host_goals = m.guest_goals THEN 1
            ELSE 0
        END) AS points
    FROM Teams t
    LEFT JOIN Matches m 
        ON t.team_id = m.host_team OR t.team_id = m.guest_team
    GROUP BY t.team_id, t.team_name
)

SELECT team_id, team_name, points AS num_points
FROM Points
ORDER BY num_points DESC, team_id;


