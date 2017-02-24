	DECLARE @dbName NVARCHAR(100)
	DECLARE @finalPath NVARCHAR(max) ,@filename NVARCHAR(255) ,@dataBaseName NVARCHAR(50) , @date NVARCHAR(50) ,@path NVARCHAR(255)
	DECLARE @day DATE = GETDATE()
	declare @backupSetId as INT
	DECLARE @printItem NVARCHAR(100)
	SET @printItem = REPLICATE('---',50)
	SET @date =CONVERT(VARCHAR(4),YEAR(@day))+'-'+CONVERT(VARCHAR(2),MONTH(@day))+'-'+CONVERT(VARCHAR(2),DAY(@day))
	SET @path = N'E:\Backup\BakupOldWindows_1395-12-16' -- مسیر ذخیره فایل دیتابیس

	DECLARE cur CURSOR 
	FOR 
	SELECT name 
	FROM sys.databases 
	WHERE database_id > 4
	OPEN cur  
	FETCH NEXT FROM cur INTO @dbName
	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		PRINT @printItem	
		PRINT @dbName

		SET @dataBaseName = @dbName --نام دیتابیس
		SET @Filename = @dataBaseName + N'-Full Database Backup'
		SET @finalPath = @path +'\'+ @dataBaseName + '_'+ @date + '.bak' 

		BACKUP DATABASE  @dataBaseName TO  DISK = @finalPath 
		WITH NOFORMAT, NOINIT, NAME = @filename,
		SKIP, NOREWIND, NOUNLOAD,COMPRESSION,  STATS = 10

        SELECT @backupSetId = position 
		FROM msdb.dbo.backupset
		WHERE database_name = @dbName AND backup_set_id = (SELECT MAX(backup_set_id) FROM msdb.dbo.backupset WHERE database_name=@dbName )
		IF @backupSetId IS NULL 
		BEGIN 
			DECLARE @error NVARCHAR(255)
			SET @error = N'Verify failed. Backup information for database '+ @dbName +' not found.'
			RAISERROR(@error, 16, 1) 
		END
		RESTORE VERIFYONLY FROM  DISK = @finalPath WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND

		PRINT @printItem
		FETCH NEXT FROM cur INTO @dbName
	END
	CLOSE cur;  
	DEALLOCATE cur;  