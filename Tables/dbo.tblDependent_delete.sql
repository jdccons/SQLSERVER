CREATE TABLE [dbo].[tblDependent_delete]
(
[DepSSN] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EIMBRID] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepSubID] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DepFirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepMiddleName] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepLastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepDOB] [datetime] NULL,
[DepAge] [int] NULL,
[DepRelationship] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepGender] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepEffDate] [datetime] NULL,
[CreateDate] [smalldatetime] NULL CONSTRAINT [DF_tblDependent_delete_CreateDate] DEFAULT (getdate()),
[ModifyDate] [smalldatetime] NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblDependent_delete] ADD CONSTRAINT [PK_tblDependent_delete_temp_ID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tblDependent_delete] ON [dbo].[tblDependent_delete] ([DepSSN], [DepFirstName], [DepLastName], [DepDOB]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table to maintain the historical deletions from the website downloads.', 'SCHEMA', N'dbo', 'TABLE', N'tblDependent_delete', NULL, NULL
GO
