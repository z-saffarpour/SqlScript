---------------------------------------------------
--CDC���� ���� ������
EXEC sys.sp_cdc_enable_db
Go
------------------------------------------------
--���� ���� ��� CDC ���� ���� ������
--����� ������ ��� � ������ �� 
EXEC sys.sp_cdc_enable_table
    @Source_Schema = N'dbo',
    @Source_Name   = N'Students',
    @Role_Name     = null,
    @Supports_Net_Changes = 1
GO
-----------------------------------------------------------------------
--���� ����  CDC ��� ���� ���� ������
EXECUTE sys.sp_cdc_disable_table 
    @source_schema = N'dbo', 
    @source_name = N'Students',
    @capture_instance = N'dbo_Students';
GO
--------------------------------
--CDC��� ���� ���� ������
--��Job��� ����  
EXEC sys.sp_cdc_disable_db
