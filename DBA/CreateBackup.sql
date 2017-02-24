USE master
GO
DECLARE @finalPath NVARCHAR(max) ,@filename NVARCHAR(255) ,@dataBaseName NVARCHAR(50) , @date NVARCHAR(50) ,@path NVARCHAR(255)

SET @dataBaseName = 'FasicoRecordTrack' --نام دیتابیس
SET @path = N'H:\Repository\Project' -- مسیر ذخیره فایل دیتابیس

DECLARE @day DATE = GETDATE()
SET @date =CONVERT(VARCHAR(4),YEAR(@day))+'-'+CONVERT(VARCHAR(2),MONTH(@day))+'-'+CONVERT(VARCHAR(2),DAY(@day))

SET @Filename = @dataBaseName + N'-Full Database Backup'
SET @finalPath = @path +'\'+ @dataBaseName + '_'+ @date + '.bak' 

BACKUP DATABASE  @dataBaseName TO  DISK = @finalPath 
WITH NOFORMAT, NOINIT, NAME = @filename,
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
