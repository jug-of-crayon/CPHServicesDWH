SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Schema: timereg
DROP PROCEDURE IF EXISTS [timereg].[RegisterTimeSheet]
DROP TABLE IF EXISTS [timereg].[RegisteredTimesheet];
DROP TABLE IF EXISTS [timereg].[PostedTimesheet];
DROP SCHEMA IF EXISTS timereg;

-- Schema: dbo
DROP TABLE IF EXISTS [dbo].[Fact_TimeSheet];
DROP TABLE IF EXISTS [dbo].[Dim_Project];
DROP TABLE IF EXISTS [dbo].[Dim_Employee];
DROP TABLE IF EXISTS [dbo].[Dim_Customer];
DROP TABLE IF EXISTS [dbo].[Dim_Category];
DROP TABLE IF EXISTS [dbo].[Dim_Date];
DROP TABLE IF EXISTS [dbo].[Dim_WorkHours];
DROP TABLE IF EXISTS [dbo].[Dim_Weekday];
DROP TABLE IF EXISTS [dbo].[Dim_Month];
