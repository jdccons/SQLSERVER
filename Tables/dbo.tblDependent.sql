CREATE TABLE [dbo].[tblDependent]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SubID] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepSubID] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DepSSN] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EIMBRID] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepFirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepMiddleName] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepLastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepDOB] [datetime] NULL,
[DepAge] [int] NULL,
[DepRelationship] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepGender] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepEffDate] [datetime] NULL,
[PreexistingDate] [datetime] NULL,
[CreateDate] [datetime] NULL CONSTRAINT [DF_tblDependent_CreateDate] DEFAULT (getdate()),
[ModifyDate] [datetime] NULL,
[User01] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User02] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User03] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User04] [datetime] NULL,
[User05] [datetime] NULL,
[User06] [datetime] NULL,
[User07] [int] NULL,
[User08] [int] NULL,
[User09] [int] NULL,
[DateModified] [datetime] NULL CONSTRAINT [df_tblDependent_DateModified] DEFAULT (getdate()),
[DepCancelled] [int] NULL CONSTRAINT [DF_tblDependent_DepCancelled] DEFAULT ((1)),
[DateCreated] [datetime] NULL,
[DateUpdated] [datetime] NULL,
[DateDeleted] [datetime] NULL,
[TransactionType] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GUID] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblDependent] ADD CONSTRAINT [PK_tblDependent] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblDependent_DepSubID] ON [dbo].[tblDependent] ([DepSubID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblDependent] ADD CONSTRAINT [FK_tblDependent_tblSubscr] FOREIGN KEY ([DepSubID]) REFERENCES [dbo].[tblSubscr] ([SubSSN]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', 'Information about group and individual dependents.', 'SCHEMA', N'dbo', 'TABLE', N'tblDependent', NULL, NULL
GO
