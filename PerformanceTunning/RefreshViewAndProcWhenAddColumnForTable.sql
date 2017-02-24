DECLARE cursor_views CURSOR FOR 
SELECT [name] FROM sysobjects WHERE xtype='V'
FOR READ ONLY

OPEN cursor_views
DECLARE @name sysname

FETCH NEXT FROM cursor_views INTO @name
WHILE @@FETCH_STATUS=0
BEGIN
    PRINT 'Refreshing view: '+@name
    EXECUTE sp_refreshview @name
    FETCH NEXT FROM cursor_views INTO @name
END

CLOSE cursor_views
DEALLOCATE cursor_views


DECLARE cursor_procs CURSOR FOR 
SELECT [name] FROM sysobjects WHERE xtype='P'
FOR READ ONLY

OPEN cursor_procs

FETCH NEXT FROM cursor_procs INTO @name
WHILE @@FETCH_STATUS=0
BEGIN
    PRINT 'Recompiling proc: '+@name
    EXECUTE sp_recompile @name
    FETCH NEXT FROM cursor_procs INTO @name
END

CLOSE cursor_procs
DEALLOCATE cursor_procs