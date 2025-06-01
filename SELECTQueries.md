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