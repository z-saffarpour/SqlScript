SELECT OBJECT_NAME(object_id) as 'Procedure/Function/View Name',definition
FROM sys.sql_modules
WHERE definition LIKE '%' + 'Firstname' + '%'