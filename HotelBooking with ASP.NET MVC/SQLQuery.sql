-- mode:
-- RoomType, BedType, ACType, Enabled
CREATE PROCEDURE GetAllRooms
AS
SELECT * 
FROM dbo.Room
GO
--EXEC GetAllRooms

CREATE PROCEDURE GetRoomById @Id INT
AS
SELECT * 
FROM Room
WHERE ID = @Id 
GO
--EXEC GetRoomById @Id = 1

CREATE PROCEDURE GetRoomByEnabled 
AS
SELECT * 
FROM Room
WHERE [Enabled] = 1 
GO
--EXEC GetRoomByEnabled 

CREATE PROCEDURE GetRoomByRoomType @RoomType varchar(50)
AS
SELECT * 
FROM Room
WHERE [RoomType] = @RoomType
GO
--EXEC GetRoomByRoomType @RoomType = 'ingle'

CREATE PROCEDURE GetRoomByBedType @BedType varchar(50)
AS
SELECT * 
FROM Room
WHERE [BedType] = @BedType
GO
--EXEC GetRoomByBedType @BedType = 'Queen'

CREATE PROCEDURE GetRoomByACType @ACType varchar(50)
AS
SELECT * 
FROM Room
WHERE [ACType] = @ACType
GO

CREATE PROCEDURE GetRoomByRoomNumber @RoomNumber int
AS
SELECT * 
FROM Room
WHERE [RoomNumber] = @RoomNumber
GO

CREATE PROCEDURE GetRoomByRoomTypeAndBedType @RoomType varchar(50), @BedType varchar(50)
AS
SELECT * 
FROM Room
WHERE [RoomType] = @RoomType AND [BedType]=@BedType
GO

CREATE PROCEDURE GetRoomByRoomTypeAndACType @RoomType varchar(50), @ACType varchar(50)
AS
SELECT * 
FROM Room
WHERE [RoomType] = @RoomType AND [ACType]=@ACType
GO

CREATE PROCEDURE GetRoomBy3Types @RoomType varchar(50),@BedType varchar(50), @ACType varchar(50)
AS
SELECT * 
FROM Room
WHERE [RoomType] = @RoomType AND [ACType]=@ACType AND [BedType] = @BedType
GO

CREATE PROCEDURE GetFilteredRoomsByMode @Mode int, @RoomType varchar(50),@BedType varchar(50), @ACType varchar(50), @Enabled bit
AS

if( @mode = 0 )
begin
    SELECT *
	FROM Room
end

else if( @mode = 1 )
begin
    SELECT * 
	FROM Room
	WHERE [Enabled] = @Enabled
end

else if( @mode = 10 )
begin
    SELECT * 
	FROM Room
	WHERE [ACType] = @ACType
end

else if( @mode = 11 )
begin
    SELECT * 
	FROM Room
	WHERE [ACType] = @ACType AND [Enabled] = @Enabled
end

else if( @mode = 100 )
begin
    SELECT *
	FROM Room
	WHERE [BedType] = @BedType
end

else if( @mode = 101 )
begin
    SELECT * 
	FROM Room
	WHERE [Enabled] = @Enabled AND [BedType] = @BedType
end

else if( @mode = 110 )
begin
    SELECT * 
	FROM Room
	WHERE [ACType] = @ACType AND [BedType] = @BedType
end

else if( @mode = 111 )
begin
    SELECT * 
	FROM Room
	WHERE [ACType] = @ACType AND [Enabled] = @Enabled AND [BedType] = @BedType
end

else if( @mode = 1000 )
begin
    SELECT *
	FROM Room
	WHERE [RoomType] = @RoomType
end

else if( @mode = 1001 )
begin
    SELECT * 
	FROM Room
	WHERE [Enabled] = @Enabled AND [RoomType] = @RoomType
end

else if( @mode = 1010 )
begin
    SELECT * 
	FROM Room
	WHERE [ACType] = @ACType AND [RoomType] = @RoomType
end

else if( @mode = 1011 )
begin
    SELECT * 
	FROM Room
	WHERE [ACType] = @ACType AND [Enabled] = @Enabled AND [RoomType] = @RoomType
end

else if( @mode = 1100 )
begin
    SELECT *
	FROM Room
	WHERE [BedType] = @BedType AND [RoomType] = @RoomType
