DECLARE @schemaName NVARCHAR(100),@ViewName NVARCHAR(100),@name sysname

DECLARE cursor_views 
CURSOR FOR 
SELECT s.name,o.name
FROM sys.sysobjects AS o
INNER JOIN sys.schemas AS s ON s.schema_id = o.uid
WHERE xtype='V'
FOR READ ONLY
OPEN cursor_views
FETCH NEXT FROM cursor_views INTO @schemaName,@ViewName
WHILE @@FETCH_STATUS=0
BEGIN
	DECLARE @cmd sysname
	SET @name = @schemaName +'.'+@ViewName
	SET @cmd = 'sp_refreshview ''' + @name + ''''
	SET @cmd +=CHAR(10)
	SET @cmd +='GO'
	PRINT @cmd
	EXECUTE sp_refreshview @name
    FETCH NEXT FROM cursor_views INTO @schemaName,@ViewName
END

CLOSE cursor_views
DEALLOCATE cursor_views