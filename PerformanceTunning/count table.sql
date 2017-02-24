
SELECT *
--COUNT(*) 
FROM sys.procedures
WHERE schema_id =9
---------



SELECT *
FROM igsdb.sys.procedures
WHERE schema_id =13 AND name NOT IN ( SELECT NAME FROM SALIMI.sys.procedures )