CREATE PROCEDURE report_day
AS
DECLARE @date DATE
DECLARE @date2 DATE
SET @date = (CONVERT(date, GETDATE()))
SELECT * FROM Table_Tickets WHERE time_bought >= @date

--SET @date = (CONVERT(date, '2021-01-31'))
--SELECT @date
--SELECT * FROM Table_Tickets WHERE time_bought >= @date
