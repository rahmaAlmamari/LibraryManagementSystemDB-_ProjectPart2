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
