--SELECT st.name, st.object_id, sp.partition_id, sp.partition_number, sp.data_compression, 
--sp.data_compression_desc FROM sys.partitions SP
--INNER JOIN sys.tables ST ON
--st.object_id = sp.object_id
----WHERE data_compression <> 0
--GO

SELECT 'ALTER TABLE ['+B.Name+'].['+ A.Name + '] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)'
from sys.objects A 
INNER JOIN sys.schemas B on A.Schema_id=B.Schema_id
where type = 'U' --and A.name not like 'dtproperties'
GO
SELECT DISTINCT SERVERPROPERTY('servername') [instance] ,DB_NAME() [database] ,QUOTENAME(OBJECT_SCHEMA_NAME(sp.object_id)) +'.'+QUOTENAME(Object_name(sp.object_id))[table] ,
	  ix.name [index_name] ,sp.data_compression ,sp.data_compression_desc
FROM sys.partitions SP 
LEFT OUTER JOIN sys.indexes IX ON sp.object_id = ix.object_id and sp.index_id = ix.index_id
WHERE sp.data_compression <> 0
ORDER BY 2
GO