end

else if( @mode = 1101 )
begin
    SELECT * 
	FROM Room
	WHERE [Enabled] = @Enabled AND [BedType] = @BedType AND [RoomType] = @RoomType
end

else if( @mode = 1110 )
begin
    SELECT * 
	FROM Room
	WHERE [ACType] = @ACType AND [BedType] = @BedType AND [RoomType] = @RoomType
end

else if( @mode = 1111 )
begin
    SELECT * 
	FROM Room
	WHERE [ACType] = @ACType AND [Enabled] = @Enabled AND [BedType] = @BedType AND [RoomType] = @RoomType
end
GO

CREATE PROCEDURE AddANewRoom  @RoomNumber int,@RoomType varchar(50),@BedType varchar(50), @ACType varchar(50),@Price money, @Enabled bit
AS
INSERT INTO Room ([RoomNumber], [RoomType],[BedType] ,[ACType],[Price],[Enabled])
VALUES (@RoomNumber, @RoomType, @BedType,@ACType,@Price,@Enabled)
GO

CREATE PROCEDURE UpdateARoom  @ID int,@RoomNumber int,@RoomType varchar(50),@BedType varchar(50), @ACType varchar(50),@Price money, @Enabled bit
AS
UPDATE Room
SET [RoomNumber]=@RoomNumber, [RoomType]=@RoomType, [BedType]=@BedType, [ACType]=@ACType, [Price]=@Price, [Enabled]=@Enabled
WHERE [ID]=@ID
GO

CREATE PROCEDURE DeleteARoom  @ID int
AS
DELETE Room
WHERE [ID] = @ID
GO

CREATE PROCEDURE GetFilteredRoomsByModeAndDate @Mode int, @RoomType varchar(50),@BedType varchar(50), @ACType varchar(50), @Enabled bit, @StartDate date, @EndDate date
AS

-- a = @StartDate
-- b = dateadd(day,-1,@EndDate)
-- A = Booking.StartDate
-- B = dateadd(day,-1,Booking.EndDate)

if( @mode = 0 )
begin
	SELECT *
	FROM Room
	WHERE Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
end

else if( @mode = 1 )
begin
    SELECT * 
	FROM Room
	WHERE [Enabled] = @Enabled 
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
end

else if( @mode = 10 )
begin
    SELECT * 
	FROM Room
	WHERE [ACType] = @ACType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
end

else if( @mode = 11 )
begin
    SELECT * 
	FROM Room
	WHERE [ACType] = @ACType AND [Enabled] = @Enabled
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
end

else if( @mode = 100 )
begin
    SELECT *
	FROM Room
	WHERE [BedType] = @BedType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
end

else if( @mode = 101 )
begin
    SELECT * 
	FROM Room
	WHERE [Enabled] = @Enabled AND [BedType] = @BedType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
end

else if( @mode = 110 )
begin
    SELECT * 
	FROM Room
	WHERE [ACType] = @ACType AND [BedType] = @BedType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
end

else if( @mode = 111 )
begin
    SELECT * 
	FROM Room
	WHERE [ACType] = @ACType AND [Enabled] = @Enabled AND [BedType] = @BedType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
end

else if( @mode = 1000 )
begin
    SELECT *
	FROM Room
	WHERE [RoomType] = @RoomType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
end

else if( @mode = 1001 )
begin
    SELECT * 
	FROM Room
	WHERE [Enabled] = @Enabled AND [RoomType] = @RoomType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
end

else if( @mode = 1010 )
begin
    SELECT * 
	FROM Room
	WHERE [ACType] = @ACType AND [RoomType] = @RoomType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
end

else if( @mode = 1011 )
begin
    SELECT * 
	FROM Room
	WHERE [ACType] = @ACType AND [Enabled] = @Enabled AND [RoomType] = @RoomType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
end

else if( @mode = 1100 )
begin
    SELECT *
	FROM Room
	WHERE [BedType] = @BedType AND [RoomType] = @RoomType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
end

else if( @mode = 1101 )
begin
    SELECT * 
	FROM Room
	WHERE [Enabled] = @Enabled AND [BedType] = @BedType AND [RoomType] = @RoomType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
end

