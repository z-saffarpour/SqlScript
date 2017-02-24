/***	خرد کردن یک جمله*/
CREATE FUNCTION dbo.Split (@sep char(1), @s varchar(512))
RETURNS table
AS
RETURN (
    WITH Pieces(pn, start, stop) AS (
      SELECT 1, 1, CHARINDEX(@sep, @s)
      UNION ALL
      SELECT pn + 1, stop + 1, CHARINDEX(@sep, @s, stop + 1)
      FROM Pieces
      WHERE stop > 0
    )
    SELECT pn,
      SUBSTRING(@s, start, CASE WHEN stop > 0 THEN stop-start ELSE 512 END) AS s
    FROM Pieces
  )
	/**	پیدا کردن تاریخ که معتبر نمی باشد*/
	DECLARE @prsHireDate NVARCHAR(max)
	declare org_cur cursor for
	
	SELECT prsHireDate
	FROM PRS.PRS_TBL_Person

	open org_cur
	fetch next from org_cur into @prsHireDate
	while @@FETCH_STATUS = 0
	begin
		DECLARE @rowCount INT
		SELECT @rowCount=COUNT(*) FROM dbo.Split ('/', @prsHireDate)
		IF(@rowCount!=3)
			PRINT @prsHireDate
		fetch next from org_cur into @prsHireDate
	end 
	close org_cur
	deallocate org_cur