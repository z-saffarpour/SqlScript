CREATE DATABASE Logged
GO

USE Logged
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Logging](
 [id] [int] IDENTITY(1,1) NOT NULL,
 [LogonTime] [datetime] NULL,
 [LoginName] [nvarchar](max) NULL,
 [ClientHost] [varchar](50) NULL,
 [LoginType] [varchar](100) NULL,
 [AppName] [nvarchar](500) NULL,
 [FullLog] [xml] NULL,
CONSTRAINT [PK_IP_Log] PRIMARY KEY CLUSTERED
(
 [id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Logging] ADD  CONSTRAINT [DF_IP_Log_LogonTime]  DEFAULT (getdate()) FOR [LogonTime]
GO

USE Logged
GO
CREATE TRIGGER LogonTrigger ON ALL SERVER FOR LOGON
AS
BEGIN
   DECLARE @data XML
   SET @data = EVENTDATA()

   INSERT INTO Logged.dbo.[Logging]
     (
       [LoginName],
       [ClientHost],
       [LoginType],
       [AppName],
       [FullLog]
     )
   VALUES
     (
       @data.value('(/EVENT_INSTANCE/LoginName)[1]', 'nvarchar(max)'),
       @data.value('(/EVENT_INSTANCE/ClientHost)[1]', 'varchar(50)'),
       @data.value('(/EVENT_INSTANCE/LoginType)[1]', 'varchar(100)'),
       APP_NAME(),
       @data
     )
END