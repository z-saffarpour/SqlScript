DECLARE @collate SYSNAME
SELECT @collate = 'Cyrillic_General_CS_AS'
DECLARE @DatabaseCollation VARCHAR(100)

SELECT @DatabaseCollation = collation_name 
FROM sys.databases
WHERE database_id = DB_ID()

SELECT 
      '[' + SCHEMA_NAME(o.[schema_id]) + '].[' + o.name + '] -> ' + c.name
    , 'ALTER TABLE [' + SCHEMA_NAME(o.[schema_id]) + '].[' + o.name + ']
        ALTER COLUMN [' + c.name + '] ' +
        UPPER(t.name) + 
        CASE WHEN t.name NOT IN ('ntext', 'text') 
            THEN '(' + 
                CASE 
                    WHEN t.name IN ('nchar', 'nvarchar') AND c.max_length != -1 
                        THEN CAST(c.max_length / 2 AS VARCHAR(10))
                    WHEN t.name IN ('char', 'varchar') AND c.max_length != -1 
                        THEN CAST(c.max_length AS VARCHAR(10))
                    WHEN t.name IN ('nchar', 'nvarchar', 'char', 'varchar') AND c.max_length = -1 
                        THEN 'MAX'
                    ELSE CAST(c.max_length AS VARCHAR(10)) 
                END + ')' 
            ELSE '' 
        END + --' COLLATE ' + @collate + 
        CASE WHEN c.is_nullable = 1 
            THEN ' NULL'
            ELSE ' NOT NULL'
        END
FROM sys.columns c
INNER JOIN sys.tables ta ON c.object_id = ta.object_id
JOIN sys.objects o ON c.[object_id] = o.[object_id]
JOIN sys.types t ON c.system_type_id = t.system_type_id AND c.user_type_id = t.user_type_id
WHERE t.name IN ('char', 'varchar', 'text', 'nvarchar', 'ntext', 'nchar')
    AND c.collation_name != @collate
    AND o.[type] = 'U'
	AND ta.is_ms_shipped = 0 
	AND c.collation_name <> @DatabaseCollation
GO
DECLARE @DatabaseCollation VARCHAR(100)

SELECT @DatabaseCollation = collation_name 
FROM sys.databases
WHERE database_id = DB_ID()

--SELECT @DatabaseCollation 'Default database collation'

SELECT is_ms_shipped,t.Name 'Table Name',
    c.name 'Col Name',
    ty.name 'Type Name',
    c.max_length,
    c.collation_name,
    c.is_nullable
FROM sys.columns c 
INNER JOIN sys.tables t ON c.object_id = t.object_id
INNER JOIN sys.types ty ON c.system_type_id = ty.system_type_id
WHERE t.is_ms_shipped = 0 AND c.collation_name <> @DatabaseCollation
