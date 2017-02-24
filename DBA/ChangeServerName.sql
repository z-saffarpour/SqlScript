	
EXEC sp_DROPSERVER 'oldservername'
GO
EXEC sp_ADDSERVER 'newservername', 'local'
GO
--Restart SQL Services.
SELECT @@SERVERNAME
GO
SELECT  HOST_NAME() AS 'host_name()',
@@servername AS 'ServerName\InstanceName',
SERVERPROPERTY('servername') AS 'ServerName',
SERVERPROPERTY('machinename') AS 'Windows_Name',
SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS 'NetBIOS_Name',
SERVERPROPERTY('instanceName') AS 'InstanceName',
SERVERPROPERTY('IsClustered') AS 'IsClustered'
GO