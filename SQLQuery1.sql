SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- DATE
DROP TABLE IF EXISTS [dbo].[Dim_Month];
CREATE TABLE [dbo].[Dim_Month](
	[month] [int] PRIMARY KEY NOT NULL,
	[shortMonth] [nvarchar](4) NOT NULL,
	[longMonth] [nvarchar](10) NOT NULL,
	[quarter] int NOT NULL
) ON [Primary]
GO
INSERT INTO Dim_Month (month,shortMonth,longMonth, [quarter]) VALUES (1, 'Jan', 'January', 1);
INSERT INTO Dim_Month (month,shortMonth,longMonth, [quarter]) VALUES (2, 'Feb', 'February', 1);
INSERT INTO Dim_Month (month,shortMonth,longMonth, [quarter]) VALUES (3, 'Mar', 'March', 1);
INSERT INTO Dim_Month (month,shortMonth,longMonth, [quarter]) VALUES (4, 'Apr', 'April', 2);
INSERT INTO Dim_Month (month,shortMonth,longMonth, [quarter]) VALUES (5, 'May', 'May', 2);
INSERT INTO Dim_Month (month,shortMonth,longMonth, [quarter]) VALUES (6, 'Jun', 'June', 2);
INSERT INTO Dim_Month (month,shortMonth,longMonth, [quarter]) VALUES (7, 'Jul', 'July', 3);
INSERT INTO Dim_Month (month,shortMonth,longMonth, [quarter]) VALUES (8, 'Aug', 'August', 3);
INSERT INTO Dim_Month (month,shortMonth,longMonth, [quarter]) VALUES (9, 'Sep', 'September', 3);
INSERT INTO Dim_Month (month,shortMonth,longMonth, [quarter]) VALUES (10, 'Oct', 'October', 4);
INSERT INTO Dim_Month (month,shortMonth,longMonth, [quarter]) VALUES (11, 'Nov', 'November', 4);
INSERT INTO Dim_Month (month,shortMonth,longMonth, [quarter]) VALUES (12, 'Dec', 'December', 4);
GO

DROP TABLE IF EXISTS [dbo].[Dim_Weekday];
CREATE TABLE [dbo].[Dim_Weekday](
	[weekday] [int] PRIMARY KEY NOT NULL,
	[shortDay] [nvarchar](4) NOT NULL,
	[longDay] [nvarchar](10) NOT NULL
) ON [Primary]
GO
INSERT INTO Dim_Weekday (weekday,shortDay,longDay) VALUES (1, 'Sun', 'Sunday');
INSERT INTO Dim_Weekday (weekday,shortDay,longDay) VALUES (2, 'Mon', 'Monday');
INSERT INTO Dim_Weekday (weekday,shortDay,longDay) VALUES (3, 'Tue', 'Tuesday');
INSERT INTO Dim_Weekday (weekday,shortDay,longDay) VALUES (4, 'Wed', 'Wednesday');
INSERT INTO Dim_Weekday (weekday,shortDay,longDay) VALUES (5, 'Thu', 'Thursday');
INSERT INTO Dim_Weekday (weekday,shortDay,longDay) VALUES (6, 'Fri', 'Friday');
INSERT INTO Dim_Weekday (weekday,shortDay,longDay) VALUES (7, 'Sat', 'Saturday');

DROP TABLE IF EXISTS [dbo].[Dim_Date];
CREATE TABLE [dbo].[Dim_Date](
	[Date] [date] PRIMARY KEY NOT NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[WeekNum] [int] NOT NULL,
	[Day] [int] NOT NULL,
	[WeekDay] [int] NOT NULL,
	[DayType] [nvarchar](16) NOT NULL,
	[WorkHours] [decimal](12, 2) NOT NULL,
	[Remarks] [nvarchar](64) NULL,
) ON [PRIMARY]
GO

DECLARE @startDate date = '2020-01-01';
DECLARE @endDate date = '2022-01-01';
WHILE (@startDate < @endDate)
BEGIN
	PRINT @startDate;
	INSERT INTO Dim_Date ([Date], [Year], [Month], [WeekNum], [Day], [WeekDay], [DayType], [WorkHours], [Remarks]) 
	VALUES(
		@startDate, 
		DATEPART(YEAR, @startDate), 
		DATEPART(MONTH, @startDate), 
		DATEPART(WEEK, @startDate),
		DATEPART(DAY, @startDate), 
		DATEPART(WEEKDAY, @startDate), 
		'WEEKDAY', 
		8, 
		NULL
	);
	SET @startDate = DATEADD(day, 1, @startDate);
END


UPDATE Dim_Date 
SET DayType = 'WEEKEND'
WHERE WeekDay in (1,7)

