-- Q.1158
-- MySQL

SELECT u.user_id as buyer_id, u.join_date, count(o.order_id) as 'orders_in_2019'
FROM users u
LEFT JOIN Orders o
ON o.buyer_id=u.user_id AND YEAR(order_date)='2019'
GROUP BY u.user_id


/*
Explanation

Q) Why is there no need to check for ISNULL here?
Because,
FROM statement says select all rows of 'User' table
LEFT JOIN say select only those rows of 'Orders' table where buyer_id = user_id AND the Year of Order_Date is 2019,
Now, when we do a COUNT then it returns non-null values and if all values are null then it returns 0, thus NULL would never be returned.

Q) Why can't we use WHERE Year is 2019 here?
Because, SQL query is executed in following order:

FROM
WHERE
GROUP BY
HAVING
SELECT
ORDER BY ,
so, it removes the records for which no orders were placed in 2019 way before you can perform a GROUP BY or SELECT(COUNT).

so below solution will give wrong ans:
SELECT u.user_id AS buyer_id, u.join_date, COUNT(o.order_date) AS orders_in_2019
FROM users u LEFT JOIN Orders o ON o.buyer_id=u.user_id
WHERE YEAR(o.order_date) = 2019
GROUP BY u.user_id

*/