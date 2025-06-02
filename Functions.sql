--Functions – Reusable Logic 
--User-defined functions for encapsulated logic 

--USE DB
USE LibraryManagementSystem;

--1. GetBookAverageRating(BookID) 
--Returns average rating of a book 

CREATE FUNCTION GetBookAverageRating(@BookID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @AvgRating FLOAT;

    SELECT @AvgRating = AVG(CAST(R.Rating AS FLOAT))
    FROM Review R
    JOIN Member_reviewed_books MRB ON R.ReviewID = MRB.ReviewID
    WHERE MRB.BookID = @BookID;

    RETURN ISNULL(@AvgRating, 0);
END;

--to call GetBookAverageRating

SELECT dbo.GetBookAverageRating(123) AS AverageRating;

--2. GetNextAvailableBook(Genre, Title, LibraryID) 
--Fetches the next available book 

CREATE FUNCTION GetNextAvailableBook (
    @Genre VARCHAR(255),
    @Title VARCHAR(255),
    @LibraryID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @NextBookID INT;

    SELECT TOP 1 @NextBookID = B.BookID
    FROM Book B
    WHERE 
        B.Genre = @Genre AND
        B.Title = @Title AND
        B.LibraryID = @LibraryID AND
        B.Availability_Status = 'TRUE'
    ORDER BY B.BookID;

    RETURN @NextBookID;
END;

--to call GetNextAvailableBook

SELECT dbo.GetNextAvailableBook('Fiction', 'Harry Potter', 1) AS NextBookID;




