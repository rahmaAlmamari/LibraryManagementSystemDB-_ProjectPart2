--Transactions – Ensuring Consistency 
--Transaction scripts for atomic operations 

--USE DB
USE LibraryManagementSystem;

--Real-world transactional flows: 
--1. Borrowing a book (loan insert + update availability) 

ALTER TABLE Loan
ALTER COLUMN Return_Date DATE NULL;

DECLARE @MemberID INT = 1;
DECLARE @BookID INT = 2;
DECLARE @LoanID INT = 3;

-- Check availability before inserting
SELECT * FROM BOOK WHERE BookID = @BookID;

-- FIRST: ROLLBACK VERSION
BEGIN TRANSACTION
	DECLARE @LoanID1 INT;

	-- Insert into LOAN
	INSERT INTO LOAN (Loan_Date, Due_Date, Return_Date)
	VALUES (GETDATE(), DATEADD(DAY, 14, GETDATE()), NULL);

	SET @LoanID1 = SCOPE_IDENTITY();

	-- Insert into MEMBER_BOOKS
	INSERT INTO MEMBER_BOOKS (Status, LoanID, MemberID, BookID)
	VALUES ('Issued', @LoanID, @MemberID, @BookID);

	-- Update BOOK availability
	UPDATE BOOK
	SET Availability_Status = 'Checked Out'
	WHERE BookID = @BookID;

ROLLBACK;

-- Check result
SELECT * FROM MEMBER_BOOKS;
SELECT * FROM BOOK;

-- SECOND: COMMIT VERSION
BEGIN TRANSACTION
	DECLARE @LoanID2 INT;

	INSERT INTO LOAN (Loan_Date, Due_Date, Return_Date)
	VALUES (GETDATE(), DATEADD(DAY, 14, GETDATE()), NULL);

	SET @LoanID2 = SCOPE_IDENTITY();

	INSERT INTO MEMBER_BOOKS (Status, LoanID, MemberID, BookID)
	VALUES ('Issued', @LoanID, @MemberID, @BookID);

	UPDATE BOOK
	SET Availability_Status = 'Checked Out'
	WHERE BookID = @BookID;

COMMIT;

-- Final check
SELECT * FROM MEMBER_BOOKS;
SELECT * FROM BOOK;

-- THIRD: TRY-CATCH VERSION
BEGIN TRY
	BEGIN TRANSACTION;

	DECLARE @LoanID3 INT;

	INSERT INTO LOAN (Loan_Date, Due_Date, Return_Date)
	VALUES (GETDATE(), DATEADD(DAY, 14, GETDATE()), NULL);

	SET @LoanID3 = SCOPE_IDENTITY();

	-- Confirm LoanID is not null
	IF @LoanID3 IS NULL
		THROW 50000, 'Loan insert failed - LoanID is NULL', 1;

	INSERT INTO MEMBER_BOOKS (Status, LoanID, MemberID, BookID)
	VALUES ('Issued', @LoanID, @MemberID, @BookID);

	UPDATE BOOK
	SET Availability_Status = 'Checked Out'
	WHERE BookID = @BookID;

	COMMIT;
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_LINE() AS Line, ERROR_MESSAGE() AS Msg, ERROR_NUMBER() AS Code;
END CATCH;

