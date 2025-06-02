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

--2. Subqueries for complex logic (e.g., max price per genre) 
SELECT 
    B.BookID,
    B.Title,
    B.Genre,
    B.Price
FROM Book B
WHERE B.Price = (
    SELECT MAX(B2.Price)
    FROM Book B2
    WHERE B2.Genre = B.Genre
)
ORDER BY B.Genre, B.Price DESC;

--3. Occupancy rate calculations 
SELECT
    L.LibraryID,
    L.LibraryName,
    COUNT(B.BookID) AS TotalBooks,
    COUNT(CASE WHEN MB.Status = 'Issued' THEN 1 END) AS IssuedBooks,
    CASE 
        WHEN COUNT(B.BookID) = 0 THEN 0
        ELSE CAST(COUNT(CASE WHEN MB.Status = 'Issued' THEN 1 END) AS FLOAT) / COUNT(B.BookID) * 100
    END AS OccupancyRatePercentage
FROM Library L
LEFT JOIN Book B ON B.LibraryID = L.LibraryID
LEFT JOIN Member_books MB ON MB.BookID = B.BookID
GROUP BY L.LibraryID, L.LibraryName
ORDER BY OccupancyRatePercentage DESC;

--4. Members with loans but no fine
SELECT 
    M.MemberID,
    M.Full_Name,
    COUNT(DISTINCT MB.LoanID) AS TotalLoans,
    COALESCE(SUM(P.Amount), 0) AS TotalFinesPaid
FROM Member M
JOIN Member_books MB ON MB.MemberID = M.MemberID
JOIN Loan LN ON LN.LoanID = MB.LoanID
LEFT JOIN Payment P ON P.LoanID = LN.LoanID
GROUP BY M.MemberID, M.Full_Name
HAVING COALESCE(SUM(P.Amount), 0) = 0
ORDER BY TotalLoans DESC;

--5. Genres with high average ratings 
SELECT
    B.Genre,
    AVG(CAST(R.Rating AS FLOAT)) AS AvgRating,
    COUNT(R.ReviewID) AS ReviewCount,
    MAX(R.Rating) AS MaxRating,
    MIN(R.Rating) AS MinRating
FROM Book B
JOIN Member_reviewed_books MRB ON MRB.BookID = B.BookID
JOIN Review R ON R.ReviewID = MRB.ReviewID
GROUP BY B.Genre
HAVING AVG(CAST(R.Rating AS FLOAT)) >= 4.5
ORDER BY AvgRating DESC;

