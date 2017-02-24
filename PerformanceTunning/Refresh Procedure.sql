DECLARE @schemaName NVARCHAR(100),@ViewName NVARCHAR(100),@name sysname


DECLARE cursor_procs CURSOR FOR 
SELECT s.name,o.name
FROM sys.sysobjects AS o
INNER JOIN sys.schemas AS s ON s.schema_id = o.uid
WHERE xtype='P'
FOR READ ONLY

OPEN cursor_procs

FETCH NEXT FROM cursor_procs INTO @schemaName,@ViewName
WHILE @@FETCH_STATUS=0
BEGIN
	DECLARE @cmd sysname
	SET @name = @schemaName +'.'+@ViewName
	SET @cmd = 'sp_recompile ''' + @name + ''''
	SET @cmd +=CHAR(10)
	SET @cmd +='GO'
	PRINT @cmd

    EXECUTE sp_recompile @name
    FETCH NEXT FROM cursor_procs INTO @schemaName,@ViewName
END

CLOSE cursor_procs
DEALLOCATE cursor_procs