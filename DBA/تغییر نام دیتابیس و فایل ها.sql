use master
ALTER DATABASE Empty_Personeli SET SINGLE_USER WITH ROLLBACK IMMEDIATE    
go
ALTER DATABASE Empty_Personeli MODIFY NAME = Fasico_Personeli
go
ALTER DATABASE Fasico_Personeli SET MULTI_USER
GO

ALTER DATABASE Fasico_Personeli
MODIFY FILE (NAME = Personeli, FILENAME = 'D:\Fasico_Personeli.mdf' )
go
ALTER DATABASE Fasico_Personeli
MODIFY FILE (NAME = Personeli_log, FILENAME = 'D:\Fasico_Personeli_1.ldf' )
GO