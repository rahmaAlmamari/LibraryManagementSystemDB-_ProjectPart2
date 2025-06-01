# **The script of queries**

Think Like a Frontend API Imagine the following queries are API endpoints the 
frontend will call: 

**1. GET /loans/overdue**

List all overdue loans with member name, book title, due date  

```sql
SELECT * FROM Member_books;
SELECT * FROM Loan;
SELECT * FROM Member;

SELECT M.Full_Name as 'Member Name', B.Title as 'Book Title', L.Due_Date as 'Due Date'
FROM Loan L INNER JOIN Member_books MB ON L.LoanID = MB.LoanID
INNER JOIN Book B ON B.BookID = MB.BookID
INNER JOIN Member M ON M.MemberID = MB.MemberID
WHERE MB.Status = 'Overdue';
```

![GET /loans/overdue](./image/get_loans_overdue.png)

**2. GET /books/unavailable**

 List books not available

 ```sql
 SELECT * FROM Book;

SELECT * FROM Book WHERE Availability_Status = 'FALSE';
 ```

![GET /books/unavailable](./image/get_books_unavailable.png)

**3. GET /members/top-borrowers**

Members who borrowed >2 books 

```sql
SELECT * FROM Member_books;
SELECT * FROM Member;

SELECT M.Full_Name as 'Member Name', COUNT(MB.MemberID) AS Total_Borrowed
FROM Member M INNER JOIN Member_books MB ON M.MemberID = MB.MemberID
GROUP BY M.MemberID, M.Full_Name
HAVING COUNT(MB.MemberID) > 2;
```

![GET /members/top-borrowers](./image/get_members_topBorrowers.png)

**4. GET /books/:id/ratings**

Show average rating per book

```sql
SELECT * FROM Book;
SELECT * FROM Review;
SELECT * FROM Member_reviewed_books;

SELECT B.BookID as 'Book ID', B.Title as 'Book Title', AVG(R.Rating) as 'Average Rating'
FROM Book B INNER JOIN Member_reviewed_books MRB ON B.BookID = MRB.MemberID
INNER JOIN Review R ON R.ReviewID = MRB.ReviewID
GROUP BY B.BookID,  B.Title;
```

![GET /books/:id/ratings](./image/get_book_id_rating.png)

**5. GET /libraries/:id/genres**

 Count books by genre 

 ```sql
 SELECT * FROM Book;
SELECT * FROM Library;

SELECT L.LibraryID as 'Library ID', L.LibraryName as 'Library Name', B.Genre as 'Genre', COUNT(B.LibraryID) as 'Number of Books'
FROM Library L INNER JOIN Book B ON L.LibraryID = B.LibraryID
GROUP BY L.LibraryID, L.LibraryName, B.Genre;
 ```

![GET /libraries/:id/genres](./image/get_libraries_id_genres.png)

**6. GET /members/inactive**

 List members with no loans  

 ```sql
SELECT * FROM Member_books;
SELECT * FROM Member;

SELECT M.Full_Name as 'Member Name'
FROM Member M LEFT JOIN Member_books MB ON M.MemberID = MB.MemberID
WHERE MB.MemberID IS NULL;
 ```

![GET /members/inactive](./image/get_members_inactive.png)

**7. GET /payments/summary**

Total fine paid per member  

```sql
SELECT * FROM Member_books;
SELECT * FROM Member;
SELECT * FROM Loan;
SELECT * FROM Payment;

SELECT M.MemberID as 'Member ID', M.Full_Name as 'Member Name', SUM(P.Amount) as 'Total Fine' 
FROM Member M INNER JOIN Member_books MB ON M.MemberID = MB.MemberID
INNER JOIN Loan L ON L.LoanID = MB.LoanID
INNER JOIN Payment P ON L.LoanID = P.LoanID
GROUP BY M.MemberID, M.Full_Name;
```

![GET /payments/summary](./image/get_payments_summary.png)

**8. GET /reviews**

Reviews with member and book info

```sql
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
```

![GET /reviews](./image/get_reviews.png)

**9. GET /books/popular**

 List top 3 books by number of times they were loaned 

 ```sql
 SELECT * FROM Book;
SELECT * FROM Member_books;

SELECT B.BookID as 'Book ID', B.Title as 'Book Title', COUNT(MB.BookID) as 'Number of Times Loaned'
FROM Book B INNER JOIN Member_books MB ON B.BookID = MB.BookID
GROUP BY B.BookID, B.Title
ORDER BY COUNT(MB.BookID);
 ```

![GET /books/popular](./image/get_books_popular.png)

**10. GET /members/:id/history**

Retrieve full loan history of a specific member including book title, 
loan & return dates.

```sql
SELECT * FROM Loan;
SELECT * FROM Member_books;
SELECT * FROM Book;
SELECT * FROM Member;


SELECT B.Title as 'Book Title', L.LoanID as 'Loan ID', L.Return_Date as 'Return Date'
FROM Member M FULL OUTER JOIN Member_books MB ON M.MemberID = MB.MemberID
FULL OUTER JOIN Book B ON B.BookID = MB.BookID
FULL OUTER JOIN Loan L ON L.LoanID = MB.LoanID
WHERE M.MemberID = '1';
```

![GET /members/:id/history](./image/get_members_id_history.png)

**11. GET /books/:id/reviews**

Show all reviews for a book with member name and comments.

```sql
SELECT * FROM Book;
SELECT * FROM Member;
SELECT * FROM Review;
SELECT * FROM Member_reviewed_books;

SELECT B.BookID as 'Book ID', B.Title as 'Book Title', M.Full_Name as 'Member Name', R.Comment as 'Comment'
FROM Book B FULL OUTER JOIN Member_reviewed_books MRB ON B.BookID = MRB.BookID
INNER JOIN Member M ON M.MemberID = MRB.MemberID
INNER JOIN Review R ON R.ReviewID = MRB.ReviewID
```

![GET /books/:id/reviews](./image/get_books_id_reviews.png)

**12. GET /libraries/:id/staff**

List all staff working in a given library.

```sql
SELECT * FROM Staff;
SELECT * FROM Library;

SELECT S.Staff_ID as 'Staff ID', S.Full_Name as 'Staff Name', S.Position as 'Staff Position'
FROM Library L INNER JOIN Staff S ON L.LibraryID = S.LibraryID
WHERE L.LibraryID = '1';
```

![GET /libraries/:id/staff](./image/get_libraries_id_staff.png)

**13. GET /books/price-range?min=5&max=15**







