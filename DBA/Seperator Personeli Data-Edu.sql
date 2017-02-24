USE master;
GO

DECLARE @codeStr NVARCHAR(10); 
DECLARE @dataBase sysname;
SET @dataBase = N'FasiccoPersoneli';
/********/
SET @codeStr = 38;
 -- کرمان --کد استان

DECLARE @mdfFile sysname ,
  @ldfFile sysname;

SET @mdfFile = N'D:\Ostan\' + @dataBase + '\FasicoPersoneli.mdf';
SET @mdfFile = N'D:\Ostan\' + @dataBase + '\FasicoPersoneli_log.mdf';

RESTORE DATABASE @dataBase 
FROM  DISK = N'D:\Backup_DataBase_Empty\FasicoPersoneli2008.bak' WITH  FILE = 1, 
MOVE N'FasicoPersoneliEmpty' TO @mdfFile,  
MOVE N'FasicoPersoneliEmpty_log' TO @ldfFile,  NOUNLOAD,  STATS = 10;


/********/
USE FasiccoPersoneli;
 ---تغییر نام دیتابیس

DECLARE @cfyCodeInt INT;

SELECT  @cfyCodeInt = cfyVCodeInt
FROM    PRS.Personeli.PRS.PRS_TBL_SYSClassify
WHERE   ParentVcodeInt = 85 AND cfyVCodeStr = @codeStr;

PRINT @cfyCodeInt;

-- Step 1
SET IDENTITY_INSERT PRS.PRS_TBL_SYSClassify ON;

INSERT  INTO PRS.PRS_TBL_SYSClassify ( cfyVCodeInt, cfyNameStr, ParentVcodeInt, cfyVCodeStr, cfyParentNameStr, ImportedData, cfyTreeCodeStr )
SELECT  cfyVCodeInt, cfyNameStr, ParentVcodeInt, cfyVCodeStr, cfyParentNameStr, ImportedData, cfyTreeCodeStr
FROM    PRS.Personeli.PRS.PRS_TBL_SYSClassify
WHERE   cfyVCodeInt = @cfyCodeInt;

INSERT  INTO PRS.PRS_TBL_SYSClassify ( cfyVCodeInt, cfyNameStr, ParentVcodeInt, cfyVCodeStr, cfyParentNameStr, ImportedData, cfyTreeCodeStr )
SELECT  cfyVCodeInt, cfyNameStr, ParentVcodeInt, cfyVCodeStr, cfyParentNameStr, ImportedData, cfyTreeCodeStr
FROM    PRS.Personeli.PRS.PRS_TBL_SYSClassify
WHERE   ParentVcodeInt = @cfyCodeInt;

SET IDENTITY_INSERT PRS.PRS_TBL_SYSClassify OFF;

DECLARE @sysClassfiyCount INT;
SELECT  @sysClassfiyCount = COUNT(cfyVCodeInt)
FROM    PRS.PRS_TBL_SYSClassify;

PRINT @sysClassfiyCount;
PRINT 'Inserted Classify';
-- Step 2
SELECT  prsVCodeLng
INTO    Person
FROM    PRS.Personeli.PRS.PRS_TBL_Person AS p WITH ( NOLOCK )
WHERE   EXISTS ( SELECT 1
                 FROM   PRS.Personeli.PRS.PRS_TBL_PersonClassify AS pc WITH ( NOLOCK )
                 INNER JOIN PRS.PRS_TBL_SYSClassify AS s WITH ( NOLOCK ) ON s.cfyVCodeInt = pc.pcfcfyVCodeInt
                 WHERE  pc.pcfprsVCodeGUID = p.prsVCodeGUID );
