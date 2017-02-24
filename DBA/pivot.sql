
--- ”«Œ ‰ ÃœÊ·  ” Ì
drop table tb1
go
drop table tb2
go
create table tb1 (a1 int , b1 char(2))
go
create table tb2 (a2 int , b2 char(2))
go
insert tb1 values (1,'A'),(2,'B'),(3,'C')
go
insert tb2 values (1,'A1'),(1,'A2'),(2,'B2'),(3,'C2'),(3,'C3'),(3,'C4')
go
select * from tb2
------------------------------------
--«ê—  ⁄œ«œ ” Ê‰ Â« À«»  »«‘Â 
select * from tb1 join
(select *
from 
(
  select a2, b2,
    'Qty_'+cast(row_number() over(partition by a2 order by b2) as varchar(10)) rn
  from tb2
) src
pivot
(
  max(b2)
  for rn in (Qty_1, Qty_2, Qty_3, Qty_4)
) piv) as t
on a1=a2
------------------------------------
--«ê—  ⁄œ«œ ” Ê‰« ‰«„‘Œ’ »«‘Â
SELECT
     t1.a2,
     STUFF(
         (SELECT ' ' + cast(b2 as varchar(10))
          FROM tb2 t2
          WHERE t1.a2 = t2.a2
          FOR XML PATH (''))
          , 1, 1, '')  AS List
FROM tb2 t1
GROUP BY t1.a2