
DECLARE FK_cursor CURSOR
FOR
SELECT sn ,fne , tn
FROM testsalimi
OPEN FK_cursor
DECLARE @shemaName nvarchar(50), @fkName nvarchar(150), @tableName nvarchar(150)
FETCH NEXT FROM  FK_cursor INTO @shemaName, @fkName, @tableName
WHILE (@@FETCH_STATUS = 0)
BEGIN
EXECUTE ('ALTER TABLE' +@shemaName+ '.' +@tableName+ 'DROP CONSTRAINT' +@fkName)
PRINT 'Dropping constraint '
FETCH NEXT FROM FK_cursor INTO @shemaName, @fkName, @tableName
END
deallocate FK_cursor