--Transactions – Ensuring Consistency 
--Transaction scripts for atomic operations 

--USE DB
USE LibraryManagementSystem;

--Real-world transactional flows: 
--1. Borrowing a book (loan insert + update availability) 

ALTER TABLE Loan
ALTER COLUMN Return_Date DATE NULL;

--DECLARE @MemberID INT = 1;
--DECLARE @BookID INT = 2;
--DECLARE @LoanID INT = 3;

---- Check availability before inserting
--SELECT * FROM BOOK WHERE BookID = @BookID;

---- FIRST: ROLLBACK VERSION
--BEGIN TRANSACTION
--	DECLARE @LoanID1 INT;

--	-- Insert into LOAN
--	INSERT INTO LOAN (Loan_Date, Due_Date, Return_Date)
--	VALUES (GETDATE(), DATEADD(DAY, 14, GETDATE()), NULL);

--	SET @LoanID1 = SCOPE_IDENTITY();

--	-- Insert into MEMBER_BOOKS
--	INSERT INTO MEMBER_BOOKS (Status, LoanID, MemberID, BookID)
--	VALUES ('Issued', @LoanID, @MemberID, @BookID);

--	-- Update BOOK availability
--	UPDATE BOOK
--	SET Availability_Status = 'Checked Out'
--	WHERE BookID = @BookID;

--ROLLBACK;

---- Check result
--SELECT * FROM MEMBER_BOOKS;
--SELECT * FROM BOOK;

---- SECOND: COMMIT VERSION
--BEGIN TRANSACTION
--	DECLARE @LoanID2 INT;

--	INSERT INTO LOAN (Loan_Date, Due_Date, Return_Date)
--	VALUES (GETDATE(), DATEADD(DAY, 14, GETDATE()), NULL);

--	SET @LoanID2 = SCOPE_IDENTITY();

--	INSERT INTO MEMBER_BOOKS (Status, LoanID, MemberID, BookID)
--	VALUES ('Issued', @LoanID, @MemberID, @BookID);

--	UPDATE BOOK
--	SET Availability_Status = 'Checked Out'
--	WHERE BookID = @BookID;

--COMMIT;

---- Final check
--SELECT * FROM MEMBER_BOOKS;
--SELECT * FROM BOOK;

---- THIRD: TRY-CATCH VERSION
--BEGIN TRY
--	BEGIN TRANSACTION;

--	DECLARE @LoanID3 INT;

--	INSERT INTO LOAN (Loan_Date, Due_Date, Return_Date)
--	VALUES (GETDATE(), DATEADD(DAY, 14, GETDATE()), NULL);

--	SET @LoanID3 = SCOPE_IDENTITY();

--	-- Confirm LoanID is not null
--	IF @LoanID3 IS NULL
--		THROW 50000, 'Loan insert failed - LoanID is NULL', 1;

--	INSERT INTO MEMBER_BOOKS (Status, LoanID, MemberID, BookID)
--	VALUES ('Issued', @LoanID, @MemberID, @BookID);

--	UPDATE BOOK
--	SET Availability_Status = 'Checked Out'
--	WHERE BookID = @BookID;

--	COMMIT;
--END TRY
--BEGIN CATCH
--	ROLLBACK;
--	SELECT ERROR_LINE() AS Line, ERROR_MESSAGE() AS Msg, ERROR_NUMBER() AS Code;
--END CATCH;

----------------------------------------------------------------------------------------------------

--2. Returning a book (update status, return date, availability)

--DECLARE @MemberID INT = 1;
--DECLARE @BookID INT = 2;
--DECLARE @LoanID INT;

---- Step 1: Get LoanID for the book issued to the member and not yet returned
--SELECT TOP 1 @LoanID = MB.LoanID
--FROM Member_books MB
--JOIN Loan L ON MB.LoanID = L.LoanID
--WHERE MB.MemberID = @MemberID AND MB.BookID = @BookID AND MB.Status = 'Issued';

