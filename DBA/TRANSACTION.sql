BEGIN TRANSACTION
BEGIN TRY

    -- put your T-SQL commands here    

    -- if successful - COMMIT the work
    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    -- handle the error case (here by displaying the error)
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        ERROR_MESSAGE() AS ErrorMessage

    -- in case of an error, ROLLBACK the transaction    
    ROLLBACK TRANSACTION

    -- if you want to log this error info into an error table - do it here 
    -- *AFTER* the ROLLBACK
END CATCH