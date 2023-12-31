
DECLARE @start_point_name INT
SET @start_point_name = 1

SELECT Table_Trials.id_trials, Table_Trials.trial_code, Table_Airports.name FROM Table_Trials
INNER JOIN Table_Airports ON Table_Trials.end_id_airport = Table_Airports.id_airports
WHERE Table_Trials.start_id_airport = @start_point_name

PRINT 'Możliwe wyloty z lotniska: '
DECLARE @star_point_full_name CHAR(50)
SET @star_point_full_name = (SELECT Table_Airports.name FROM Table_Airports WHERE id_airports=@start_point_name)
PRINT @star_point_full_name

