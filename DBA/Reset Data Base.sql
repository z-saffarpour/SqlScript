exec sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
go
exec sp_MSforeachtable 'DELETE FROM ?'
go
exec sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL'
go
exec sp_MSforeachtable 'DBCC CHECKIDENT (''?'',reseed,0)'
go