-- CATEGORY
DROP TABLE IF EXISTS [dbo].[Dim_Category];
CREATE TABLE [dbo].[Dim_Category](
	[CategoryID] [numeric](8,0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[CategoryShortName] [nvarchar](12) NOT NULL,
	[CategoryLongName] [nvarchar](32) NULL,
) ON [PRIMARY]
GO

-- CUSTOMER
DROP TABLE IF EXISTS [dbo].[Dim_Customer];
CREATE TABLE [dbo].[Dim_Customer](
	[CustomerID] [numeric](8, 0) PRIMARY KEY NOT NULL,
	[CustomerName] [nvarchar](64) NOT NULL,
	[CustomerDesc] [nvarchar](256) NULL,
) ON [PRIMARY]
GO



-- EMPLOYEE
DROP TABLE IF EXISTS [dbo].[Dim_Employee];
CREATE TABLE [dbo].[Dim_Employee](
	[EmployeeID] [numeric](8, 0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[ShortName] [nvarchar](16) NOT NULL,
	[FullName] [nvarchar](64) NULL,
	[FirstName] [nvarchar](64) NULL,
	[LastName] [nvarchar](64) NULL,
	[Active] [int] NOT NULL DEFAULT 1,
) ON [PRIMARY]

--PROJECT
DROP TABLE IF EXISTS [dbo].[Dim_Project];
CREATE TABLE [dbo].[Dim_Project](
	[ProjectID] [numeric](8, 0) PRIMARY KEY NOT NULL,
	[CustomerID] [numeric](8, 0) NOT NULL,
	[ProjectName] [nvarchar](64) NOT NULL,
	[ProjectDesc] [nvarchar](256) NULL,
	[ContractValue] [decimal](12, 2) NULL,
	[StartDate] [date] NULL,
	[CloseDate] [date] NULL,
	[Close] [int] NOT NULL DEFAULT 0,
) ON [PRIMARY]
GO

-- Timesheet
DROP TABLE IF EXISTS [dbo].[Fact_TimeSheet];
CREATE TABLE [dbo].[Fact_TimeSheet](
    [SourceFile] [nvarchar](128) NOT NULL,
	[Date] [date] NOT NULL,
	[CustomerID] [numeric](8, 0) NULL,
	[ProjectID] [numeric](8, 0) NULL,
	[EmployeeID] [numeric](8, 0) NOT NULL,
	[CategoryID] [numeric](8, 0) NULL,
	[Activity] [varchar](32) NULL,
	[Hours] [numeric](8, 2) NULL,
	[ApprovedBy] [varchar](32) NULL,
	[Status] [varchar](32) NULL,
	[ExternalComment] [varchar](255) NULL
) ON [PRIMARY]
GO

DROP TABLE IF EXISTS [timereg].[TimeReport];
DROP PROCEDURE [timereg].[TimeSheetDims]
DROP SCHEMA IF EXISTS timereg;
CREATE SCHEMA timereg;
CREATE TABLE [timereg].[TimeReport](
	[filename] [nvarchar](128) NULL,
	[Date] [date] NOT NULL,
	[DataAreaId] [nvarchar](16) NULL,
	[CustomerId] [numeric](12, 0) DEFAULT 0,
	[Customer] [nvarchar](64) NULL,
	[ProjectId] [numeric](8, 0) NULL,
	[Project] [nvarchar](64) NULL,
	[Employee] [nvarchar](16) NOT NULL,
	[Fullname] [nvarchar](64) NULL,
	[CategoryShortName] [nvarchar](12) NULL,
	[Category] [nvarchar](32) NULL,
	[Activity] [nvarchar](32) NULL,
	[ExternalComment] [nvarchar](255) NULL,
	[Status] [nvarchar](32) NULL,
	[ApprovedBy] [nvarchar](32) NULL,
	[Hours] [numeric](8, 2) NULL,
	[PricePerHour] [numeric](8, 2) NULL,
	[Total] [numeric](8, 2) NULL,
	[Currency] [nvarchar](4) NULL
) ON [PRIMARY]
GO

CREATE PROCEDURE [timereg].[TimeSheetDims]
@filename [nvarchar](128)
AS

UPDATE timereg.TimeReport
SET CustomerId = 0
WHERE Customer = 'Internal - CPH'
AND filename = @filename;

INSERT INTO dbo.Dim_Customer (CustomerID, CustomerName)
SELECT DISTINCT A.CustomerId, A.Customer
FROM timereg.TimeReport A
LEFT JOIN dbo.Dim_Customer B
ON A.CustomerId = B.CustomerId
WHERE B.CustomerId IS NULL
AND A.filename = @filename;

INSERT INTO dbo.Dim_Employee (ShortName, FullName)
SELECT DISTINCT A.Employee, A.Fullname
FROM timereg.TimeReport A
LEFT JOIN dbo.Dim_Employee B
ON A.Employee = B.ShortName
WHERE B.EmployeeID IS NULL
AND A.filename = @filename;

INSERT INTO dbo.Dim_Project (ProjectID, ProjectName, CustomerID)
SELECT DISTINCT A.ProjectID, A.Project, A.CustomerID
FROM timereg.TimeReport A
LEFT JOIN dbo.Dim_Project B
ON A.ProjectId = B.ProjectID
WHERE B.ProjectID IS NULL
AND A.filename = @filename;

--DECLARE @filename nvarchar(128) = '202107.xlsx';
INSERT INTO dbo.Dim_Category (CategoryShortName, CategoryLongName)
SELECT DISTINCT A.CategoryShortName, A.Category
FROM timereg.TimeReport A
LEFT JOIN dbo.Dim_Category B
ON A.CategoryShortName = B.CategoryShortName
WHERE B.CategoryID IS NULL
AND A.filename = @filename;

INSERT INTO dbo.Fact_TimeSheet (SourceFile,[Date], CustomerID, ProjectID, EmployeeID, CategoryID, Activity, [Hours], ApprovedBy, [Status], ExternalComment)
SELECT A.filename, A.[Date], A.CustomerId, A.ProjectId, B.EmployeeID, C.CategoryID, A.Activity, A.[Hours], A.ApprovedBy, A.[Status], A.ExternalComment
FROM timereg.TimeReport A
JOIN dbo.Dim_Employee B
ON A.Employee = B.ShortName
JOIN dbo.Dim_Category C
ON A.CategoryShortName = C.CategoryShortName
WHERE A.filename = @filename;

RETURN
GO