else if( @mode = 1110 )
begin
    SELECT * 
	FROM Room
	WHERE [ACType] = @ACType AND [BedType] = @BedType AND [RoomType] = @RoomType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
end

else if( @mode = 1111 )
begin
    SELECT * 
	FROM Room
	WHERE [ACType] = @ACType AND [Enabled] = @Enabled AND [BedType] = @BedType AND [RoomType] = @RoomType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
end
GO


CREATE PROCEDURE GetGroupedFilteredRoomsByModeAndDate @Mode int, @RoomType varchar(50),@BedType varchar(50), @ACType varchar(50), @Enabled bit, @StartDate date, @EndDate date
AS

-- a = @StartDate
-- b = dateadd(day,-1,@EndDate)
-- A = Booking.StartDate
-- B = dateadd(day,-1,Booking.EndDate)

if( @mode = 0 )
begin
	SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
			[RoomType],[BedType],[ACType],[Price]
	FROM Room
	WHERE Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
	GROUP BY [RoomType],[BedType],[ACType],[Price]
end

else if( @mode = 1 )
begin
    	SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
			[RoomType],[BedType],[ACType],[Price]
	FROM Room
	WHERE [Enabled] = @Enabled 
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
			GROUP BY [RoomType],[BedType],[ACType],[Price]
end

else if( @mode = 10 )
begin
    	SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
			[RoomType],[BedType],[ACType],[Price]
	FROM Room
	WHERE [ACType] = @ACType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
			GROUP BY [RoomType],[BedType],[ACType],[Price]
end

else if( @mode = 11 )
begin
	SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
			[RoomType],[BedType],[ACType],[Price]
	FROM Room
	WHERE [ACType] = @ACType AND [Enabled] = @Enabled
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
			GROUP BY [RoomType],[BedType],[ACType],[Price]
end

else if( @mode = 100 )
begin
	SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
			[RoomType],[BedType],[ACType],[Price]
	FROM Room
	WHERE [BedType] = @BedType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
			GROUP BY [RoomType],[BedType],[ACType],[Price]
end

else if( @mode = 101 )
begin
	SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
			[RoomType],[BedType],[ACType],[Price]
	FROM Room
	WHERE [Enabled] = @Enabled AND [BedType] = @BedType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
			GROUP BY [RoomType],[BedType],[ACType],[Price]
end

else if( @mode = 110 )
begin
	SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
			[RoomType],[BedType],[ACType],[Price]
	FROM Room
	WHERE [ACType] = @ACType AND [BedType] = @BedType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
			GROUP BY [RoomType],[BedType],[ACType],[Price]
end

else if( @mode = 111 )
begin
	SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
			[RoomType],[BedType],[ACType],[Price]
	FROM Room
	WHERE [ACType] = @ACType AND [Enabled] = @Enabled AND [BedType] = @BedType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
			GROUP BY [RoomType],[BedType],[ACType],[Price]
end

else if( @mode = 1000 )
begin
	SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
			[RoomType],[BedType],[ACType],[Price]
	FROM Room
	WHERE [RoomType] = @RoomType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
			GROUP BY [RoomType],[BedType],[ACType],[Price]
end

else if( @mode = 1001 )
begin
	SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
			[RoomType],[BedType],[ACType],[Price]
	FROM Room
	WHERE [Enabled] = @Enabled AND [RoomType] = @RoomType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
			GROUP BY [RoomType],[BedType],[ACType],[Price]
end

else if( @mode = 1010 )
begin
	SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
			[RoomType],[BedType],[ACType],[Price]
	FROM Room
	WHERE [ACType] = @ACType AND [RoomType] = @RoomType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
			GROUP BY [RoomType],[BedType],[ACType],[Price]
end

else if( @mode = 1011 )
begin
	SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
			[RoomType],[BedType],[ACType],[Price]
	FROM Room
	WHERE [ACType] = @ACType AND [Enabled] = @Enabled AND [RoomType] = @RoomType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
			GROUP BY [RoomType],[BedType],[ACType],[Price]
end

else if( @mode = 1100 )
begin
	SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
			[RoomType],[BedType],[ACType],[Price]
	FROM Room
	WHERE [BedType] = @BedType AND [RoomType] = @RoomType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
			GROUP BY [RoomType],[BedType],[ACType],[Price]
