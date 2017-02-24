USE MASTER
GO
IF DB_ID('TEST_SSSB')>0
	DROP DATABASE TEST_SSSB
GO
CREATE DATABASE TEST_SSSB
GO
ALTER DATABASE TEST_SSSB SET ENABLE_BROKER
GO
USE TEST_SSSB
GO
IF OBJECT_ID('MSG')>0
	DROP TABLE MSG
GO
CREATE TABLE MSG
(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	TXT_MSG NVARCHAR(1000),
	CURRENT_DATETIME DATETIME 
)
GO
CREATE TABLE ERR_TBL
(
	ID INT IDENTITY PRIMARY KEY,
	ERR_DESC NVARCHAR(1000)
)
GO
CREATE MESSAGE TYPE
       [//TEST_SSSB/RequestMessage]
       VALIDATION = WELL_FORMED_XML;
GO
CREATE MESSAGE TYPE
       [//TEST_SSSB/ReplyMessage]
       VALIDATION = WELL_FORMED_XML;
GO
CREATE CONTRACT [//TEST_SSSB/SampleContract]
      ([//TEST_SSSB/RequestMessage]
       SENT BY INITIATOR,
       [//TEST_SSSB/ReplyMessage]
       SENT BY TARGET
      );
GO
CREATE QUEUE TargetQueue;
GO
CREATE SERVICE
       [//TEST_SSSB/TargetService]
       ON QUEUE TargetQueue
       ([//TEST_SSSB/SampleContract]);
GO
CREATE QUEUE InitiatorQueue;
GO
CREATE SERVICE
       [//TEST_SSSB/InitiatorService]
       ON QUEUE InitiatorQueue
GO
----------------------
ALTER PROCEDURE TargetActivProc
AS
  DECLARE @RecvReqDlgHandle UNIQUEIDENTIFIER;
  DECLARE @RecvReqMsg NVARCHAR(1000);
  DECLARE @RecvReqMsgName sysname;
	
	BEGIN TRY
		BEGIN TRANSACTION;

		WAITFOR
		( RECEIVE TOP(1)
			@RecvReqDlgHandle = conversation_handle,
			@RecvReqMsg = message_body,
			@RecvReqMsgName = message_type_name
		  FROM TargetQueue
		), TIMEOUT 5000;

		IF (@@ROWCOUNT = 0)
		BEGIN
		  ROLLBACK TRANSACTION;
		  RETURN 
		END

		IF @RecvReqMsgName =N'//TEST_SSSB/RequestMessage'
		BEGIN
			/*
		   DECLARE @ReplyMsg NVARCHAR(100);
		   SELECT @ReplyMsg =
		   N'<ReplyMsg>Message for Initiator service.</ReplyMsg>';
 
		   SEND ON CONVERSATION @RecvReqDlgHandle
				  MESSAGE TYPE 
				  [//TEST_SSSB/ReplyMessage]
				  (@ReplyMsg);
			*/
			INSERT INTO MSG(TXT_MSG,CURRENT_DATETIME) VALUES (CAST(@RecvReqMsg AS NVARCHAR(1000)),GETDATE())
			WAITFOR DELAY '00:00:05'
		END
		ELSE IF @RecvReqMsgName =N'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog'
		BEGIN
		   END CONVERSATION @RecvReqDlgHandle;
		END
		ELSE IF @RecvReqMsgName =N'http://schemas.microsoft.com/SQL/ServiceBroker/Error'
		BEGIN
		   END CONVERSATION @RecvReqDlgHandle;
		END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		INSERT INTO ERR_TBL VALUES (ERROR_MESSAGE())
	    COMMIT TRANSACTION;
	END CATCH
GO
----
ALTER QUEUE TargetQueue
    WITH ACTIVATION
    ( STATUS = ON,
      PROCEDURE_NAME = TargetActivProc,
      MAX_QUEUE_READERS = 1000,
      EXECUTE AS SELF
    );
GO

-------------------
CREATE PROCEDURE usp_InsertMsg
(
	@msg AS XML
)
AS
DECLARE @InitDlgHandle UNIQUEIDENTIFIER;
DECLARE @RequestMsg XML;

BEGIN TRANSACTION;

/*
BEGIN DIALOG @InitDlgHandle
     FROM SERVICE [//TEST_SSSB/InitiatorService]
     TO SERVICE N'//TEST_SSSB/TargetService'
     ON CONTRACT [//TEST_SSSB/SampleContract]
     WITH ENCRYPTION = OFF;
*/
BEGIN DIALOG @InitDlgHandle
     FROM SERVICE [//TEST_SSSB/TargetService]
     TO SERVICE N'//TEST_SSSB/TargetService'
     ON CONTRACT [//TEST_SSSB/SampleContract]
     WITH ENCRYPTION = OFF;

-- Send a message on the conversation
SET @RequestMsg =@msg;

SEND ON CONVERSATION @InitDlgHandle
     MESSAGE TYPE 
     [//TEST_SSSB/RequestMessage]
     (@RequestMsg);

-- Diplay sent request.
--SELECT @RequestMsg AS SentRequestMsg;

COMMIT TRANSACTION;
GO
DECLARE @X XML
SELECT @X=CAST('<V>11</V>' AS XML)
SELECT @X=CAST('11' AS XML)
EXEC usp_InsertMsg @X

SELECT * ,CAST(MESSAGE_BODY AS XML) FROM TargetQueue WITH(NOLOCK)
SELECT * FROM TargetQueue WITH(NOLOCK)

SELECT COUNT(*) FROM TargetQueue WITH(NOLOCK)
SP_WHO2

SELECT * FROM sys.dm_os_performance_counters C
	WHERE C.object_name LIKE '%BROKER%'
	

--SELECT * FROM InitiatorQueue
SELECT * FROM MSG
	WHERE TXT_MSG LIKE '11%'
SP_SPACEUSED MSG

TRUNCATE TABLE MSG


DBCC OPENTRAN
DBCC INPUTBUFFER(56)

SELECT * FROM sys.dm_broker_queue_monitors
SELECT * FROM sys.dm_broker_queue_monitors
SELECT * FROM SYS.transmission_queue

SELECT * FROM ERR_TBL


DBCC OPENTRAN


/*
DECLARE @C INT=0
WHILE @C<=10000
BEGIN
	DECLARE @X XML
	SELECT @X=CAST('<A>'+CAST(@C AS VARCHAR(100))+'</A>' AS XML)
	EXEC usp_InsertMsg @X
	SET @C+=1
END

DECLARE @C INT=20001
WHILE @C<=30000
BEGIN
	DECLARE @X XML
	SELECT @X=CAST('<C>'+CAST(@C AS VARCHAR(100))+'</C>' AS XML)
	EXEC usp_InsertMsg @X
	SET @C+=1
END
*/


SELECT COUNT(*) FROM TargetQueue WITH(NOLOCK)
GO
SP_SPACEUSED MSG
GO
SP_who2

TRUNCATE TABLE MSG