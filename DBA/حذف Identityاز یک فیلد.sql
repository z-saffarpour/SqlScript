alter table users add newusernum INT
GO
update users set newusernum = usernum
GO
alter table users drop column usernum
GO
EXEC sp_RENAME 'users.newusernum' , 'usernum', 'COLUMN'
GO