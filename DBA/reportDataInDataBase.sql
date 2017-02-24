CREATE TABLE #temp(Name NVARCHAR(50),Rows INT,Reserved NVARCHAR(50),Data NVARCHAR(50),Index_size NVARCHAR(50),Unused NVARCHAR(50))
INSERT INTO #temp ( NAME , ROWS , reserved , DATA , index_size , unused )
exec sp_MSforeachtable 'sp_spaceUsed ''?'''

SELECT * FROM #temp ORDER BY NAME

DROP TABLE #temp