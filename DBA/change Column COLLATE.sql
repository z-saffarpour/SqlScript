DECLARE @collate SYSNAME
SELECT @collate = 'Persian_100_CI_AI'

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
                    WHEN t.name IN ('nchar', 'nvarchar') AND c.max_length = -1 
                        THEN 'MAX'
                    ELSE CAST(c.max_length AS VARCHAR(10)) 
                END + ')' 
            ELSE '' 
        END + ' COLLATE ' + @collate + 
        CASE WHEN c.is_nullable = 1 
            THEN ' NULL'
            ELSE ' NOT NULL'
        END
FROM sys.columns c WITH(NOLOCK)
JOIN sys.objects o WITH(NOLOCK) ON c.[object_id] = o.[object_id]
JOIN sys.types t WITH(NOLOCK) ON c.system_type_id = t.system_type_id AND c.user_type_id = t.user_type_id
WHERE t.name IN ('char', 'varchar', 'text', 'nvarchar', 'ntext', 'nchar')
    AND c.collation_name != @collate
    AND o.[type] = 'U'