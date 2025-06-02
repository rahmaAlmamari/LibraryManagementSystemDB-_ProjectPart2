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

--3. CalculateLibraryOccupancyRate(LibraryID) 
--Returns % of books currently issued 

CREATE FUNCTION CalculateLibraryOccupancyRate (
    @LibraryID INT
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @TotalBooks INT;
    DECLARE @IssuedBooks INT;
    DECLARE @OccupancyRate FLOAT;

    -- Count total books in the library
    SELECT @TotalBooks = COUNT(*)
    FROM Book B
    WHERE B.LibraryID = @LibraryID;

    -- Count books that are not available (assumed 'FALSE' = issued)
    SELECT @IssuedBooks = COUNT(*)
    FROM Book B
    WHERE B.LibraryID = @LibraryID AND B.Availability_Status = 'FALSE';

    -- Calculate occupancy rate (avoid division by zero)
    SET @OccupancyRate = 
        CASE 
            WHEN @TotalBooks = 0 THEN 0 
            ELSE CAST(@IssuedBooks AS FLOAT) * 100 / @TotalBooks 
        END;

    RETURN @OccupancyRate;
END;

--to run CalculateLibraryOccupancyRate

SELECT dbo.CalculateLibraryOccupancyRate(1) AS OccupancyRate;