DECLARE @personCount INT; 
SELECT  @personCount = COUNT(*)
FROM    Person WITH ( NOLOCK );
PRINT @personCount;
WHILE ( 1 = 1 )
BEGIN

  SET IDENTITY_INSERT PRS.PRS_TBL_Person ON;
  INSERT  INTO PRS.PRS_TBL_Person ( prsVCodeLng, prsVCodeGUID, serial_no_DOS, prsFileNoStr, prsCoreFileNoStr, prsPersCodeStr, prsNationalCodeStr, prsNameStr,
                                    prsFamilyStr, prsFatherNameStr, prsMotherNameStr, prsSSNSerialNoStr, prsSSNStr, prsBirthDate, prsIssueDate, prsHireDate,
                                    prsDeadDate, prsLastFamilyStr, prsAliasNameStr, prsSSNTypeTny, prsSecondDate, prsSecondDescStr, prsMarriageStatusTny,
                                    prsSexTny, prsusrVcodeLng, prsHeightTny, prsWeightTny, prsSpecialSignStr, FinalRegisterTny, prsDescStr, DeleteFlagTny,
                                    prsFaceColorStr, prsHairColorStr, prseyeColorStr, prsBloodStr, prsReligionStr, prsBirthCityStr, prsIssueCityStr,
                                    prsCountryStr, prsLastCountryStr, PersonUniquenessField, prsSecondSSNSerialNoStr, prscfyVCodeInt, prsArchiveSSN,
                                    prsSummaryDocument, prsDescriptionSS, prsSectID, Imported, prsSSNSerialNumber, prsSSNSeries, prsSSNRow, prsDocRegDate,
                                    prsDocfinalRegDate, prsDocLevID, prsArchiveSsnEnteredUser )
  SELECT TOP 10000
          p.prsVCodeLng, prsVCodeGUID, serial_no_DOS, prsFileNoStr, prsCoreFileNoStr, prsPersCodeStr, prsNationalCodeStr, prsNameStr, prsFamilyStr,
          prsFatherNameStr, prsMotherNameStr, prsSSNSerialNoStr, prsSSNStr, prsBirthDate, prsIssueDate, prsHireDate, prsDeadDate, prsLastFamilyStr,
          prsAliasNameStr, prsSSNTypeTny, prsSecondDate, prsSecondDescStr, prsMarriageStatusTny, prsSexTny, prsusrVcodeLng, prsHeightTny, prsWeightTny,
          prsSpecialSignStr, FinalRegisterTny, prsDescStr, DeleteFlagTny, prsFaceColorStr, prsHairColorStr, prseyeColorStr, prsBloodStr, prsReligionStr,
          prsBirthCityStr, prsIssueCityStr, prsCountryStr, prsLastCountryStr, PersonUniquenessField, prsSecondSSNSerialNoStr, prscfyVCodeInt, prsArchiveSSN,
          prsSummaryDocument, prsDescriptionSS, prsSectID, Imported, prsSSNSerialNumber, prsSSNSeries, prsSSNRow, prsDocRegDate, prsDocfinalRegDate, prsDocLevID,
          prsArchiveSsnEnteredUser
  FROM    PRS.Personeli.PRS.PRS_TBL_Person AS p WITH ( NOLOCK )
  INNER JOIN Person AS pp WITH ( NOLOCK ) ON p.prsVCodeLng = pp.prsVCodeLng;
  SET IDENTITY_INSERT PRS.PRS_TBL_Person OFF;

  WITH  cte
          AS ( SELECT *
               FROM   Person AS p WITH ( NOLOCK )
               WHERE  EXISTS ( SELECT 1
                               FROM   PRS.PRS_TBL_Person AS pim WITH ( NOLOCK )
                               WHERE  p.prsVCodeLng = pim.prsVCodeLng ))
    DELETE  FROM cte;

  SELECT  @personCount = COUNT(*)
  FROM    Person WITH ( NOLOCK );
  PRINT @countItem;
  IF ( @personCount = 0 )
  BEGIN
    DROP TABLE Person;
    BREAK;
  END;
END;
PRINT 'Inserted Person';

--Step 3
DISABLE TRIGGER PRS.TRG_UpdateArchiveSsn ON PRS.PRS_TBL_PersonClassify;

SET IDENTITY_INSERT PRS.PRS_TBL_PersonClassify ON;
INSERT  INTO PRS.PRS_TBL_PersonClassify ( pcfVCodeInt, pcfprsVCodeGUID, pcfcfyVCodeInt, pcfcfyDateRegister )
SELECT  pcfVCodeInt, pcfprsVCodeGUID, pcfcfyVCodeInt, pcfcfyDateRegister
FROM    PRS.Personeli.PRS.PRS_TBL_PersonClassify AS pc WITH ( NOLOCK )
INNER JOIN PRS.PRS_TBL_SYSClassify AS s WITH ( NOLOCK ) ON s.cfyVCodeInt = pc.pcfcfyVCodeInt
ORDER BY pcfVCodeInt ASC;
SET IDENTITY_INSERT PRS.PRS_TBL_PersonClassify OFF;

PRINT 'Inserted PersonClassify';