---- Check before update
--SELECT * FROM Member_books WHERE MemberID = @MemberID AND BookID = @BookID;
--SELECT * FROM Book WHERE BookID = @BookID;
--SELECT * FROM Loan WHERE LoanID = @LoanID;

---- BASIC TRANSACTION (Rollback)
--BEGIN TRANSACTION
--	-- Update Member_books status to Returned
--	UPDATE Member_books
--	SET Status = 'Returned'
--	WHERE LoanID = @LoanID AND MemberID = @MemberID AND BookID = @BookID;

--	-- Update Loan return date
--	UPDATE Loan
--	SET Return_Date = GETDATE()
--	WHERE LoanID = @LoanID;

--	-- Update Book availability
--	UPDATE Book
--	SET Availability_Status = 'Available'
--	WHERE BookID = @BookID;
--ROLLBACK;

---- Check after rollback
--SELECT * FROM Member_books WHERE MemberID = @MemberID AND BookID = @BookID;
--SELECT * FROM Book WHERE BookID = @BookID;
--SELECT * FROM Loan WHERE LoanID = @LoanID;

---- COMMIT VERSION
--BEGIN TRANSACTION
--	UPDATE Member_books
--	SET Status = 'Returned'
--	WHERE LoanID = @LoanID AND MemberID = @MemberID AND BookID = @BookID;

--	UPDATE Loan
--	SET Return_Date = GETDATE()
--	WHERE LoanID = @LoanID;

--	UPDATE Book
--	SET Availability_Status = 'Available'
--	WHERE BookID = @BookID;
--COMMIT;

---- Final check
--SELECT * FROM Member_books WHERE MemberID = @MemberID AND BookID = @BookID;
--SELECT * FROM Book WHERE BookID = @BookID;
--SELECT * FROM Loan WHERE LoanID = @LoanID;

---- TRY-CATCH VERSION
--BEGIN TRY
--	BEGIN TRANSACTION;

--	-- Update Member_books status
--	UPDATE Member_books
--	SET Status = 'Returned'
--	WHERE LoanID = @LoanID AND MemberID = @MemberID AND BookID = @BookID;

--	-- Update return date
--	UPDATE Loan
--	SET Return_Date = GETDATE()
--	WHERE LoanID = @LoanID;

--	-- Update availability
--	UPDATE Book
--	SET Availability_Status = 'Available'
--	WHERE BookID = @BookID;

--	COMMIT;
--END TRY
--BEGIN CATCH
--	ROLLBACK;
--	SELECT ERROR_LINE() AS Line, ERROR_MESSAGE() AS Msg, ERROR_NUMBER() AS Code;
--END CATCH;

--------------------------------------------------------------------------------------------------

--3. Registering a payment (with validation) 

--DECLARE @LoanID INT = 1;
--DECLARE @Amount INT = 50;
--DECLARE @Method VARCHAR(255) = 'Credit Card';

---- Validate loan exists
--SELECT * FROM LOAN WHERE LoanID = @LoanID;

---- BASIC TRANSACTION with manual ROLLBACK
--BEGIN TRANSACTION
--	-- Insert into PAYMENT table
--	INSERT INTO PAYMENT (Method, Amount, Payment_Date, LoanID)
--	VALUES (@Method, @Amount, GETDATE(), @LoanID);

--ROLLBACK;

---- Check after ROLLBACK
--SELECT * FROM PAYMENT WHERE LoanID = @LoanID;

---- COMMIT VERSION
--BEGIN TRANSACTION
--	INSERT INTO PAYMENT (Method, Amount, Payment_Date, LoanID)
--	VALUES (@Method, @Amount, GETDATE(), @LoanID);

--COMMIT;

---- Final Check
--SELECT * FROM PAYMENT WHERE LoanID = @LoanID;

