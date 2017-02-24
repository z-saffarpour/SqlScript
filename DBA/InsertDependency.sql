select p2.ID,p2.NesbatID,p2.FirstName,p2.LastName,p2.BirthDate,p2.MelliCode,p2.GenderID ,p.prsvcodeguid,
case when CHARINDEX('-',m.name)>0 then ltrim(RTRIM(substring(m.Name,0,CHARINDEX('-',m.name)))) else m.Name end as din
from personeli.prs.PRS_TBL_Person as p
inner join prs.dbo.Personel as p1 on p.prsPersCodeStr = p1.PersoneliID
inner join prs.dbo.PersonelTakafol as p2 on p1.id = p2.PersonelID
left join prs.[BaseTable].[Mazhab]as m on m.ID=p2.MazhabID
where p2.NesbatID is not null and p2.FirstName is not null and p2.LastName is not null 
order by p2.LastName
