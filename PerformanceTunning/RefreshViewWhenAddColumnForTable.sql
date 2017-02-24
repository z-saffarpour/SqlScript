DECLARE @view_name AS NVARCHAR(500)

DECLARE views_cursor CURSOR FOR 
    SELECT TABLE_SCHEMA + '.' +TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE = 'VIEW' 
    ORDER BY TABLE_SCHEMA,TABLE_NAME 
OPEN views_cursor FETCH NEXT FROM views_cursor INTO @view_name 
WHILE (@@FETCH_STATUS <> -1) 
BEGIN
    BEGIN TRY
        EXEC sp_refreshview @view_name
        PRINT @view_name
    END TRY
    BEGIN CATCH
        PRINT 'Error during refreshing view "' + @view_name + '".'
    END CATCH
    FETCH NEXT FROM views_cursor INTO @view_name 
END 
CLOSE views_cursor
DEALLOCATE views_cursor