---- WITH TRY-CATCH VALIDATION
--BEGIN TRY
--	-- Validate amount
--	IF @Amount <= 0
--		THROW 50001, 'Payment amount must be greater than zero.', 1;

--	-- Validate LoanID exists
--	IF NOT EXISTS (SELECT 1 FROM LOAN WHERE LoanID = @LoanID)
--		THROW 50002, 'Invalid LoanID. Loan does not exist.', 1;

--	BEGIN TRANSACTION;

--		-- Insert payment
--		INSERT INTO PAYMENT (Method, Amount, Payment_Date, LoanID)
--		VALUES (@Method, @Amount, GETDATE(), @LoanID);

--	COMMIT;
--END TRY
--BEGIN CATCH
--	ROLLBACK;
--	SELECT ERROR_LINE() AS Line, ERROR_MESSAGE() AS Msg, ERROR_NUMBER() AS Code;
--END CATCH;

---- Final confirmation
--SELECT * FROM PAYMENT WHERE LoanID = @LoanID;

-------------------------------------------------------------------------------------------------------------

--4. Batch loan insert with rollback on failure 

-- Step 0: Declare and populate input batch table
--DECLARE @LoanInputs TABLE (
--    MemberID INT,
--    BookID INT
--);

---- Sample batch (adjust as needed)
--INSERT INTO @LoanInputs VALUES (1, 2), (1, 3);

--BEGIN TRANSACTION;

--DECLARE @CurrLoanID INT;
--DECLARE @CurrMemberID INT;
--DECLARE @CurrBookID INT;

--DECLARE loan_cursor CURSOR FOR
--    SELECT MemberID, BookID FROM @LoanInputs;

--OPEN loan_cursor;

--FETCH NEXT FROM loan_cursor INTO @CurrMemberID, @CurrBookID;

--WHILE @@FETCH_STATUS = 0
--BEGIN
--    PRINT '----------------------------------------'
--    PRINT 'Trying MemberID = ' + CAST(@CurrMemberID AS VARCHAR) + ', BookID = ' + CAST(@CurrBookID AS VARCHAR)

--    -- Step 1: Insert LOAN
--    BEGIN TRY
--        INSERT INTO LOAN (Loan_Date, Due_Date, Return_Date)
--        VALUES (GETDATE(), DATEADD(DAY, 14, GETDATE()), DATEADD(DAY, 20, GETDATE()));

--        SET @CurrLoanID = SCOPE_IDENTITY();

--        IF @CurrLoanID IS NULL
--        BEGIN
--            THROW 50010, 'LoanID not generated. Insert into LOAN failed.', 1;
--        END

--        PRINT 'Inserted LOAN. LoanID = ' + CAST(@CurrLoanID AS VARCHAR);

--        -- Step 2: Insert MEMBER_BOOKS
--        INSERT INTO MEMBER_BOOKS (Status, LoanID, MemberID, BookID)
--        VALUES ('Issued', @CurrLoanID, @CurrMemberID, @CurrBookID);

--        PRINT 'Inserted into MEMBER_BOOKS';

--        -- Step 3: Update BOOK
--        UPDATE BOOK
--        SET Availability_Status = 'Checked Out'
--        WHERE BookID = @CurrBookID;

--        PRINT 'Updated BOOK availability';

--    END TRY
--    BEGIN CATCH
--        ROLLBACK;
--        PRINT 'Error: ' + ERROR_MESSAGE();
--        SELECT ERROR_LINE() AS Line, ERROR_MESSAGE() AS Msg, ERROR_NUMBER() AS Code;
--        CLOSE loan_cursor;
--        DEALLOCATE loan_cursor;
--        RETURN; -- exit loop on failure
--    END CATCH

--    FETCH NEXT FROM loan_cursor INTO @CurrMemberID, @CurrBookID;
--END

--COMMIT;

--CLOSE loan_cursor;
--DEALLOCATE loan_cursor;


