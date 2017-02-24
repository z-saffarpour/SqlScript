

select MyDate
from MyTable
order by case when MyDate is null then 1 else 0 end, MyDate

