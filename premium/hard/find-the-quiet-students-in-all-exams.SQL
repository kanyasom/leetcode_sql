/*
Student

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| student_id          | int     |
| student_name        | varchar |
+---------------------+---------+
student_id is the primary key (column with unique values) for this table.
student_name is the name of the student.
 

Table: Exam

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| exam_id       | int     |
| student_id    | int     |
| score         | int     |
+---------------+---------+
(exam_id, student_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates that the student with student_id had a score points in the exam with id exam_id.
 

A quiet student is the one who took at least one exam and did not score the highest or the lowest score.

Write a solution to report the students (student_id, student_name) being quiet in all exams. Do not return the student who has never taken any exam.

Return the result table ordered by student_id.

The result format is in the following example.

 

Example 1:

Input: 
Student table:
+-------------+---------------+
| student_id  | student_name  |
+-------------+---------------+
| 1           | Daniel        |
| 2           | Jade          |
| 3           | Stella        |
| 4           | Jonathan      |
| 5           | Will          |
+-------------+---------------+
Exam table:
+------------+--------------+-----------+
| exam_id    | student_id   | score     |
+------------+--------------+-----------+
| 10         |     1        |    70     |
| 10         |     2        |    80     |
| 10         |     3        |    90     |
| 20         |     1        |    80     |
| 30         |     1        |    70     |
| 30         |     3        |    80     |
| 30         |     4        |    90     |
| 40         |     1        |    60     |
| 40         |     2        |    70     |
| 40         |     4        |    80     |
+------------+--------------+-----------+
Output: 
+-------------+---------------+
| student_id  | student_name  |
+-------------+---------------+
| 2           | Jade          |
+-------------+---------------+
Explanation: 
For exam 1: Student 1 and 3 hold the lowest and high scores respectively.
For exam 2: Student 1 hold both highest and lowest score.
For exam 3 and 4: Studnet 1 and 4 hold the lowest and high scores respectively.
Student 2 and 5 have never got the highest or lowest in any of the exams.
Since student 5 is not taking any exam, he is excluded from the result.
So, we only return the information of Student 2.
*/

WITH sub AS
(SELECT student_id, exam_id, score,
MAX(score) OVER(PARTITION BY exam_id ) AS ma,
MIN(score) OVER(PARTITION BY exam_id) AS mi
FROM Exam)

SELECT DISTINCT e.student_id, student_name
FROM Exam e LEFT JOIN Student s
ON e.student_id = s.student_id
WHERE e.student_id NOT IN
(SELECT sub.student_id
FROM sub
WHERE sub.score = ma OR sub.score = mi)
ORDER BY e.student_id



--Without using Window Function

With not_quiet as 
        (Select exam_id, max(score) high
        From Exam
        group by exam_id
        Union all
        Select exam_id, min(score) low
        From Exam
        group by exam_id)

Select distinct student_id, student_name 
From Exam join Student using(student_id)
where student_id not in (Select distinct student_id  --get student id who are not quiet
                        From Exam
                        where (exam_id, score) in (Select * from not_quiet))
order by 1