-- Step 3
ALTER INDEX [IDX_Unq_BeginDateTypePGuid] ON [PRS].[PRS_TBL_PersonAddress] DISABLE;

SET IDENTITY_INSERT PRS.PRS_TBL_PersonAddress ON;
INSERT  INTO PRS.PRS_TBL_PersonAddress ( adrVCodeLng, adrprsVCodeGUID, adrBeginDate, adrEndDate, adrAddressStr, adrPostalCodeStr, adrOwnerType, adrEMailStr,
                                         adrMobileStr, adrPhoneStr, adrFaxStr, FinalRegisterTny, adrDescStr, adrTypeStr, adrCityStr, Imported )
SELECT  pa.adrVCodeLng, pa.adrprsVCodeGUID, pa.adrBeginDate, pa.adrEndDate, pa.adrAddressStr, pa.adrPostalCodeStr, pa.adrOwnerType, pa.adrEMailStr,
        pa.adrMobileStr, pa.adrPhoneStr, pa.adrFaxStr, pa.FinalRegisterTny, pa.adrDescStr, pa.adrTypeStr, pa.adrCityStr, pa.Imported
FROM    PRS.Personeli.PRS.PRS_TBL_PersonAddress AS pa WITH ( NOLOCK )
INNER JOIN PRS.PRS_TBL_Person AS p WITH ( NOLOCK ) ON p.prsVCodeGUID = pa.adrprsVCodeGUID
ORDER BY pa.adrVCodeLng ASC;
SET IDENTITY_INSERT PRS.PRS_TBL_PersonAddress OFF;

PRINT 'Inserted PersonAddress';

-- Step 4
SET IDENTITY_INSERT PRS.PRS_TBL_PersonJob ON;
INSERT  INTO PRS.PRS_TBL_PersonJob ( pjbVCodeLng, pjbprsVCodeGUID, pjbTitleStr, pjbOrganPostTypeTny, pjbBeginDate, pjbEndDate, pjbDescStr, pjbOutCauseStr,
                                     FinalRegisterTny, pjbJobStr, pjbStatusStr, pjbCompanionTypeStr, pjbOrganPostStr, pjbOrganUnitStr, pjbEnterpriseNameStr,
                                     pjbPersCodeStr, pjbFlagTny )
SELECT  pj.pjbVCodeLng, pj.pjbprsVCodeGUID, pj.pjbTitleStr, pj.pjbOrganPostTypeTny, pj.pjbBeginDate, pj.pjbEndDate, pj.pjbDescStr, pj.pjbOutCauseStr,
        pj.FinalRegisterTny, pj.pjbJobStr, pj.pjbStatusStr, pj.pjbCompanionTypeStr, pj.pjbOrganPostStr, pj.pjbOrganUnitStr, pj.pjbEnterpriseNameStr,
        pj.pjbPersCodeStr, pj.pjbFlagTny
FROM    PRS.Personeli.PRS.PRS_TBL_PersonJob AS pj WITH ( NOLOCK )
INNER JOIN PRS.PRS_TBL_Person AS p WITH ( NOLOCK ) ON p.prsVCodeGUID = pj.pjbprsVCodeGUID
ORDER BY pj.pjbVCodeLng ASC;
SET IDENTITY_INSERT PRS.PRS_TBL_PersonJob OFF;

PRINT 'Inserted Person Job';

-- Step 5
SET IDENTITY_INSERT PRS.PRS_TBL_PersonLeave ON;
INSERT  INTO PRS.PRS_TBL_PersonLeave ( levVCodeLng, levprsVCodeGUID, levCauseStr, levBeginDate, levEndDate, levAgreerStr, levAgreeDate, levDescStr,
                                       FinalRegisterTny, levTypeStr )
SELECT  pl.levVCodeLng, pl.levprsVCodeGUID, pl.levCauseStr, pl.levBeginDate, pl.levEndDate, pl.levAgreerStr, pl.levAgreeDate, pl.levDescStr, pl.FinalRegisterTny,
        pl.levTypeStr
FROM    PRS.Personeli.PRS.PRS_TBL_PersonLeave AS pl WITH ( NOLOCK )
INNER JOIN PRS.PRS_TBL_Person AS p WITH ( NOLOCK ) ON p.prsVCodeGUID = pl.levprsVCodeGUID
ORDER BY pl.levVCodeLng ASC;
SET IDENTITY_INSERT PRS.PRS_TBL_PersonLeave OFF;

