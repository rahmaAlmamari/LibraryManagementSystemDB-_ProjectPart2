--Advanced Aggregations – Analytical Insight 
--Advanced aggregation tasks using HAVING, subqueries

--USE DB
USE LibraryManagementSystem;

--Includes: 

--1. HAVING for filtering aggregates 
SELECT 
    B.Genre,
    AVG(CAST(B.Price AS FLOAT)) AS AvgPrice,
    COUNT(B.BookID) AS BookCount,
    MAX(B.Price) AS MaxPrice,
    MIN(B.Price) AS MinPrice
FROM Book B
GROUP BY B.Genre
HAVING AVG(CAST(B.Price AS FLOAT)) > 100
   AND COUNT(B.BookID) > 5
ORDER BY AvgPrice DESC;



