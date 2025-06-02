--Index creation scripts to optimize query performance 

--use DB
USE LibraryManagementSystem;

--Apply indexes to speed up commonly-used queries: 

--1. Library Table:
--1.1. Non-clustered on Name → Search by name 

CREATE NONCLUSTERED INDEX IX_Library_LibraryName
ON Library (LibraryName);

--1.2. Non-clustered on Location → Filter by location 

CREATE NONCLUSTERED INDEX IX_Library_LibraryLocation
ON Library (LibraryLocation);

--2. Book Table 
--2.1. Clustered on LibraryID, ISBN → Lookup by book in specific library 

CREATE NONCLUSTERED INDEX IX_Book_LibraryID_ISBN
ON Book (LibraryID, ISBN);

--2.2. Non-clustered on Genre → Filter by genre 

CREATE NONCLUSTERED INDEX IX_Book_Genre
ON Book (Genre);

--3. Loan Table 
--3.1. Non-clustered on MemberID → Loan history 

CREATE NONCLUSTERED INDEX IX_Member_books_MemberID
ON Member_books (MemberID);

--3.2. Non-clustered on Status → Filter by status 

CREATE NONCLUSTERED INDEX IX_Member_books_Status
ON Member_books (Status);

--3.3. Composite index on BookID, LoanDate, ReturnDate → Optimize overdue checks 

CREATE NONCLUSTERED INDEX IX_Loan_Book_LoanDate_ReturnDate
ON Loan (Loan_Date, Return_Date);




