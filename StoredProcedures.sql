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

