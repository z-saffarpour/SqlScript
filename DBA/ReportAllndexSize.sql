SELECT [DatabaseName] ,[ObjectId] ,[ObjectName]  ,[IndexDescription]
    ,CONVERT(DECIMAL(16, 1), (SUM([avg_record_size_in_bytes] * [record_count]) / (1024.0 * 1024))) AS [IndexSize(MB)]
    ,[lastupdated] AS [StatisticLastUpdated] ,[AvgFragmentationInPercent],IndexName
FROM (
    SELECT DISTINCT DB_Name(Database_id) AS 'DatabaseName'
        ,s.OBJECT_ID AS ObjectId
        ,Object_Name(s.Object_id) AS ObjectName
        ,Index_Type_Desc AS IndexDescription
        ,avg_record_size_in_bytes
        ,record_count
        ,STATS_DATE(s.object_id, s.index_id) AS 'lastupdated'
        ,CONVERT([varchar](512), round(Avg_Fragmentation_In_Percent, 3)) AS 'AvgFragmentationInPercent'
		,i.name AS IndexName
    FROM sys.dm_db_index_physical_stats(db_id(), NULL, NULL, NULL, 'detailed') AS s
	JOIN sys.indexes AS i ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id
    WHERE s.OBJECT_ID IS NOT NULL AND Avg_Fragmentation_In_Percent <> 0
    ) T
GROUP BY DatabaseName ,ObjectId ,ObjectName  ,IndexDescription ,lastupdated ,AvgFragmentationInPercent,IndexName