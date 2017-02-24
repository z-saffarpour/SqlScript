USE master
GO
SELECT DB_NAME(database_id) AS DataBaseName,name AS Logical_Name,physical_name,CAST((size*8) AS FLOAT)/1024 AS SizeMB,CAST((size*8) AS FLOAT)/(1024 * 1000) AS SizeGB
FROM sys.master_files
--WHERE DB_NAME(database_id)LIKE 'FasicoMang'
GO
