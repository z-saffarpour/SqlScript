use master
GO

select d.name, d.dbid, spid, login_time, nt_domain, nt_username,loginame
from sysprocesses p 
inner join sysdatabases d on p.dbid = d.dbid
where d.name = 'MersadExchangeServer'
GO
--kill 51 -- kill the number in spid field
--GO