PRINT 'Inserted Person Leave';

-- Step 5

SET IDENTITY_INSERT PRS.PRS_TBL_PersonMillitaryService ON;

INSERT  INTO PRS.PRS_TBL_PersonMillitaryService ( milVCodeLng, milprsVCodeGUID, milStatusTny, milBeginDate, milEndDate, milOrganStr, milRecordStr, milIssuerStr,
                                                  milExportGroupStr, milCardIssueDate, milNecessaryStatusTny, milDescStr, FinalRegisterTny, milCityStr )
SELECT  pm.milVCodeLng, pm.milprsVCodeGUID, pm.milStatusTny, pm.milBeginDate, pm.milEndDate, pm.milOrganStr, pm.milRecordStr, pm.milIssuerStr,
        pm.milExportGroupStr, pm.milCardIssueDate, pm.milNecessaryStatusTny, pm.milDescStr, pm.FinalRegisterTny, pm.milCityStr
FROM    PRS.Personeli.PRS.PRS_TBL_PersonMillitaryService AS pm WITH ( NOLOCK )
INNER JOIN PRS.PRS_TBL_Person AS p WITH ( NOLOCK ) ON p.prsVCodeGUID = pm.milprsVCodeGUID
ORDER BY pm.milVCodeLng ASC; 

SET IDENTITY_INSERT PRS.PRS_TBL_PersonMillitaryService OFF;
PRINT 'Inserted Person MillitaryService';

-- Step 6
IF OBJECT_ID('PersonTrainingSkills') > 0
  DROP TABLE PersonTrainingSkills; 
DECLARE @personSkilssCount INT;
SELECT  pt.sklVCodeLng
INTO    PersonTrainingSkills
FROM    PRS.Personeli.PRS.PRS_TBL_PersonTrainingSkills AS pt WITH ( NOLOCK )
INNER JOIN PRS.PRS_TBL_Person AS p WITH ( NOLOCK ) ON p.prsVCodeGUID = pt.sklprsVCodeGUID;
-------
WHILE ( 1 = 1 )
BEGIN
  SET IDENTITY_INSERT PRS.PRS_TBL_PersonTrainingSkills ON;
  INSERT  INTO PRS.PRS_TBL_PersonTrainingSkills ( sklVCodeLng, sklprsVCodeGUID, skltrskilVCodeInt, sklCertificationDate, sklGradeTny, sklDescStr,
                                                  FinalRegisterTny, sklIsDelete )
  SELECT TOP 1000
          pt.sklVCodeLng, pt.sklprsVCodeGUID, pt.skltrskilVCodeInt, pt.sklCertificationDate, pt.sklGradeTny, pt.sklDescStr, pt.FinalRegisterTny, pt.sklIsDelete
  FROM    PRS.Personeli.PRS.PRS_TBL_PersonTrainingSkills AS pt WITH ( NOLOCK )
  INNER JOIN PersonTrainingSkills AS p WITH ( NOLOCK ) ON p.sklVCodeLng = pt.sklVCodeLng;

  SET IDENTITY_INSERT PRS.PRS_TBL_PersonTrainingSkills OFF;
  WITH  cte
          AS ( SELECT *
               FROM   PersonTrainingSkills AS p WITH ( NOLOCK )
               WHERE  EXISTS ( SELECT 1
                               FROM   PRS.PRS_TBL_PersonTrainingSkills AS pt WITH ( NOLOCK )
                               WHERE  p.sklVCodeLng = pt.sklVCodeLng ))
    DELETE  FROM cte;
  SELECT  @personSkilssCount = COUNT(*)
  FROM    PersonTrainingSkills WITH ( NOLOCK );
  PRINT @personSkilssCount;
  IF ( @personSkilssCount = 0 )
  BEGIN
    DROP TABLE PersonTrainingSkills;
    BREAK;
  END;
END;
PRINT 'Inserted Person TrainingSkills';
---Step 7
SET IDENTITY_INSERT PRS.PRS_TBL_PersonDependentsDetail ON;
INSERT  INTO PRS.PRS_TBL_PersonDependentsDetail ( pddVCodeInt, pddVcodeGUID, pddprsVcodeGUIDHere, pddGenderTny, pddNameStr, pddFamilyStr, pddOldFamilyStr,
                                                  pddNationalCodeStr, pddSSNStr, pddFatherNameStr, pddBirthDate, pddShahidTny, pddAdrsStr, pddDescStr,
                                                  pddBirthCityStr, pddCountryCityStr, pddLastCountryCityStr, pddReligionStr, pddEducationGradeStr, pddJobStr,
                                                  pddSectID, Imported, PersonCode )
