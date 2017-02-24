USE [msdb]
GO

/****** Object:  Job [Log Document]    Script Date: 8/22/2016 4:29:49 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 8/22/2016 4:29:49 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Log Document', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DB-SERVER\Administrator', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Document]    Script Date: 8/22/2016 4:29:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Document', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = ''FscLOG'')
	EXECUTE sys.sp_executesql N''CREATE SCHEMA FscLOG AUTHORIZATION dbo''

IF (OBJECT_ID(''FscLOG.TBL_Document'') IS NULL OR OBJECT_ID(''FscLOG.TBL_Document'') < 1)
	SELECT m.[__$operation] AS OperationCode,
	CASE WHEN [m].[__$operation] = 1 THEN ''Delete'' WHEN m.[__$operation] = 2 THEN ''Insert'' WHEN m.[__$operation] = 3 THEN ''Before Update'' WHEN m.[__$operation] = 4 THEN ''After Update'' END AS OperationCaption,
	tm.tran_begin_time AS OperationBeginDateTime,tm.tran_end_time AS OperationEndDateTime,m.ID,GETDATE() AS LoggedDateTime,CAST(STUFF((
		SELECT [ID],[newsPreCode],[newsFinalRegistrationNo],[newsReportNo],[newsPriorityID],[newsLevelID],[newsProduceDateTime],[newsProducerUserID],[newsProducerOrgID],[newsSubjectID]
			  ,[newsTypeID],[newsSummery],[newsTextBody],[newsStatus],[newsSenderReciverId],[newsReceiveMethodID] ,[newsRegisterNumberInner]
			  ,[newsRegisterInnerDateTime],[newsProduceInnerDateTime],[newsPrescript] ,[newsRegisterDateTime],[newsFinalRegUsrID]
			  ,[newsFinalRegOrgID],[newsIsDeleted],[newsProduceDate],[newsRegisterDate],[newsInWarehouseNews],[newsDocumentType],[CreatorSession],[ModifierSession]
		FROM cdc.News_TBL_Document_CT
		where __$start_lsn = m.[__$start_lsn] AND [__$operation] =m.[__$operation] 
		for xml RAW(''Document''),ROOT(''Documents''),ELEMENTS),1,1,''<'') AS xml)AS Content
	INTO FscLOG.TBL_Document
	FROM cdc.News_TBL_Document_CT AS m
	INNER JOIN cdc.lsn_time_mapping AS tm ON m.[__$start_lsn] = tm.start_lsn
ELSE
	INSERT INTO FscLOG.TBL_Document
	SELECT m.[__$operation] AS OperationCode,
	CASE WHEN [m].[__$operation] = 1 THEN ''Delete'' WHEN m.[__$operation] = 2 THEN ''Insert'' WHEN m.[__$operation] = 3 THEN ''Before Update'' WHEN m.[__$operation] = 4 THEN ''After Update'' END AS OperationCaption,
	tm.tran_begin_time AS OperationBeginDateTime,tm.tran_end_time AS OperationEndDateTime,
	m.ID,GETDATE() AS LoggedDateTime,CAST(STUFF((
		SELECT [ID],[newsPreCode],[newsFinalRegistrationNo],[newsReportNo],[newsPriorityID],[newsLevelID],[newsProduceDateTime],[newsProducerUserID],[newsProducerOrgID],[newsSubjectID]
			  ,[newsTypeID],[newsSummery],[newsTextBody],[newsStatus],[newsSenderReciverId],[newsReceiveMethodID] ,[newsRegisterNumberInner]
			  ,[newsRegisterInnerDateTime],[newsProduceInnerDateTime],[newsPrescript] ,[newsRegisterDateTime],[newsFinalRegUsrID]
			  ,[newsFinalRegOrgID],[newsIsDeleted],[newsProduceDate],[newsRegisterDate],[newsInWarehouseNews],[newsDocumentType],[CreatorSession],[ModifierSession]
		FROM cdc.News_TBL_Document_CT
		where __$start_lsn = m.[__$start_lsn] AND [__$operation] =m.[__$operation] 
		for xml RAW(''Document''),ROOT(''Documents''),ELEMENTS),1,1,''<'') AS xml)AS Content
	FROM cdc.News_TBL_Document_CT AS m
	INNER JOIN cdc.lsn_time_mapping AS tm ON m.[__$start_lsn] = tm.start_lsn

DELETE FROM cdc.News_TBL_Document_CT
GO', 
		@database_name=N'FasicoNews', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Bulletin]    Script Date: 8/22/2016 4:29:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Bulletin', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = ''FscLOG'')
	EXECUTE sys.sp_executesql N''CREATE SCHEMA FscLOG AUTHORIZATION dbo''

IF (OBJECT_ID(''FscLOG.TBL_Bulletin'') IS NULL OR OBJECT_ID(''FscLOG.TBL_Bulletin'') < 1)
	SELECT m.[__$operation] AS OperationCode,
	CASE WHEN [m].[__$operation] = 1 THEN ''Delete'' WHEN m.[__$operation] = 2 THEN ''Insert'' WHEN m.[__$operation] = 3 THEN ''Before Update'' WHEN m.[__$operation] = 4 THEN ''After Update'' END AS OperationCaption
	,tm.tran_begin_time AS OperationBeginDateTime,tm.tran_end_time AS OperationEndDateTime,m.ID,GETDATE() AS LoggedDateTime,CAST(STUFF((
		SELECT [ID], [bltDocumentID], [bltBulletinTypeID], [CreatorSession], [ModifierSession]
		FROM cdc.Bulletin_TBL_Bulletin_CT
		where __$start_lsn = m.[__$start_lsn] AND [__$operation] =m.[__$operation] 
		for xml RAW(''Bulletin''),ROOT(''Bulletins''),ELEMENTS),1,1,''<'') AS xml)AS Content
	INTO FscLOG.TBL_Bulletin
	FROM cdc.Bulletin_TBL_Bulletin_CT AS m
	INNER JOIN cdc.lsn_time_mapping AS tm ON m.[__$start_lsn] = tm.start_lsn
ELSE
	INSERT INTO FscLOG.TBL_Bulletin
	SELECT m.[__$operation] AS OperationCode,
	CASE WHEN [m].[__$operation] = 1 THEN ''Delete'' WHEN m.[__$operation] = 2 THEN ''Insert'' WHEN m.[__$operation] = 3 THEN ''Before Update'' WHEN m.[__$operation] = 4 THEN ''After Update'' END AS OperationCaption
	,tm.tran_begin_time AS OperationBeginDateTime,tm.tran_end_time AS OperationEndDateTime,m.ID,GETDATE() AS LoggedDateTime,CAST(STUFF((
		SELECT [ID], [bltDocumentID], [bltBulletinTypeID], [CreatorSession], [ModifierSession]
		FROM cdc.Bulletin_TBL_Bulletin_CT
		where __$start_lsn = m.[__$start_lsn] AND [__$operation] =m.[__$operation] 
		for xml RAW(''Bulletin''),ROOT(''Bulletins''),ELEMENTS),1,1,''<'') AS xml)AS Content
	FROM cdc.Bulletin_TBL_Bulletin_CT AS m
	INNER JOIN cdc.lsn_time_mapping AS tm ON m.[__$start_lsn] = tm.start_lsn

DELETE FROM cdc.Bulletin_TBL_Bulletin_CT
GO', 
		@database_name=N'FasicoNews', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [News]    Script Date: 8/22/2016 4:29:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'News', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = ''FscLOG'')
	EXECUTE sys.sp_executesql N''CREATE SCHEMA FscLOG AUTHORIZATION dbo''

IF (OBJECT_ID(''FscLOG.TBL_News'') IS NULL OR OBJECT_ID(''FscLOG.TBL_News'') < 1)
	SELECT m.[__$operation] AS OperationCode,
	CASE WHEN [m].[__$operation] = 1 THEN ''Delete'' WHEN m.[__$operation] = 2 THEN ''Insert'' WHEN m.[__$operation] = 3 THEN ''Before Update'' WHEN m.[__$operation] = 4 THEN ''After Update'' END AS OperationCaption
	,tm.tran_begin_time AS OperationBeginDateTime,tm.tran_end_time AS OperationEndDateTime,m.ID,GETDATE() AS LoggedDateTime,CAST(STUFF((
		SELECT  [ID], [newsDocumentID], [newsFromOrgID], [newsToOrgID], [newsLocation], [newsRegionID], [newsSourceID],
				[newsToSourceDateTime], [newsToOwnerDatetime], [newsEvaluationID], [newsSourceStateID],
				[newsProtectionConsidirationID], [newsConsidiration], [newsHistory], [newsSourceViewPoint], [newsOwnerViewpoint],
				[newsOriginID], [newsUsualType], [newsUsualPositionID], [newsUsualSectionID], [newsUsualSex],
				[newsUsualDescription], [newsUsualBy], [newsFromOccurrenceDateTime], [newsToOccurrenceDateTime],
				[newsUsualPersonName], [newsUsualPersonFamily], [newsUsualPersonNationalCode], [newsUsualEnterPriseID],
				[CreatorSession], [ModifierSession]
		FROM cdc.News_TBL_News_CT
		where __$start_lsn = m.[__$start_lsn] AND [__$operation] =m.[__$operation] 
		for xml RAW(''News''),ROOT(''News''),ELEMENTS),1,1,''<'') AS xml)AS Content
	INTO FscLOG.TBL_News
	FROM cdc.News_TBL_News_CT AS m
	INNER JOIN cdc.lsn_time_mapping AS tm ON m.[__$start_lsn] = tm.start_lsn
ELSE
	INSERT INTO FscLOG.TBL_News
	SELECT m.[__$operation] AS OperationCode,
	CASE WHEN [m].[__$operation] = 1 THEN ''Delete'' WHEN m.[__$operation] = 2 THEN ''Insert'' WHEN m.[__$operation] = 3 THEN ''Before Update'' WHEN m.[__$operation] = 4 THEN ''After Update'' END AS OperationCaption,
	tm.tran_begin_time AS OperationBeginDateTime,tm.tran_end_time AS OperationEndDateTime,m.ID,GETDATE() AS LoggedDateTime,CAST(STUFF((
		SELECT  [ID], [newsDocumentID], [newsFromOrgID], [newsToOrgID], [newsLocation], [newsRegionID], [newsSourceID],
				[newsToSourceDateTime], [newsToOwnerDatetime], [newsEvaluationID], [newsSourceStateID],
				[newsProtectionConsidirationID], [newsConsidiration], [newsHistory], [newsSourceViewPoint], [newsOwnerViewpoint],
				[newsOriginID], [newsUsualType], [newsUsualPositionID], [newsUsualSectionID], [newsUsualSex],
				[newsUsualDescription], [newsUsualBy], [newsFromOccurrenceDateTime], [newsToOccurrenceDateTime],
				[newsUsualPersonName], [newsUsualPersonFamily], [newsUsualPersonNationalCode], [newsUsualEnterPriseID],
				[CreatorSession], [ModifierSession]
		FROM cdc.News_TBL_News_CT
		where __$start_lsn = m.[__$start_lsn] AND [__$operation] =m.[__$operation] 
		for xml RAW(''News''),ROOT(''News''),ELEMENTS),1,1,''<'') AS xml)AS Content
	FROM cdc.News_TBL_News_CT AS m
	INNER JOIN cdc.lsn_time_mapping AS tm ON m.[__$start_lsn] = tm.start_lsn
DELETE FROM cdc.News_TBL_News_CT
GO
', 
		@database_name=N'FasicoNews', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Dashboard]    Script Date: 8/22/2016 4:29:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Dashboard', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = ''FscLOG'')
	EXECUTE sys.sp_executesql N''CREATE SCHEMA FscLOG AUTHORIZATION dbo''

IF (OBJECT_ID(''FscLOG.TBL_Dashboard'') IS NULL OR OBJECT_ID(''FscLOG.TBL_Dashboard'') < 1)
	SELECT m.[__$operation] AS OperationCode,
	CASE WHEN [m].[__$operation] = 1 THEN ''Delete'' WHEN m.[__$operation] = 2 THEN ''Insert'' WHEN m.[__$operation] = 3 THEN ''Before Update'' WHEN m.[__$operation] = 4 THEN ''After Update'' END AS OperationCaption
	,tm.tran_begin_time AS OperationBeginDateTime,tm.tran_end_time AS OperationEndDateTime,m.ID,GETDATE() AS LoggedDateTime,CAST(STUFF((
		SELECT  [ID], [dshbDocumentID], [dshbSenderID], [dshbSenderOrgID], [dshbReceiverID], [dshbReceiverOrgID],
				[dshbPassDatetime], [dshbViewDatetime], [dshbPassPriorityID], [dshbAccessToRelatedNews], [dshbStatus],
				[dshbPassType], [dshbActionType], [dshbIsbySystem], [dshbDescription], [dshbParentID], [CreatorSession],
				[ModifierSession], [dshbPassDate], [dshbSenderName], [dshbSenderFamily], [dshbReceiverName],
				[dshbReceiverFamily], [dshbSenderOrgName], [dshbReceiverOrgName]
		FROM cdc.News_TBL_Dashboard_CT
		where __$start_lsn = m.[__$start_lsn] AND [__$operation] =m.[__$operation] 
		for xml RAW(''Dashboard''),ROOT(''Dashboards''),ELEMENTS),1,1,''<'') AS xml)AS Content
	INTO FscLOG.TBL_Dashboard
	FROM cdc.News_TBL_Dashboard_CT AS m
	INNER JOIN cdc.lsn_time_mapping AS tm ON m.[__$start_lsn] = tm.start_lsn
ELSE
	INSERT INTO FscLOG.TBL_Dashboard
	SELECT m.[__$operation] AS OperationCode,
	CASE WHEN [m].[__$operation] = 1 THEN ''Delete'' WHEN m.[__$operation] = 2 THEN ''Insert'' WHEN m.[__$operation] = 3 THEN ''Before Update'' WHEN m.[__$operation] = 4 THEN ''After Update'' END AS OperationCaption
	,tm.tran_begin_time AS OperationBeginDateTime,tm.tran_end_time AS OperationEndDateTime,m.ID,GETDATE() AS LoggedDateTime,CAST(STUFF((
		SELECT  [ID], [dshbDocumentID], [dshbSenderID], [dshbSenderOrgID], [dshbReceiverID], [dshbReceiverOrgID],
				[dshbPassDatetime], [dshbViewDatetime], [dshbPassPriorityID], [dshbAccessToRelatedNews], [dshbStatus],
				[dshbPassType], [dshbActionType], [dshbIsbySystem], [dshbDescription], [dshbParentID], [CreatorSession],
				[ModifierSession], [dshbPassDate], [dshbSenderName], [dshbSenderFamily], [dshbReceiverName],
				[dshbReceiverFamily], [dshbSenderOrgName], [dshbReceiverOrgName]
		FROM cdc.News_TBL_Dashboard_CT
		where __$start_lsn = m.[__$start_lsn] AND [__$operation] =m.[__$operation] 
		for xml RAW(''Dashboard''),ROOT(''Dashboards''),ELEMENTS),1,1,''<'') AS xml)AS Content
	FROM cdc.News_TBL_Dashboard_CT AS m
	INNER JOIN cdc.lsn_time_mapping AS tm ON m.[__$start_lsn] = tm.start_lsn
DELETE FROM cdc.News_TBL_Dashboard_CT
GO
', 
		@database_name=N'FasicoNews', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Reset Time]    Script Date: 8/22/2016 4:29:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Reset Time', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DELETE FROM cdc.lsn_time_mapping', 
		@database_name=N'FasicoNews', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=15, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20160822, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'cf7b4cf7-5a48-45d8-a891-3290f7abe9d4'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


