-------------------------
DROP DATABASE CDC_DEMO
GO
CREATE DATABASE CDC_DEMO
GO
USE CDC_DEMO
GO
--جدول دانش آموزان
CREATE TABLE Students
(
	CODE INT PRIMARY KEY,
	NAME NVARCHAR(50),
	FAMILY NVARCHAR(50) 
)
GO
--جدول سابقه دانش آموزان
CREATE TABLE Students_History
(
	ID INT IDENTITY PRIMARY KEY,
	CODE INT ,
	NAME NVARCHAR(50),
	FAMILY NVARCHAR(50),
	ActionType  NVARCHAR(30),
	ActionDate DATETIME,
)
GO
---------------------
--تريگر جهت درج داده ها
CREATE TRIGGER TR_Students_Insert on Students
AFTER INSERT
AS
INSERT INTO Students_History(CODE,NAME,FAMILY,ActionType,ActionDate) 
	SELECT CODE,NAME,FAMILY,'INSERT',GETDATE() FROM INSERTED
GO
---------------------
--تريگر جهت حذف داده ها
CREATE TRIGGER TR_Students_Delete on Students
AFTER DELETE
AS
INSERT INTO Students_History(CODE,NAME,FAMILY,ActionType,ActionDate) 
	SELECT CODE,NAME,FAMILY,'DELETE',GETDATE() FROM DELETED
GO
---------------------
--تريگر جهت به روز رساني ركوردها
CREATE TRIGGER TR_Students_Update on Students
AFTER UPDATE
AS
INSERT INTO Students_History(CODE,NAME,FAMILY,ActionType,ActionDate) 
	SELECT CODE,NAME,FAMILY,'UPDATE-OLD',GETDATE() FROM DELETED --مقدار قديم
INSERT INTO Students_History(CODE,NAME,FAMILY,ActionType,ActionDate) 
	SELECT CODE,NAME,FAMILY,'UPDATE-NEW',GETDATE() FROM INSERTED --مقدار جديد
GO
----------------
INSERT INTO Students VALUES (100,'Ali','Ahmadi')
INSERT INTO Students VALUES (101,'Masud','Taheri')
INSERT INTO Students VALUES (102,'Saman','Farzam')
GO
SELECT * FROM Students
SELECT * FROM Students_History
GO
DELETE FROM Students WHERE CODE=100
GO
SELECT * FROM Students
SELECT * FROM Students_History
GO
UPDATE Students SET NAME='Ali',FAMILY='Farzam Tehrani' 
	WHERE CODE=102
GO
SELECT * FROM Students
SELECT * FROM Students_History
GO
--استخراج سابقه تغييرات دانش آموز شماره 102
SELECT * FROM Students_History WHERE CODE=102
GO
DROP TABLE Students
DROP TABLE Students_History
--------------------------------------------------------------------------------------	
------------------------------ساعت 8

USE CDC_DEMO
GO
CREATE TABLE Students
(
	CODE INT PRIMARY KEY,
	NAME NVARCHAR(50),
	FAMILY NVARCHAR(50) 
)
GO
---------------------------------------------------
--CDCفعال سازي قابليت
EXEC sys.sp_cdc_enable_db
Go
------------------------------------------------
--براي جدول فوق CDC فعال سازي قابليت
--ايجاد خودكار جاب و فانكشن به 
EXEC sys.sp_cdc_enable_table
    @Source_Schema = N'dbo',
    @Source_Name   = N'Students',
    @Role_Name     = null,
    @Supports_Net_Changes = 1
GO
--گيريCaptureاستخراج پروسه هاي مربوط به 
--به ستون هايي كه قرار است تغييرات آن ذخيره شود دقت كنيد
EXEC SYS.sp_cdc_help_change_data_capture
GO
------------------------------ساعت 9
--حالتي از دستور درج اطلاعات در 2008
INSERT INTO Students VALUES 
	(100,'Ali','Ahmadi'),
	(101,'Masud','Taheri'),
	(102,'Saman','Farzam')
GO
--استخراج سابقه تغييرات
-- Please note that __$operation column indicates 1 for delete, 2 for insert,
-- 3(old Values) & 4(New Values) for update
SELECT * FROM cdc.fn_cdc_get_all_changes_dbo_Students
    (sys.fn_cdc_get_min_lsn('dbo_Students'), sys.fn_cdc_get_max_lsn(), N'all update old' )
GO
------------------------------ساعت 10
DELETE FROM Students WHERE CODE=100
GO
--استخراج سابقه تغييرات
-- Please note that __$operation column indicates 1 for delete, 2 for insert,
-- 3(old Values) & 4(New Values) for update
SELECT * FROM cdc.fn_cdc_get_all_changes_dbo_Students
    (sys.fn_cdc_get_min_lsn('dbo_Students'), sys.fn_cdc_get_max_lsn(), N'all update old' )
GO
------------------------------ساعت 11
UPDATE Students SET NAME='Ali',FAMILY='Farzam Tehrani' WHERE CODE=102
GO
--استخراج سابقه تغييرات
-- Please note that __$operation column indicates 1 for delete, 2 for insert,
-- 3(old Values) & 4(New Values) for update
SELECT * FROM cdc.fn_cdc_get_all_changes_dbo_Students
    (sys.fn_cdc_get_min_lsn('dbo_Students'), sys.fn_cdc_get_max_lsn(), N'all update old' )
GO
------------------
--به پارامتر آخر دقت شود
--كليه مقادير قديم مربوط به دستور به روز رساني نمايش داده نمي شود
SELECT * FROM cdc.fn_cdc_get_all_changes_dbo_Students 
    (sys.fn_cdc_get_min_lsn('dbo_Students'), sys.fn_cdc_get_max_lsn(), N'all')
Go
---------------------------------------------------------------------------------
--بدست آوردن سوابق تغييرات داده ها بر حسب زمان
SELECT GETDATE();
DECLARE @begin_time DATETIME
DECLARE @end_time   DATETIME
DECLARE @begin_lsn	BINARY(10)
DECLARE @end_lsn	BINARY(10)

SET @begin_time = '2010-10-21 08:57:00'
SET @end_time = '2010-10-21 10:30:00' 

SELECT @begin_lsn = sys.fn_cdc_map_time_to_lsn('smallest greater than', @begin_time); 
SELECT @end_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @end_time); 

SELECT * FROM cdc.fn_cdc_get_all_changes_dbo_Students(@begin_lsn, @end_lsn, N'all'); 
SELECT * FROM cdc.fn_cdc_get_all_changes_dbo_Students(@begin_lsn, @end_lsn, N'all update old'); 
-----------------------------------------------------------------------
--براي جدول  CDC غير فعال كردن قابليت
EXECUTE sys.sp_cdc_disable_table 
    @source_schema = N'dbo', 
    @source_name = N'Students',
    @capture_instance = N'dbo_Students';
GO
--------------------------------
--CDCغير فعال كردن قابليت
--هاJobحذف كليه  
EXEC sys.sp_cdc_disable_db
