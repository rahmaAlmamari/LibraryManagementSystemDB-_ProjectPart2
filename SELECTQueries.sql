-- 1. GET /loans/overdue → List all overdue loans with member name, book title, due date 
SELECT * FROM Member_books;
SELECT * FROM Loan;
SELECT * FROM Member;

SELECT M.Full_Name as 'Member Name', B.Title as 'Book Title', L.Due_Date as 'Due Date'
FROM Loan L INNER JOIN Member_books MB ON L.LoanID = MB.LoanID
INNER JOIN Book B ON B.BookID = MB.BookID
INNER JOIN Member M ON M.MemberID = MB.MemberID
WHERE MB.Status = 'Overdue';

--2. GET /books/unavailable → List books not available  

SELECT * FROM Book;

SELECT * FROM Book WHERE Availability_Status = 'FALSE';

--3. GET /members/top-borrowers → Members who borrowed >2 books 

SELECT * FROM Member_books;
SELECT * FROM Member;

SELECT M.Full_Name as 'Member Name', COUNT(MB.MemberID) AS Total_Borrowed
FROM Member M INNER JOIN Member_books MB ON M.MemberID = MB.MemberID
GROUP BY M.MemberID, M.Full_Name
HAVING COUNT(MB.MemberID) > 2;

--4. GET /books/:id/ratings → Show average rating per book  

SELECT * FROM Book;
SELECT * FROM Review;
SELECT * FROM Member_reviewed_books;

SELECT B.BookID as 'Book ID', B.Title as 'Book Title', AVG(R.Rating) as 'Average Rating'
FROM Book B INNER JOIN Member_reviewed_books MRB ON B.BookID = MRB.MemberID
INNER JOIN Review R ON R.ReviewID = MRB.ReviewID
GROUP BY B.BookID,  B.Title;

--5. GET /libraries/:id/genres → Count books by genre  

SELECT * FROM Book;
SELECT * FROM Library;

SELECT L.LibraryID as 'Library ID', L.LibraryName as 'Library Name', B.Genre as 'Genre', COUNT(B.LibraryID) as 'Number of Books'
FROM Library L INNER JOIN Book B ON L.LibraryID = B.LibraryID
GROUP BY L.LibraryID, L.LibraryName, B.Genre;

--6. GET /members/inactive → List members with no loans  

SELECT * FROM Member_books;
SELECT * FROM Member;

SELECT M.Full_Name as 'Member Name'
FROM Member M LEFT JOIN Member_books MB ON M.MemberID = MB.MemberID
WHERE MB.MemberID IS NULL;

--7. GET /payments/summary → Total fine paid per member 

SELECT * FROM Member_books;
SELECT * FROM Member;
SELECT * FROM Loan;
SELECT * FROM Payment;

SELECT M.MemberID as 'Member ID', M.Full_Name as 'Member Name', SUM(P.Amount) as 'Total Fine' 
FROM Member M INNER JOIN Member_books MB ON M.MemberID = MB.MemberID
INNER JOIN Loan L ON L.LoanID = MB.LoanID
INNER JOIN Payment P ON L.LoanID = P.LoanID
GROUP BY M.MemberID, M.Full_Name;

--8. GET /reviews → Reviews with member and book info  

SELECT * FROM Member;
SELECT * FROM Book;
SELECT * FROM Review;
SELECT * FROM Member_reviewed_books;

SELECT
M.MemberID as 'Member ID', M.Full_Name as 'Member Name', 
B.BookID as 'Book ID', B.Title as 'Book Title', B.Genre as 'Book Genre', B.Price as 'Book Price',
R.ReviewID as 'Review ID', R.Rating as 'Review Rating', R.Comment as 'Review Comment'
FROM Member M INNER JOIN Member_reviewed_books MRB ON M.MemberID = MRB.MemberID
INNER JOIN Book B ON B.BookID = MRB.BookID 
INNER JOIN Review R ON R.ReviewID = MRB.ReviewID;

--9. GET /books/popular → List top 3 books by number of times they were loaned 

SELECT * FROM Book;
SELECT * FROM Member_books;

SELECT B.BookID as 'Book ID', B.Title as 'Book Title', COUNT(MB.BookID) as 'Number of Times Loaned'
FROM Book B INNER JOIN Member_books MB ON B.BookID = MB.BookID
GROUP BY B.BookID, B.Title
ORDER BY COUNT(MB.BookID);

