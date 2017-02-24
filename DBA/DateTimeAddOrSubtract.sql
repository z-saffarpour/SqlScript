DECLARE @startdate datetime2 = '2007-05-05 12:10:09.3312722';
DECLARE @enddate datetime2 = '2007-05-04 12:10:09.3312722'; 
SELECT DATEDIFF(day, @startdate, @enddate);

SELECT DATEADD(DAY, 5, '9/1/2011')