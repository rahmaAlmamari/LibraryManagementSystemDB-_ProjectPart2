--Stored Procedures – Backend Automation 
--Stored procedures for system automation 

--USE DB
USE LibraryManagementSystem;

--1. sp_MarkBookUnavailable(BookID) 
--Updates availability after issuing 

CREATE PROCEDURE sp_MarkBookUnavailable
    @BookID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Book 
    SET Availability_Status = 'FALSE'
    WHERE BookID = @BookID;
END;

--to Execute sp_MarkBookUnavailable(BookID) 
EXEC sp_MarkBookUnavailable @BookID = 123;

--2. sp_UpdateLoanStatus() 
--Checks dates and updates loan statuses 

CREATE PROCEDURE sp_UpdateLoanStatus
AS
BEGIN
    SET NOCOUNT ON;

    -- Update status to 'Overdue' where Return_Date < GETDATE()
    UPDATE MB
    SET MB.Status = 'Overdue'
    FROM Member_books MB
    JOIN Loan L ON MB.LoanID = L.LoanID
    WHERE L.Return_Date < GETDATE();

    -- Update status to 'Returned' where Return_Date >= GETDATE()
    UPDATE MB
    SET MB.Status = 'Returned'
    FROM Member_books MB
    JOIN Loan L ON MB.LoanID = L.LoanID
    WHERE L.Return_Date >= GETDATE();
END;

--to Execute sp_UpdateLoanStatus

EXEC sp_UpdateLoanStatus;

--3. sp_RankMembersByFines() 
--Ranks members by total fines paid 

CREATE PROCEDURE sp_RankMembersByFines
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        MB.MemberID,
        SUM(P.Amount) AS TotalFinesPaid,
        RANK() OVER (ORDER BY SUM(P.Amount) DESC) AS FineRank
    FROM Payment P
    JOIN Loan L ON P.LoanID = L.LoanID
    JOIN Member_books MB ON L.LoanID = MB.LoanID
    GROUP BY MB.MemberID;
END;

--to Execute sp_RankMembersByFines

EXEC sp_RankMembersByFines;





