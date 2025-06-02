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


