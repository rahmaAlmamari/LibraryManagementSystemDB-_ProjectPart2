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



