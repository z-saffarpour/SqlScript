UPDATE [PRS].[PRS_TBL_Person]
SET
 prsFamilyStr = REPLACE(prsFamilyStr,N'ي',N'ی'),
 prsNameStr= REPLACE(prsNameStr,N'ي',N'ی'),
 prsFatherNameStr=REPLACE(prsFatherNameStr,N'ي',N'ی'),
 prsMotherNameStr=REPLACE(prsMotherNameStr,N'ي',N'ی')
 
 
 go

UPDATE [PRS].[PRS_TBL_Person]
SET
prsFamilyStr = REPLACE(prsFamilyStr,N'ك',N'ک'),
prsNameStr = REPLACE(prsNameStr,N'ك',N'ک'),
prsFatherNameStr = REPLACE(prsFatherNameStr,N'ك',N'ک'),
prsMotherNameStr = REPLACE(prsMotherNameStr,N'ك',N'ک')