SELECT  pdd.pddVCodeInt, pdd.pddVcodeGUID, pdd.pddprsVcodeGUIDHere, pdd.pddGenderTny, pdd.pddNameStr, pdd.pddFamilyStr, pdd.pddOldFamilyStr,
        pdd.pddNationalCodeStr, pdd.pddSSNStr, pdd.pddFatherNameStr, pdd.pddBirthDate, pdd.pddShahidTny, pdd.pddAdrsStr, pdd.pddDescStr, pdd.pddBirthCityStr,
        pdd.pddCountryCityStr, pdd.pddLastCountryCityStr, pdd.pddReligionStr, pdd.pddEducationGradeStr, pdd.pddJobStr, pdd.pddSectID, pdd.Imported,
        pdd.PersonCode
FROM    PRS.Personeli.PRS.PRS_TBL_PersonDependentsDetail AS pdd WITH ( NOLOCK )
WHERE   EXISTS ( SELECT 1
                 FROM   PRS.Personeli.PRS.PRS_TBL_PersonDependentsDetail AS dd WITH ( NOLOCK )
                 INNER JOIN PRS.Personeli.PRS.PRS_TBL_PersonDependents AS pd WITH ( NOLOCK ) ON pd.deppddVCodeGUID = dd.pddVcodeGUID
                 INNER JOIN PRS.PRS_TBL_Person AS p WITH ( NOLOCK ) ON p.prsVCodeGUID = pd.depprsVCodeGUID
                 WHERE  dd.pddVCodeInt = pdd.pddVCodeInt )
ORDER BY pdd.pddVCodeInt ASC;

SET IDENTITY_INSERT PRS.PRS_TBL_PersonDependentsDetail ON;
PRINT 'Inserted Person Dependents Detail';

---Step 8
SET IDENTITY_INSERT PRS.PRS_TBL_PersonDependents ON;

INSERT  INTO PRS.PRS_TBL_PersonDependents ( depVCodeLng, depprsVCodeGUID, deppddVCodeGUID, depIsMoarrefTny, FinalRegisterTny, depDescStr, depRelationStr,
                                            imported )
SELECT  pd.depVCodeLng, pd.depprsVCodeGUID, pd.deppddVCodeGUID, pd.depIsMoarrefTny, pd.FinalRegisterTny, pd.depDescStr, pd.depRelationStr, pd.Imported
FROM    PRS.Personeli.PRS.PRS_TBL_PersonDependents AS pd WITH ( NOLOCK )
INNER JOIN PRS.PRS_TBL_Person AS p WITH ( NOLOCK ) ON p.prsVCodeGUID = pd.depprsVCodeGUID
ORDER BY pd.depVCodeLng ASC;

SET IDENTITY_INSERT PRS.PRS_TBL_PersonDependents ON;
PRINT 'Inserted Person Dependents';

---Step 9
SELECT  pim.pimprsVCodeGUID
INTO    PersonImages
FROM    PRS.Personeli.PRS.PRS_TBL_PersonImages AS pim WITH ( NOLOCK )
INNER JOIN PRS.PRS_TBL_Person AS p WITH ( NOLOCK ) ON p.prsVCodeGUID = pim.pimprsVCodeGUID; 

WHILE ( 1 = 1 )
BEGIN
  INSERT  INTO PRS.PRS_TBL_PersonImages ( pimprsVCodeGUID, pimPictureImg, pimSignatureImg, pimDiscription, FinalRegisterTny, ImageSize )
  SELECT TOP 10000
          pim.pimprsVCodeGUID, pim.pimPictureImg, pim.pimSignatureImg, pim.pimDiscription, pim.FinalRegisterTny, pim.ImageSize
  FROM    PRS.Personeli.PRS.PRS_TBL_PersonImages AS pim WITH ( NOLOCK )
  INNER JOIN PersonImages AS p WITH ( NOLOCK ) ON p.pimprsVCodeGUID = pim.pimprsVCodeGUID;
  WITH  cte
          AS ( SELECT *
               FROM   PersonImages AS p WITH ( NOLOCK )
               WHERE  EXISTS ( SELECT 1
                               FROM   PRS.PRS_TBL_PersonImages AS pim WITH ( NOLOCK )
                               WHERE  p.pimprsVCodeGUID = pim.pimprsVCodeGUID ))
    DELETE  FROM cte;

  DECLARE @countItem INT; 
  SELECT  @countItem = COUNT(*)
  FROM    PersonImages WITH ( NOLOCK ); 
  PRINT @countItem;
  IF ( @countItem = 0 )
  BEGIN
    DROP TABLE PersonImages;
    BREAK;
  END;
