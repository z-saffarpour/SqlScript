---------------------------------------------------
--CDC›⁄«· ”«“Ì ﬁ«»·Ì 
EXEC sys.sp_cdc_enable_db
Go
------------------------------------------------
--»—«Ì ÃœÊ· ›Êﬁ CDC ›⁄«· ”«“Ì ﬁ«»·Ì 
--«ÌÃ«œ ŒÊœﬂ«— Ã«» Ê ›«‰ﬂ‘‰ »Â 
EXEC sys.sp_cdc_enable_table
    @Source_Schema = N'dbo',
    @Source_Name   = N'Students',
    @Role_Name     = null,
    @Supports_Net_Changes = 1
GO
-----------------------------------------------------------------------
--»—«Ì ÃœÊ·  CDC €Ì— ›⁄«· ﬂ—œ‰ ﬁ«»·Ì 
EXECUTE sys.sp_cdc_disable_table 
    @source_schema = N'dbo', 
    @source_name = N'Students',
    @capture_instance = N'dbo_Students';
GO
--------------------------------
--CDC€Ì— ›⁄«· ﬂ—œ‰ ﬁ«»·Ì 
--Â«JobÕ–› ﬂ·ÌÂ  
EXEC sys.sp_cdc_disable_db
