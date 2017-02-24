
SELECT (SELECT COUNT(*)  FROM Feed.TBL_Feed WITH(NOLOCK))AS 'all',
	   (SELECT COUNT(*) FROM Feed.TBL_Feed WITH(NOLOCK) WHERE FeedServerPath IS NOT NULL)as 'FeedServerPath IS NOT NULL' ,
	   (SELECT COUNT(*)  FROM Feed.TBL_Feed WITH(NOLOCK) WHERE FeedServerPath IS NULL)AS 'FeedServerPath IS NULL'
raiserror('',0,1) with nowait --to flush the buffer
waitfor delay '00:04:00'      --pause for 10 seconds
GO 10