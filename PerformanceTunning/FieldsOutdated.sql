SELECT O.Name,col.name AS ColName,systypes.name
FROM syscolumns col
INNER JOIN sysobjects O ON col.id = O.id
INNER JOIN systypes ON col.xtype = systypes.xtype
WHERE O.Type = 'U'
AND OBJECTPROPERTY(o.ID, N'IsMSShipped') = 0
AND systypes.name IN ('text', 'ntext', 'image')
ORDER BY O.Name,Col.Name