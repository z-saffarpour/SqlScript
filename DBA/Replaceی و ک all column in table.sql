--اسکریپتی برای یک دست سازی ی و ک در تمامی رکوردهای تمامی جداول دیتابیس جاری--
--اسکریپت زیر ی و ک فارسی را به عربی تبدیل میکند --
--در صورت نیاز به حالت عکس ، جای مقادیر عددی یونیکد را تعویض نمائید --

--SELECT NCHAR(1740) AS N'ی فارسی',NCHAR(1610) AS N'ي عربي',NCHAR(1705) AS N'ک فارسی',NCHAR(1603) AS N'ك عربی'

DECLARE @SchemaName NVARCHAR(MAX),@TableName NVARCHAR(MAX),@ColumnName NVARCHAR(MAX)
DECLARE Table_Cursor CURSOR
FOR
--پیدا کردن تمام فیلدهای متنی تمام جداول دیتابیس جاری--
SELECT c.name AS SchemaName,
 a.name AS TableName, --table
b.name AS ColumnName --col
FROM sysobjects a
INNER JOIN sys.schemas AS c ON a.uid = c.schema_id
INNER JOIN syscolumns b ON a.id = b.id 
WHERE a.xtype = 'u'
AND (b.xtype = 99 --ntext
	OR b.xtype = 35 -- text
	OR b.xtype = 231 --nvarchar
	OR b.xtype = 167 --varchar
	OR b.xtype = 175 --char
	OR b.xtype = 239 --nchar
)
ORDER BY SchemaName,TableName,ColumnName
OPEN Table_Cursor 
FETCH NEXT FROM Table_Cursor INTO @SchemaName,@TableName,@ColumnName
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		PRINT (
		'update [' + @SchemaName +'].['+ @TableName + '] set [' + @ColumnName +
		']= REPLACE(REPLACE(CAST([' + @ColumnName +
		'] as nvarchar(max)) , NCHAR(1610), NCHAR(1740)),NCHAR(1603),NCHAR(1705)) '
		)
	FETCH NEXT FROM Table_Cursor INTO @SchemaName,@TableName,@ColumnName
	END 
CLOSE Table_Cursor 
DEALLOCATE Table_Cursor 