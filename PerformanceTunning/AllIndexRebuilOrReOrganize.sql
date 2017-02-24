SET NOCOUNT ON;
DECLARE @objectid int;
DECLARE @indexid int;
DECLARE @partitioncount bigint;
DECLARE @schemaname nvarchar(130); 
DECLARE @objectname nvarchar(130); 
DECLARE @indexname nvarchar(130); 

DECLARE @fillfactor nvarchar(130); 
DECLARE @ispadded BIT;


DECLARE @partitionnum bigint;
DECLARE @partitions bigint;
DECLARE @frag float;
DECLARE @command nvarchar(4000); 
SELECT object_id AS objectid, index_id AS indexid,partition_number AS partitionnum, avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'detailed')
WHERE OBJECT_ID IS NOT NULL AND Avg_Fragmentation_In_Percent <>0;
DECLARE partitions CURSOR FOR 
SELECT * FROM #work_to_do;
OPEN partitions;
WHILE (1=1)
    BEGIN;
        FETCH NEXT FROM partitions INTO @objectid, @indexid, @partitionnum, @frag;
        IF @@FETCH_STATUS < 0 BREAK;

        SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
        FROM sys.objects AS o
        JOIN sys.schemas as s ON s.schema_id = o.schema_id
        WHERE o.object_id = @objectid;

        SELECT @indexname = QUOTENAME(name)
        FROM sys.indexes
        WHERE  object_id = @objectid AND index_id = @indexid;

		SELECT @fillfactor = fill_factor
        FROM sys.indexes
        WHERE  object_id = @objectid AND index_id = @indexid;

		SELECT @ispadded = is_padded
        FROM sys.indexes
        WHERE  object_id = @objectid AND index_id = @indexid;

        SELECT @partitioncount = count (*)
        FROM sys.partitions
        WHERE object_id = @objectid AND index_id = @indexid;

		IF @frag < 30.0
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';
        IF @frag >= 30.0
		begin
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD';
			IF(@fillfactor > 0)
			BEGIN
				SET @command = @command + N' WITH ( ';
				IF(@ispadded = 1)
					SET @command = @command + N'PAD_INDEX = ON ,';
				SET @command = @command + ' SORT_IN_TEMPDB = ON , FILLFACTOR = ';
				SET @command = @command + @fillfactor+' )';
			END 
		END
        IF @partitioncount > 1
            SET @command = @command + N' PARTITION=' + CAST(@partitionnum AS nvarchar(10));
		
        --EXEC (@command);
        PRINT @command;
    END;

CLOSE partitions;
DEALLOCATE partitions;

DROP TABLE #work_to_do;
GO