/*;WITH XmlFile (Contents)
AS (
	SELECT CONVERT (XML, BulkColumn) 
	FROM OPENROWSET (BULK 'H:\filter1.xml', SINGLE_BLOB) AS XmlData
)
INSERT INTO Feed.TBL_Filter
        ( Id ,
          Name ,
          TreeCode ,
          IsDefault ,
          IsDeleted 
        )
SELECT c.value('@Id', 'UNIQUEIDENTIFIER') AS [ID],c.value('@Name','NVARCHAR(255)') AS Name,c.value('@TreeCode','NVARCHAR(255)') AS TreeCode , 0 ,0
FROM   XmlFile 
CROSS APPLY Contents.nodes ('(//Feed.TBL_Filter)') AS t(c)
GO*/

/*
;WITH XmlFile (Contents)
AS (
	SELECT CONVERT (XML, BulkColumn) 
	FROM OPENROWSET (BULK 'H:\Rss1.xml', SINGLE_BLOB) AS XmlData
)

SELECT *
FROM   XmlFile 
GO
*/
;WITH XmlFile (Contents)
AS (
	SELECT CONVERT (XML, BulkColumn) 
	FROM OPENROWSET (BULK 'H:\Rss1.xml', SINGLE_BLOB) AS XmlData
)
INSERT INTO Feed.TBL_Rss
        ( Id ,
          Name ,
          SiteUri ,
          NavigateUri ,
          IsEvaluate ,
          IsNewspaper ,
          IsDefault ,
          IsDeleted ,
          IsAutomaticReceive
        )
SELECT c.value('@Id', 'UNIQUEIDENTIFIER') AS [ID],c.value('@Name','NVARCHAR(255)') AS Name,c.value('@SiteUri','NVARCHAR(255)') AS SiteUri,c.value('@NavigateUri','NVARCHAR(255)') AS NavigateUri,c.value('@IsEvaluate','bit') AS IsEvaluate,c.value('@IsNewspaper','bit') AS IsNewspaper,0,0,c.value('@IsAutomaticReceive','bit') AS IsAutomaticReceive
FROM   XmlFile 
CROSS APPLY Contents.nodes ('//Feed.TBL_Rss') AS t(c)