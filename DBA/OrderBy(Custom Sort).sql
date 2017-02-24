USE tempdb
GO
--Create Table TestSort
--(ID int identity(1,1),
--Name nvarchar(30),
--Color nvarchar(15)
--)
--Insert into TestSort (Name,color)
--Values ('Adjustable Race',null)
--,('Bearing Ball',null)
--,('Headset Ball Bearings',null)
--,('LL Crankarm','Black')
--,('ML Crankarm','Black')
--,('Chainring','Black')
--,('Front Derailleur Cage','Silver')
--,('Front Derailleur Linkage','Silver')
--,('Lock Ring','Silver')
--,('HL Road Frame - Red, 62','Red')
--,('HL Road Frame - Red, 48','Red')
--,('LL Road Frame - Red, 44','Red')
--,('Full-Finger Gloves, M','RED')
--,('Road-550-W Yellow, 38','Yellow')
--,('Road-550-W Yellow, 40','Yellow')
--,('Road-550-W Yellow, 42','Yellow')
--,('Classic Vest, S','Blue')
--,('Classic Vest, M','Blue')
--,('Classic Vest, L','Blue')

Select t.ID,t.Name,t.Color from TestSort as t
Where t.color is not null
order by Case t.Color
When 'Red' Then '1'
WHEN 'Silver' THEN '2'
Else t.color
End;