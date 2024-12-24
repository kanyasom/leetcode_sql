/*
Table: Point

+-------------+------+
| Column Name | Type |
+-------------+------+
| x           | int  |
+-------------+------+
In SQL, x is the primary key column for this table.
Each row of this table indicates the position of a point on the X-axis.
 

Find the shortest distance between any two points from the Point table.

The result format is in the following example.

 

Example 1:

Input: 
Point table:
+----+
| x  |
+----+
| -1 |
| 0  |
| 2  |
+----+
Output: 
+----------+
| shortest |
+----------+
| 1        |
+----------+
Explanation: The shortest distance is between points -1 and 0 which is |(-1) - 0| = 1.
 

Follow up: How could you optimize your solution if the Point table is ordered in ascending order?
*/


--my answer
SELECT COALESCE(MIN(diff)) as shortest
from(
select ABS(x - LEAD(x) OVER (ORDER BY x)) as diff
FROM Point
) tb

--editorial
/*Approach: Using ABS() and MIN() functions [Accepted]
Intuition

Calculate the distances between each two points first, and then display the minimum one.

Algorithm

To get the distances of each two points, we need to join this table with itself and use ABS() function since the distance is nonnegative.
One trick here is to add the condition in the join to avoid calculating the distance between a point with itself.
*/
SELECT
    p1.x, p2.x, ABS(p1.x - p2.x) AS distance
FROM
    point p1
        JOIN
    point p2 ON p1.x != p2.x
;

/*
Note: The columns p1.x, p2.x are only for demonstrating purpose, so they are not actually needed in the end.
Taking the sample data for example, the output would be as below.

| x  | x  | distance |
|----|----|----------|
| 0  | -1 | 1        |
| 2  | -1 | 3        |
| -1 | 0  | 1        |
| 2  | 0  | 2        |
| -1 | 2  | 3        |
| 0  | 2  | 2        |
At last, use MIN() to select the smallest value in the distance column.
*/
MySQL

SELECT
    MIN(ABS(p1.x - p2.x)) AS shortest
FROM
    point p1
        JOIN
    point p2 ON p1.x != p2.x
;

