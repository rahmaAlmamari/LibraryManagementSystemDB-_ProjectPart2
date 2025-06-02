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

--4. fn_GetMemberLoanCount 
--Return the total number of loans made by a given member. 

CREATE FUNCTION fn_GetMemberLoanCount (
    @MemberID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @TotalLoans INT;

    SELECT @TotalLoans = COUNT(DISTINCT MB.LoanID)
    FROM Member_books MB
    WHERE MB.MemberID = @MemberID;

    RETURN ISNULL(@TotalLoans, 0);
END;

--to run fn_GetMemberLoanCount

SELECT dbo.fn_GetMemberLoanCount(1) AS TotalLoans;

--5. fn_GetLateReturnDays 
--Return the number of late days for a loan (0 if not late). 

CREATE FUNCTION fn_GetLateReturnDays (
    @LoanID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @LateDays INT;

    SELECT @LateDays = 
        CASE 
            WHEN L.Return_Date > L.Due_Date THEN DATEDIFF(DAY, L.Due_Date, L.Return_Date)
            ELSE 0
        END
    FROM Loan L
    WHERE L.LoanID = @LoanID;

    RETURN ISNULL(@LateDays, 0);
END;

--to run fn_GetLateReturnDays

SELECT dbo.fn_GetLateReturnDays(101) AS LateDays;

--6. fn_ListAvailableBooksByLibrary 
--Returns a table of available books from a specific library. 

CREATE FUNCTION fn_ListAvailableBooksByLibrary (
    @LibraryID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        B.BookID,
        B.Title,
        B.Genre,
        B.Shelf_Location,
        B.Price,
        B.Availability_Status
    FROM Book B
    WHERE B.LibraryID = @LibraryID
      AND B.Availability_Status = 'TRUE'
);

--to run fn_ListAvailableBooksByLibrary

SELECT * FROM dbo.fn_ListAvailableBooksByLibrary(2);

--7. fn_GetTopRatedBooks 
--Returns books with average rating ≥ 4.5 

CREATE FUNCTION fn_GetTopRatedBooks()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        B.BookID,
        B.Title,
        B.Genre,
        AVG(R.Rating) AS AverageRating
    FROM Book B
    JOIN Member_reviewed_books MRB ON B.BookID = MRB.BookID
    JOIN Review R ON MRB.ReviewID = R.ReviewID
    GROUP BY B.BookID, B.Title, B.Genre
    HAVING AVG(R.Rating) >= 4.5
);

--to run fn_GetTopRatedBooks

SELECT * FROM dbo.fn_GetTopRatedBooks();

--8. fn_FormatMemberName 
--Returns the full name formatted as "LastName, FirstName"

CREATE FUNCTION fn_FormatMemberName (
    @MemberID INT
)
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @FormattedName VARCHAR(255);

    SELECT @FormattedName = 
        CASE 
            WHEN CHARINDEX(' ', M.Full_Name) > 0 THEN
                RIGHT(M.Full_Name, LEN(M.Full_Name) - CHARINDEX(' ', M.Full_Name)) + ', ' + 
                LEFT(M.Full_Name, CHARINDEX(' ', M.Full_Name) - 1)
            ELSE
                M.Full_Name  -- If only one name exists
        END
    FROM Member M
    WHERE M.MemberID = @MemberID;

    RETURN @FormattedName;
END;

--to run fn_FormatMemberName

SELECT dbo.fn_FormatMemberName(1) AS FormattedName;


-- Q/ Where would such functions be used in a frontend (e.g., member profile, book search, admin analytics)? 

--1. fn_GetMemberLoanCount
--Use in Frontend:
--1.1. Member Profile Page → Show total books borrowed.
--1.2.Admin Dashboard → Highlight most active members.

-- 2. fn_GetBookAverageRating(BookID)
--Use in Frontend:
--2.1. Book Detail Page → Show average rating prominently.
--2.2. Book Search Results → Add star ratings beside titles.

--3. fn_ListAvailableBooksByLibrary(LibraryID)
--Use in Frontend:
--3.1. Library Catalog Page → Display only available books for borrowing.
--3.2. Staff System → Help with re-stocking and circulation decisions.

--4. fn_GetTopRatedBooks()
--Use in Frontend:
--4.1. Homepage "Recommended" Section → Feature books with high ratings.
--4.2. Genre Browsing → Highlight critically loved books.

--5. fn_GetLateReturnDays(LoanID)
--Use in Frontend:
--5.1. User Loan History → Mark overdue books and late days.
--5.2. Fine Calculation Page → Trigger fine estimations for late returns.

--6. CalculateLibraryOccupancyRate(LibraryID)
--Use in Frontend:
--6.1. Admin Analytics Panel → Visual gauge of library book usage.
--6.2. Library Performance Reports → Help optimize inventory.

--7. GetNextAvailableBook(Genre, Title, LibraryID)
--Use in Frontend:
--7.1. Book Reservation System → Suggest next available copy if the desired one is unavailable.
--7.2. Waiting List Management → Automatically notify when a copy is ready.

--8. fn_FormatMemberName(MemberID)
--Use in Frontend:
--8.1. Admin Lists or Reports → Display names in consistent, professional format (LastName, FirstName).
--8.2. Email Templates / Letters → Use formatted names in formal communication.