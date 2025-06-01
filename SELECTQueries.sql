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

