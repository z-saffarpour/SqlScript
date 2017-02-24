SET NOCOUNT ON
DECLARE @columnname VARCHAR(MAX)
DECLARE @tablename SYSNAME
DECLARE @schemaname SYSNAME
DECLARE @statsname SYSNAME
DECLARE @sql NVARCHAR(4000)
DECLARE @NAME VARCHAR(MAX)
declare @i INT
declare @j INT

create table #temp
(
schemaname varchar(1000),
tablename varchar(1000),
statsname varchar(1000),
columnname varchar(1000)
)

insert #temp(schemaname,tablename,statsname,columnname)
SELECT DISTINCT sch.name,OBJECT_NAME(s.[object_id]),s.name AS StatName,
COALESCE(@NAME+ ', ', '')+c.name
FROM sys.stats s JOIN sys.stats_columns sc ON sc.[object_id] = s.[object_id] AND sc.stats_id = s.stats_id
JOIN sys.columns c ON c.[object_id] = sc.[object_id] AND c.column_id = sc.column_id
JOIN INFORMATION_SCHEMA.COLUMNS D ON D.[COLUMN_NAME]= C.[NAME]
JOIN sys.partitions par ON par.[object_id] = s.[object_id]
JOIN sys.objects obj ON par.[object_id] = obj.[object_id]
JOIN sys.schemas sch ON sch.schema_id = obj.schema_id 
WHERE OBJECTPROPERTY(s.OBJECT_ID,'IsUserTable') = 1 AND D.DATA_TYPE NOT IN('NTEXT','IMAGE') 

create table #temp1
(
id int identity(1,1),
schemaname varchar(8000),
tablename varchar(8000),
statsname varchar(8000),
columnname varchar(8000)
)

insert #temp1(schemaname,tablename,statsname,columnname)
select t.schemaname,tablename,statsname,stuff(( select ','+ [columnname] from #temp WHERE statsname = t.statsname for XML path('')),1,1,'')
from (select distinct schemaname,tablename,statsname from #temp )t
SELECT @i=1
SELECT @j=MAX(ID) FROM #temp1
WHILE(@I<=@J)
BEGIN

SELECT @statsname = statsname from #temp1 where id = @i
SELECT @schemaname = schemaname from #temp1 where id = @i
SELECT @tablename = tablename from #temp1 where id = @i
SELECT @columnname = columnname from #temp1 where id = @i

SET @sql = N'UPDATE STATISTICS '+QUOTENAME(@schemaname)+'.'+QUOTENAME(@tablename)+QUOTENAME(@statsname)+space(1)+'WITH FULLSCAN'

PRINT @sql
--EXEC sp_executesql @sql  
SET @i = @i+1
END

DROP TABLE #temp
DROP TABLE #temp1