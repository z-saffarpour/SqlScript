use master
go
DECLARE @device_directory NVARCHAR(520),@DataBaseName nvarchar(50)
set @DataBaseName=N'test34'--نام دیتا بیس

SELECT @device_directory = SUBSTRING(filename, 1, CHARINDEX(N'master.mdf', LOWER(filename)) - 1)
FROM dbo.sysaltfiles WHERE dbid = 1 AND fileid = 1

if EXISTS(select* from sys.databases where name=@DataBaseName)
begin
	EXECUTE(N'DROP DATABASE '+@DataBaseName)
End

EXECUTE (N'CREATE DATABASE '+ @DataBaseName+' 
		  ON PRIMARY (NAME = N'''+@DataBaseName+''', FILENAME = N''' + @device_directory + @DataBaseName+'.mdf'+
		  ',SIZE = 3072 KB , FILEGROWTH= 1024 KB'+''')
		  LOG ON (NAME = N'''+@DataBaseName+'_log'',  FILENAME = N''' + @device_directory + @DataBaseName+'.ldf'+
		  ',SIZE = 1024 KB , FILEGROWTH= 10%'+''')')
GO