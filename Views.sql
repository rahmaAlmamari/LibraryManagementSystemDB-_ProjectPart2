--Views – Frontend Integration Support 
--Logical views for frontend data access 

--USE DB
USE LibraryManagementSystem;

--1. ViewPopularBooks 
-- Books with average rating > 4.5 + total loans 

CREATE VIEW ViewPopularBooks AS
SELECT B.BookID, B.Title, B.Genre, B.ISBN,
AVG(R.Rating) AS AverageRating,
COUNT(DISTINCT MB.LoanID) AS TotalLoans
FROM Book B JOIN Member_reviewed_books MRB ON B.BookID = MRB.BookID
JOIN Review R ON MRB.ReviewID = R.ReviewID
LEFT JOIN Member_books MB ON B.BookID = MB.BookID
GROUP BY B.BookID, B.Title, B.Genre, B.ISBN
HAVING AVG(R.Rating) > 4.5;

--to run ViewPopularBooks

SELECT * FROM ViewPopularBooks;

--2. ViewMemberLoanSummary 
--Member loan count + total fines paid 

CREATE VIEW ViewMemberLoanSummary AS
SELECT M.MemberID, M.Full_Name,
COUNT(DISTINCT MB.LoanID) AS TotalLoans,
ISNULL(SUM(P.Amount), 0) AS TotalFinesPaid
FROM Member M LEFT JOIN Member_books MB ON M.MemberID = MB.MemberID
LEFT JOIN Loan L ON MB.LoanID = L.LoanID
LEFT JOIN Payment P ON L.LoanID = P.LoanID
GROUP BY M.MemberID, M.Full_Name;

--to run ViewMemberLoanSummary

SELECT * FROM ViewMemberLoanSummary;

--3. ViewAvailableBooks 
--Available books grouped by genre, ordered by price 

CREATE VIEW ViewAvailableBooks AS
SELECT B.Genre, B.BookID, B.Title, B.Price, B.Availability_Status
FROM Book B
WHERE B.Availability_Status = 'TRUE';

--to run ViewAvailableBooks

SELECT * FROM ViewAvailableBooks
ORDER BY Genre, Price;



