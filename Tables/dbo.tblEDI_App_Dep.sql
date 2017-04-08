CREATE TABLE [dbo].[tblEDI_App_Dep]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
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
[PreexistingDate] [datetime] NULL,
[CreateDate] [smalldatetime] NULL CONSTRAINT [DF_tblEDI_App_Dep_CreateDate] DEFAULT (getdate()),
[ModifyDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblEDI_App_Dep] ADD CONSTRAINT [PK_tblEDI_App_Dep] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblEDI_App_Dep] ADD CONSTRAINT [FK_tblEDI_App_Dep_tblEDI_App_Subscr] FOREIGN KEY ([DepSubID]) REFERENCES [dbo].[tblEDI_App_Subscr] ([SubSSN]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', 'Temp table used to process dependent EDI data.', 'SCHEMA', N'dbo', 'TABLE', N'tblEDI_App_Dep', NULL, NULL
GO
