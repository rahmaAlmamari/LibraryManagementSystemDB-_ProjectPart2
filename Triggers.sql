--Triggers – Real-Time Business Logic 
--Triggers for enforcing business rules

--USE DB 
USE LibraryManagementSystem;

--1. trg_UpdateBookAvailability 
--After new loan -> set book to unavailable 

CREATE TRIGGER trg_UpdateBookAvailability
ON Member_books
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE B
    SET B.Availability_Status = 'FALSE'
    FROM Book B
    JOIN INSERTED I ON B.BookID = I.BookID;
END;

--2. trg_CalculateLibraryRevenue
--After new payment -> update library revenue

--becouse I do not have table to store cumulative revenue per library I will create it first then I will create the trg_CalculateLibraryRevenue

CREATE TABLE Library_Revenue (
    LibraryID INT PRIMARY KEY,
    Total_Revenue INT NOT NULL DEFAULT 0,
    FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TRIGGER trg_CalculateLibraryRevenue
ON Payment
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Step 1: Insert missing LibraryIDs into Library_Revenue (if not already there)
    INSERT INTO Library_Revenue (LibraryID, Total_Revenue)
    SELECT DISTINCT B.LibraryID, 0
    FROM INSERTED INS
    JOIN Loan L ON INS.LoanID = L.LoanID
    JOIN Member_books MB ON MB.LoanID = L.LoanID
    JOIN Book B ON MB.BookID = B.BookID
    WHERE B.LibraryID NOT IN (
        SELECT LibraryID FROM Library_Revenue
    );

    -- Step 2: Update revenue for each relevant LibraryID
    UPDATE LR
    SET LR.Total_Revenue = LR.Total_Revenue + T.Amount
    FROM Library_Revenue LR
    JOIN (
        SELECT B.LibraryID, SUM(INS.Amount) AS Amount
        FROM INSERTED INS
        JOIN Loan L ON INS.LoanID = L.LoanID
        JOIN Member_books MB ON MB.LoanID = L.LoanID
        JOIN Book B ON MB.BookID = B.BookID
        GROUP BY B.LibraryID
    ) T ON LR.LibraryID = T.LibraryID;
END;





