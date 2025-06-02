--Aggregation Functions – Dashboard Reports 
--Basic real-world aggregation queries

--USE DB
USE LibraryManagementSystem;

--Tasks simulate admin dashboards: 

--1. Total fines per member 
SELECT 
    M.MemberID,
    M.Full_Name,
    COUNT(P.PaymentID) AS NumberOfFines,
    SUM(P.Amount) AS TotalFines,
    MAX(P.Amount) AS MaxFine,
    AVG(P.Amount) AS AvgFine
FROM Member M
JOIN Member_books MB ON MB.MemberID = M.MemberID
JOIN Loan L ON L.LoanID = MB.LoanID
JOIN Payment P ON P.LoanID = L.LoanID
WHERE P.Method = 'Fine'
GROUP BY M.MemberID, M.Full_Name
ORDER BY TotalFines DESC;

--2. Most active libraries (by loan count) 
SELECT 
    L.LibraryID,
    L.LibraryName,
    COUNT(DISTINCT LN.LoanID) AS TotalLoans,
    MAX(LN.LoanID) AS MaxLoanID,
    AVG(CAST(DATEDIFF(DAY, LN.Loan_Date, LN.Return_Date) AS FLOAT)) AS AvgLoanDurationDays
FROM Library L
JOIN Book B ON B.LibraryID = L.LibraryID
JOIN Member_books MB ON MB.BookID = B.BookID
JOIN Loan LN ON LN.LoanID = MB.LoanID
GROUP BY L.LibraryID, L.LibraryName
ORDER BY TotalLoans DESC;

--3. Avg book price per genre 
SELECT 
    B.Genre,
    AVG(CAST(B.Price AS FLOAT)) AS AvgBookPrice,
    MAX(B.Price) AS MaxBookPrice,
    MIN(B.Price) AS MinBookPrice,
    COUNT(B.BookID) AS NumberOfBooks
FROM Book B
GROUP BY B.Genre
ORDER BY AvgBookPrice DESC;

--4. Top 3 most reviewed books 
SELECT TOP 3
    B.BookID,
    B.Title,
    COUNT(MRB.ReviewID) AS ReviewCount,
    AVG(R.Rating) AS AvgRating,
    MAX(R.Rating) AS MaxRating,
    MIN(R.Rating) AS MinRating
FROM Book B
JOIN Member_reviewed_books MRB ON MRB.BookID = B.BookID
JOIN Review R ON R.ReviewID = MRB.ReviewID
GROUP BY B.BookID, B.Title
ORDER BY ReviewCount DESC;