end

else if( @mode = 1101 )
begin
	SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
			[RoomType],[BedType],[ACType],[Price]
	FROM Room
	WHERE [Enabled] = @Enabled AND [BedType] = @BedType AND [RoomType] = @RoomType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
			GROUP BY [RoomType],[BedType],[ACType],[Price]
end

else if( @mode = 1110 )
begin
	SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
			[RoomType],[BedType],[ACType],[Price]
	FROM Room
	WHERE [ACType] = @ACType AND [BedType] = @BedType AND [RoomType] = @RoomType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
			GROUP BY [RoomType],[BedType],[ACType],[Price]
end

else if( @mode = 1111 )
begin
	SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
			[RoomType],[BedType],[ACType],[Price]
	FROM Room
	WHERE [ACType] = @ACType AND [Enabled] = @Enabled AND [BedType] = @BedType AND [RoomType] = @RoomType
	AND Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
			GROUP BY [RoomType],[BedType],[ACType],[Price]
end
GO

CREATE PROCEDURE GetAllBookings 
AS
SELECT * 
FROM Booking
GO

CREATE PROCEDURE GetAllPastBookings 
AS
if(DATENAME(HH,GETDATE())>=11)
begin
	SELECT * 
	FROM Booking
	WHERE Booking.EndDate<=getdate()
end
else
begin
	SELECT * 
	FROM Booking
	WHERE Booking.EndDate<getdate()
end
GO

CREATE PROCEDURE GetAllCurrentBookings 
AS
if(DATENAME(HH,GETDATE())<11)
begin
	SELECT * 
	FROM Booking
	WHERE Booking.StartDate<getdate() AND Booking.EndDate>=getdate()
end
else if(DATENAME(HH,GETDATE())>=11 AND DATENAME(HH,GETDATE())<15)
begin
	SELECT * 
	FROM Booking
	WHERE Booking.StartDate<getdate() AND Booking.EndDate>getdate()
end
else 
begin
	SELECT * 
	FROM Booking
	WHERE Booking.StartDate<=getdate() AND Booking.EndDate>getdate()
end

GO

CREATE PROCEDURE GetAllFutureBookings 
AS
if(DATENAME(HH,GETDATE())>=15)
begin
	SELECT * 
	FROM Booking
	WHERE Booking.StartDate>getdate()
end
else
begin
	SELECT * 
	FROM Booking
	WHERE Booking.StartDate>=getdate()
end
GO


CREATE PROCEDURE GetPastBookingsOfOneUser @UserID varchar(50)
AS
if(DATENAME(HH,GETDATE())>=11)
begin
	SELECT * 
	FROM Booking
	WHERE Booking.EndDate<=getdate() AND Booking.BookedUserID=@UserID
end
else
begin
	SELECT * 
	FROM Booking
	WHERE Booking.EndDate<getdate() AND Booking.BookedUserID=@UserID
end
GO

CREATE PROCEDURE GetCurrentBookingsOfOneUser  @UserID varchar(50)
AS
if(DATENAME(HH,GETDATE())<11)
begin
	SELECT * 
	FROM Booking
	WHERE Booking.StartDate<getdate() AND Booking.EndDate>=getdate() AND Booking.BookedUserID=@UserID
end
else if(DATENAME(HH,GETDATE())>=11 AND DATENAME(HH,GETDATE())<15)
begin
	SELECT * 
	FROM Booking
	WHERE Booking.StartDate<getdate() AND Booking.EndDate>getdate() AND Booking.BookedUserID=@UserID
end
else 
begin
	SELECT * 
	FROM Booking
	WHERE Booking.StartDate<=getdate() AND Booking.EndDate>getdate() AND Booking.BookedUserID=@UserID
end

GO

CREATE PROCEDURE GetFutureBookingsOfOneUser @UserID varchar(50)
AS
if(DATENAME(HH,GETDATE())>=15)
begin
	SELECT * 
	FROM Booking
	WHERE Booking.StartDate>getdate() AND Booking.BookedUserID=@UserID
end
else
begin
	SELECT * 
	FROM Booking
	WHERE Booking.StartDate>=getdate() AND Booking.BookedUserID=@UserID
end
GO

