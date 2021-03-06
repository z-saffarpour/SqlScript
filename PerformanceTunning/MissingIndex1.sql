	create table #tmp(index_group_handle int,index_handle int,AvgTotalUserCostThatCouldbeReduced float,AvgPercentageBenefit float,create_index_statement nvarchar(max))
	declare @create_index_statement nvarchar(max)
	insert into #tmp
	SELECT mig.index_group_handle,
		  mid.index_handle,
		  migs.avg_total_user_cost AS AvgTotalUserCostThatCouldbeReduced,
		  migs.avg_user_impact AS AvgPercentageBenefit,
		  'CREATE INDEX missing_index_' + CONVERT (varchar, mig.index_group_handle)
		  + '_' + CONVERT (varchar, mid.index_handle)
		  + ' ON ' + mid.statement
		  + ' (' + ISNULL (mid.equality_columns,'')
		  + CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE ''END
		  + ISNULL (mid.inequality_columns, '')+ ')'
		  + ISNULL (' INCLUDE (' + mid.included_columns + ')', '') AS create_index_statement
	FROM sys.dm_db_missing_index_groups mig
	INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
	INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
	where mid.database_id in (7,8,15)
	order by database_id


	declare user_cur cursor for
	select create_index_statement
	from #tmp
	open user_cur
	fetch next from user_cur into @create_index_statement
	while @@FETCH_STATUS = 0
	begin
		print @create_index_statement
		fetch next from user_cur into @create_index_statement
	end 
	close user_cur
	deallocate user_cur

	drop table #tmp

