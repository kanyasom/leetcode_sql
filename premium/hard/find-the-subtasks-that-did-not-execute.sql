/*
Q 1767 :(Google)  
Tags : [Recursive CTE] (very good)

Table: Tasks

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| task_id        | int     |
| subtasks_count | int     |
+----------------+---------+
task_id is the column with unique values for this table.
Each row in this table indicates that task_id was divided into subtasks_count subtasks labeled from 1 to subtasks_count.
It is guaranteed that 2 <= subtasks_count <= 20.
 

Table: Executed

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| task_id       | int     |
| subtask_id    | int     |
+---------------+---------+
(task_id, subtask_id) is the combination of columns with unique values for this table.
Each row in this table indicates that for the task task_id, the subtask with ID subtask_id was executed successfully.
It is guaranteed that subtask_id <= subtasks_count for each task_id.
 

Write a solution to report the IDs of the missing subtasks for each task_id.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Tasks table:
+---------+----------------+
| task_id | subtasks_count |
+---------+----------------+
| 1       | 3              |
| 2       | 2              |
| 3       | 4              |
+---------+----------------+
Executed table:
+---------+------------+
| task_id | subtask_id |
+---------+------------+
| 1       | 2          |
| 3       | 1          |
| 3       | 2          |
| 3       | 3          |
| 3       | 4          |
+---------+------------+
Output: 
+---------+------------+
| task_id | subtask_id |
+---------+------------+
| 1       | 1          |
| 1       | 3          |
| 2       | 1          |
| 2       | 2          |
+---------+------------+
Explanation: 
Task 1 was divided into 3 subtasks (1, 2, 3). Only subtask 2 was executed successfully, so we include (1, 1) and (1, 3) in the answer.
Task 2 was divided into 2 subtasks (1, 2). No subtask was executed successfully, so we include (2, 1) and (2, 2) in the answer.
Task 3 was divided into 4 subtasks (1, 2, 3, 4). All of the subtasks were executed successfully.
*/


WITH RECURSIVE cte_subtasks AS (
    -- Base case: Start with the first subtask for each task
    SELECT task_id, 1 AS subtask_id
    FROM Tasks
    WHERE subtasks_count >= 1
    UNION ALL
    -- Recursive case: Generate the next subtask for the same task
    SELECT st.task_id, st.subtask_id + 1
    FROM cte_subtasks st
    JOIN Tasks t ON st.task_id = t.task_id
    WHERE st.subtask_id < t.subtasks_count
)

SELECT st.task_id, st.subtask_id
FROM cte_subtasks st
LEFT JOIN Executed e
    ON st.task_id = e.task_id AND st.subtask_id = e.subtask_id
WHERE e.subtask_id IS NULL
order by st.task_id, st.subtask_id;
