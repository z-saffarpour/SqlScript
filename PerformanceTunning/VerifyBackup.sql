--SELECT DISTINCT physical_device_name
--FROM msdb.dbo.backupmediafamily
--ORDER BY physical_device_name

DECLARE @path NVARCHAR(1000),@msg NVARCHAR(MAX),@NewLine CHAR(2),@sql NVARCHAR(2000)
SET @NewLine = CHAR(13) + CHAR(10)
SET @msg = ''
DECLARE DATABASES_CURSOR CURSOR
FOR
	SELECT DISTINCT physical_device_name
	FROM msdb.dbo.backupmediafamily
	ORDER BY physical_device_name
OPEN DATABASES_CURSOR
FETCH NEXT FROM DATABASES_CURSOR INTO @path
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT 'Verifying: ' + @path
	SET @sql = 'RESTORE VERIFYONLY FROM DISK = ''' + @path+ ''' WITH FILE = 1, LOADHISTORY'
	EXEC sp_executesql @sql
	IF @@ERROR <> 0
	BEGIN
		SET @msg = @msg + 'Failed to verify: ' + @path + @NewLine
	END
	FETCH NEXT FROM DATABASES_CURSOR INTO @path
END
CLOSE DATABASES_CURSOR
DEALLOCATE DATABASES_CURSOR
IF @msg <> ''
BEGIN
	PRINT @msg
	-- send email
	EXECUTE msdb.dbo.sp_send_dbmail
		@recipients = 'nasiri@site.net', -- Change This
		@copy_recipients = 'Administrator@site.net', -- Change This
		@Subject = 'backup verification info.',
		@Body = @msg
		,@importance = 'High'
END