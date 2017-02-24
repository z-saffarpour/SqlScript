USE FasicoNews
GO
EXEC sys.sp_cdc_enable_db
Go
EXEC sys.sp_cdc_enable_table @Source_Schema = N'Bulletin',@Source_Name   = N'TBL_Bulletin',@Role_Name = null,@Supports_Net_Changes = 1
GO

EXEC sys.sp_cdc_enable_table @Source_Schema = N'News',@Source_Name   = N'TBL_Dashboard',@Role_Name  = null,@Supports_Net_Changes = 1
GO

EXEC sys.sp_cdc_enable_table @Source_Schema = N'News',@Source_Name   = N'TBL_Document', @Role_Name = null, @Supports_Net_Changes = 1
GO

EXEC sys.sp_cdc_enable_table @Source_Schema = N'News',@Source_Name   = N'TBL_News',@Role_Name  = null,@Supports_Net_Changes = 1
GO

EXEC sys.sp_cdc_enable_table @Source_Schema = N'News',@Source_Name   = N'TBL_Action',@Role_Name  = null,@Supports_Net_Changes = 1
GO

EXEC sys.sp_cdc_enable_table @Source_Schema = N'News',@Source_Name   = N'TBL_RelatedDocument',@Role_Name  = null,@Supports_Net_Changes = 1
GO

EXEC sys.sp_cdc_enable_table @Source_Schema = N'Bulletin',@Source_Name   = N'TBL_BulletinDocument',@Role_Name  = null,@Supports_Net_Changes = 1
GO

sp_configure 'max text repl size', -1

RECONFIGURE 