SELECT DISTINCT * FROM #Employee

;WITH #DeleteEmployee AS (
SELECT ROW_NUMBER() OVER(PARTITION BY ID, First_Name, Last_Name ORDER BY ID) AS RNUM
FROM #Employee
)

DELETE FROM #DeleteEmployee WHERE RNUM > 1

SELECT DISTINCT * FROM #Employee