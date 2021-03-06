/****** Object:  Table [dbo].[ADUserSync]    Script Date: 4/6/2020 1:19:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ADUserSync](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[json] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[numUsers] [bigint] NULL,
	[minutesAgo]  AS (datediff(minute,[createdDate],getutcdate())),
	[createdDate] [datetime] NOT NULL,
	[createdById] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_ADUserSync] PRIMARY KEY CLUSTERED 
(
	[id] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vADUserSync]    Script Date: 4/6/2020 1:19:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vADUserSync]
AS
SELECT
[id]
,[minutesAgo]
,[numUsers]
,[createdDate]
FROM [dbo].[ADUserSync] (NOLOCK)
GO
/****** Object:  Table [dbo].[User]    Script Date: 4/6/2020 1:19:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[idNumber] [bigint] IDENTITY(1,1) NOT NULL,
	[id] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[name]  AS ([displayName]),
	[active] [bit] NOT NULL,
	[displayName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[userPrincipalName] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[givenName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[surname] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[mail] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[jobTitle] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[businessPhone] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[mobilePhone] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[createdDate] [datetime] NOT NULL,
	[createdById] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[lastModifiedDate] [datetime] NULL,
	[lastModifiedById] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[idNumber] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ADUserSync_createdById]    Script Date: 4/6/2020 1:19:24 PM ******/
CREATE NONCLUSTERED INDEX [IX_ADUserSync_createdById] ON [dbo].[ADUserSync]
(
	[createdById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ADUserSync_createdDate]    Script Date: 4/6/2020 1:19:24 PM ******/
CREATE NONCLUSTERED INDEX [IX_ADUserSync_createdDate] ON [dbo].[ADUserSync]
(
	[createdDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_User]    Script Date: 4/6/2020 1:19:24 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_User] ON [dbo].[User]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_User_active]    Script Date: 4/6/2020 1:19:24 PM ******/
CREATE NONCLUSTERED INDEX [IX_User_active] ON [dbo].[User]
(
	[active] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_User_createdById]    Script Date: 4/6/2020 1:19:24 PM ******/
CREATE NONCLUSTERED INDEX [IX_User_createdById] ON [dbo].[User]
(
	[createdById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_User_createdDate]    Script Date: 4/6/2020 1:19:24 PM ******/
CREATE NONCLUSTERED INDEX [IX_User_createdDate] ON [dbo].[User]
(
	[createdDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_User_displayName]    Script Date: 4/6/2020 1:19:24 PM ******/
CREATE NONCLUSTERED INDEX [IX_User_displayName] ON [dbo].[User]
(
	[displayName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_User_lastModifiedById]    Script Date: 4/6/2020 1:19:24 PM ******/
CREATE NONCLUSTERED INDEX [IX_User_lastModifiedById] ON [dbo].[User]
(
	[lastModifiedById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_User_lastModifiedDate]    Script Date: 4/6/2020 1:19:24 PM ******/
CREATE NONCLUSTERED INDEX [IX_User_lastModifiedDate] ON [dbo].[User]
(
	[lastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_User_userPrincipalName]    Script Date: 4/6/2020 1:19:24 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_User_userPrincipalName] ON [dbo].[User]
(
	[userPrincipalName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ADUserSync] ADD  CONSTRAINT [DF_ADUserSync_createdDate]  DEFAULT (getutcdate()) FOR [createdDate]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_createDate]  DEFAULT (getutcdate()) FOR [createdDate]
GO
/****** Object:  StoredProcedure [dbo].[stp_SyncADUsers]    Script Date: 4/6/2020 1:19:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stp_SyncADUsers]
	@userId VARCHAR(50)
	,@json NVARCHAR(MAX)
	,@numUsers BIGINT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @count BIGINT
	SELECT @count=COUNT([id]) FROM [dbo].[ADUserSync] (NOLOCK)
	IF @count >= 50
	BEGIN
		TRUNCATE TABLE [dbo].[ADUserSync]
	END

	DECLARE @id BIGINT
	INSERT INTO [dbo].[ADUserSync] ([createdById], [json], [numUsers]) VALUES (@userId, @json, @numUsers)
	SET @id=SCOPE_IDENTITY()

	EXEC [dbo].[stp_SyncADUsersCommit] @syncId=@id, @userId=@userId

    SELECT [id]=@id
END
GO
/****** Object:  StoredProcedure [dbo].[stp_SyncADUsersCommit]    Script Date: 4/6/2020 1:19:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_SyncADUsersCommit]
	@syncId BIGINT
	,@userId VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @json NVARCHAR(MAX)
	SELECT @json=[json] FROM [dbo].[ADUserSync] (NOLOCK) WHERE [id]=@syncId

	;WITH base AS
	(
		SELECT
		*
		FROM OPENJSON(@json)
		WITH
		(
			[id] VARCHAR(50) '$.id'
			,[displayName] NVARCHAR(MAX) '$.displayName'
			,[userPrincipalName] NVARCHAR(MAX) '$.userPrincipalName'
			,[givenName] NVARCHAR(MAX) '$.givenName'
			,[surname] NVARCHAR(MAX) '$.surname'
			,[mail] NVARCHAR(MAX) '$.mail'
			,[jobTitle] NVARCHAR(MAX) '$.jobTitle'
			,[businessPhone] NVARCHAR(MAX) '$.businessPhones[0]'
			,[mobilePhone] NVARCHAR(MAX) '$.mobilePhone'
		)
	)
	--SELECT * FROM base
	MERGE [dbo].[User] AS TARGET
	USING base AS SOURCE
	ON TARGET.[id]=SOURCE.[id]
	WHEN MATCHED THEN
		UPDATE
		SET
		TARGET.[lastModifiedDate]=GETUTCDATE()
		,TARGET.[lastModifiedById]=@userId
		,TARGET.[active]=1
		,TARGET.[displayName]=SOURCE.[displayName]
		,TARGET.[userPrincipalName]=SOURCE.[userPrincipalName]
		,TARGET.[givenName]=SOURCE.[givenName]
		,TARGET.[surname]=SOURCE.[surname]
		,TARGET.[mail]=SOURCE.[mail]
		,TARGET.[jobTitle]=SOURCE.[jobTitle]
		,TARGET.[businessPhone]=SOURCE.[businessPhone]
		,TARGET.[mobilePhone]=SOURCE.[mobilePhone]
	WHEN NOT MATCHED BY TARGET THEN
		INSERT
		(
			[createdById]
			,[id]
			,[active]
			,[displayName]
			,[userPrincipalName]
			,[givenName]
			,[surname]
			,[mail]
			,[jobTitle]
			,[businessPhone]
			,[mobilePhone]
		) VALUES
		(
			@userId
			,SOURCE.[id]
			,1
			,SOURCE.[displayName]
			,SOURCE.[userPrincipalName]
			,SOURCE.[givenName]
			,SOURCE.[surname]
			,SOURCE.[mail]
			,SOURCE.[jobTitle]
			,SOURCE.[businessPhone]
			,SOURCE.[mobilePhone]
		)
	WHEN NOT MATCHED BY SOURCE THEN
		UPDATE
		SET
		TARGET.[lastModifiedDate]=GETUTCDATE()
		,TARGET.[lastModifiedById]=@userId
		,TARGET.[active]=0
	;
END
GO
