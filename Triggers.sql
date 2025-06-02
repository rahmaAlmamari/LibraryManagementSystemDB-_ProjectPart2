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


