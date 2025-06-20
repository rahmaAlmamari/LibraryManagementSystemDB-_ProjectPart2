--Views � Frontend Integration Support 
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

--4. ViewLoanStatusSummary 
--Loan stats (issued, returned, overdue) per library 

CREATE VIEW ViewLoanStatusSummary AS
SELECT L.LibraryID, L.LibraryName, 
-- Count of Issued loans
COUNT(CASE WHEN MB.Status = 'Issued' THEN 1 END) AS IssuedCount, 
-- Count of Returned loans
COUNT(CASE WHEN MB.Status = 'Returned' THEN 1 END) AS ReturnedCount,
-- Count of Overdue loans: Return_Date > Due_Date
COUNT(CASE WHEN MB.Status = 'Issued' AND LN.Return_Date > LN.Due_Date THEN 1 END) AS OverdueCount
FROM Library L LEFT JOIN Book B ON L.LibraryID = B.LibraryID
LEFT JOIN Member_books MB ON B.BookID = MB.BookID
LEFT JOIN Loan LN ON MB.LoanID = LN.LoanID
GROUP BY L.LibraryID, L.LibraryName;

--to run ViewLoanStatusSummary

SELECT * FROM ViewLoanStatusSummary;

--5. ViewPaymentOverview 
--Payment info with member, book, and status 

CREATE VIEW ViewPaymentOverview AS
SELECT P.PaymentID, P.Method, P.Amount, P.Payment_Date,
M.MemberID, M.Full_Name AS MemberName,
B.BookID, B.Title AS BookTitle,
MB.Status AS LoanStatus,
LN.Loan_Date, LN.Due_Date, LN.Return_Date
FROM Payment P JOIN Loan LN ON P.LoanID = LN.LoanID
JOIN Member_books MB ON LN.LoanID = MB.LoanID
JOIN Member M ON MB.MemberID = M.MemberID
JOIN Book B ON MB.BookID = B.BookID;

--to run ViewPaymentOverview

SELECT * FROM ViewPaymentOverview;