END;
PRINT 'Inserted Person Images';

--Step 10
SELECT  pim.pmaVCodeInt, pim.pmaprsVCodeGuid
INTO    PersonImageAttachment
FROM    PRS.Personeli.PRS.PRS_TBL_PersonImageAttachment AS pim WITH ( NOLOCK )
INNER JOIN PRS.PRS_TBL_Person AS p WITH ( NOLOCK ) ON p.prsVCodeGUID = pim.pmaprsVCodeGuid
ORDER BY pmaVCodeInt;
  
DECLARE @ImageAttachmentCount INT; 

SELECT  @ImageAttachmentCount = COUNT(*)
FROM    PersonImageAttachment WITH ( NOLOCK );
PRINT @ImageAttachmentCount;

WHILE ( 1 = 1 )
BEGIN

  SET IDENTITY_INSERT PRS.PRS_TBL_PersonImageAttachment ON;
  INSERT  INTO PRS.PRS_TBL_PersonImageAttachment ( pmaVCodeInt, pmaprsVCodeGuid, pmaImage, pmaImageFileName, pmasfnVcodeInt, FinalRegisterTny, pmaDescStr,
                                                   pmaDateDT, pmaVolumeFlt, pmaPgeNumber, pmaID, pmaPageNumber, pmaImageSize, ImportedDate )
  SELECT TOP 10000
          pim.pmaVCodeInt, pim.pmaprsVCodeGuid, pim.pmaImage, pim.pmaImageFileName, pim.pmasfnVcodeInt, pim.FinalRegisterTny, pim.pmaDescStr, pim.pmaDateDT,
          pim.pmaVolumeFlt, pim.pmaPgeNumber, pim.pmaID, pim.pmaPageNumber, pim.pmaImageSize, pim.ImportedDate
  FROM    PRS.Personeli.PRS.PRS_TBL_PersonImageAttachment AS pim WITH ( NOLOCK )
  INNER JOIN PersonImageAttachment AS p WITH ( NOLOCK ) ON p.pmaVCodeInt = pim.pmaVCodeInt;
  SET IDENTITY_INSERT PRS.PRS_TBL_PersonImageAttachment ON;

  WITH  cte
          AS ( SELECT *
               FROM   PersonImageAttachment AS p WITH ( NOLOCK )
               WHERE  EXISTS ( SELECT 1
                               FROM   PRS.PRS_TBL_PersonImageAttachment AS pim WITH ( NOLOCK )
                               WHERE  p.pmaVCodeInt = pim.pmaVCodeInt ))
    DELETE  FROM cte;
	
  SELECT  @ImageAttachmentCount = COUNT(*)
  FROM    PersonImageAttachment WITH ( NOLOCK );
  PRINT @ImageAttachmentCount;
  IF ( @ImageAttachmentCount = 0 )
  BEGIN
    DROP TABLE PersonImageAttachment;
    BREAK;
  END;
END;
--Step 11
USE master;
DECLARE @backupPath sysname;
SET @backupPath = N'D:\Ostan\' + @dataBase + '\FasicoPersoneli.bak'; 
ALTER DATABASE FasiccoPersoneli SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

EXECUTE sys.sp_rename
  @objname = @dataBase ,
  @newname = 'FasicoPersoneli' ,
  @objtype = 'database';

ALTER DATABASE FasiccoPersoneli SET MULTI_USER WITH ROLLBACK IMMEDIATE;

BACKUP DATABASE FasiccoPersoneli TO 
 DISK = @backupPath 
 WITH NOFORMAT, NOINIT,  NAME = N'FasicoPersoneli-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,COMPRESSION,  STATS = 10;

ALTER DATABASE FasiccoPersoneli SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

EXECUTE sys.sp_rename
  @objname = N'FasicoPersoneli' ,
  @newname = @dataBase ,
  @objtype = 'database';

EXEC master.dbo.sp_detach_db
  @dbname = @dataBase ,
  @skipchecks = 'false';
GO