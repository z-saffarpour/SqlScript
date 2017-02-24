WITH	LastRestores
AS ( SELECT	[d].[name] AS DatabaseName , [d].[create_date] , r.restore_date , [d].[compatibility_level] ,
			[d].[collation_name] , r.restore_history_id , r.destination_database_name , r.user_name ,
			r.backup_set_id , r.restore_type , r.replace , r.recovery , r.restart , r.stop_at ,
			r.device_count , r.stop_at_mark_name , r.stop_before ,
			ROW_NUMBER() OVER ( PARTITION BY d.name ORDER BY r.[restore_date] DESC ) AS RowNum
	FROM	master.sys.databases d
	LEFT JOIN msdb.dbo.restorehistory r ON r.destination_database_name = d.name)
SELECT	*
FROM	LastRestores
WHERE	RowNum = 1
GO