CREATE PROCEDURE UpdateABooking  @ID int,@StartDate date,@EndDate date,@BookedRoomId int, @BookedUserId varchar(50),@TotalPrice money
AS
UPDATE Booking
SET [StartDate]=@StartDate, [EndDate]=@EndDate, [BookedRoomID]=@BookedRoomId, [BookedUserId]=@BookedUserId, [TotalPrice]=@TotalPrice
WHERE [ID]=@ID
GO

CREATE PROCEDURE DeleteABooking  @ID int
AS
DELETE Booking
WHERE [ID] = @ID
GO

CREATE PROCEDURE AddABooking  @StartDate date,@EndDate date,@BookedRoomId int, @BookedUserId varchar(50),@TotalPrice money
AS
INSERT INTO Booking ([StartDate], [EndDate], [BookedRoomID], [BookedUserId], [TotalPrice])
VALUES(@StartDate, @EndDate, @BookedRoomId, @BookedUserId, @TotalPrice)
GO

-- Not create yet, need modify.
CREATE PROCEDURE GetRoomsByDetails  @RoomType varchar(50),@BedType varchar(50), @ACType varchar(50), @Enabled bit, @StartDate date, @EndDate date,@Price money
AS

-- a = @StartDate
-- b = dateadd(day,-1,@EndDate)
-- A = Booking.StartDate
-- B = dateadd(day,-1,Booking.EndDate)



	SELECT *
	FROM Room
	WHERE [RoomType] = @RoomType AND [BedType]=@BedType AND [ACType]=@ACType AND [Enabled]=@Enabled AND [Price]=@Price
	AND
	Room.ID NOT IN (
    SELECT BookedRoomID
	FROM Booking
	WHERE (@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)<=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate>=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
		OR(@StartDate<=Booking.StartDate 
			AND @StartDate<=dateadd(day,-1,Booking.EndDate)
			AND dateadd(day,-1,@EndDate)>=Booking.StartDate
			AND dateadd(day,-1,@EndDate)>=dateadd(day,-1,Booking.EndDate))
			)
			

CREATE PROCEDURE GetBookingByID  @ID int
AS
SELECT *
FROM Booking
WHERE ID=@ID
GO

EXEC GetGroupedFilteredRoomsByModeAndDate @Mode=1, @RoomType = null,@BedType=null, @ACType =null,@Enabled=1,@StartDate='03/23/2021',@EndDate='03/26/2021'

select DATENAME(HH,GETDATE()) --05

SELECT COUNT(*) AS 'TheNumberOfAvailableRooms',
		[RoomType],[BedType],[ACType],[Price]
FROM Room
WHERE [Enabled] = 1 
--AND Room.ID NOT IN (
--SELECT BookedRoomID
--FROM Booking
--WHERE ('03/23/2021'<=Booking.StartDate 
--		AND '03/23/2021'<=dateadd(day,-1,Booking.EndDate)
--		AND dateadd(day,-1,'03/26/2021')>=Booking.StartDate
--		AND dateadd(day,-1,'03/26/2021')<=dateadd(day,-1,Booking.EndDate))
--	OR('03/23/2021'>=Booking.StartDate 
--		AND '03/23/2021'<=dateadd(day,-1,Booking.EndDate)
--		AND dateadd(day,-1,'03/26/2021')>=Booking.StartDate
--		AND dateadd(day,-1,'03/26/2021')<=dateadd(day,-1,Booking.EndDate))
--	OR('03/23/2021'>=Booking.StartDate 
--		AND '03/23/2021'<=dateadd(day,-1,Booking.EndDate)
--		AND dateadd(day,-1,'03/26/2021')>=Booking.StartDate
--		AND dateadd(day,-1,'03/26/2021')>=dateadd(day,-1,Booking.EndDate))
--	OR('03/23/2021'<=Booking.StartDate 
--		AND '03/23/2021'<=dateadd(day,-1,Booking.EndDate)
--		AND dateadd(day,-1,'03/26/2021')>=Booking.StartDate
--		AND dateadd(day,-1,'03/26/2021')>=dateadd(day,-1,Booking.EndDate))
--		)
GROUP BY [RoomType],[BedType],[ACType],[Price]


EXEC GetAllCurrentBookings