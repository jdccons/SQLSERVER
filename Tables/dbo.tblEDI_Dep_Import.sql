CREATE TABLE [dbo].[tblEDI_Dep_Import]
(
[Action Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[First Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Middle Initial] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Dependent Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address 1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address 2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ST] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary Phone Number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Elig Start Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Elig End Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Dependent SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tier Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler 1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler 2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler 3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler 4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TID] [int] NOT NULL IDENTITY(1, 1),
[CreateDate] [smalldatetime] NULL CONSTRAINT [DF_tblEDI_Dep_Import_CreateDate] DEFAULT (getdate()),
[ModifyDate] [smalldatetime] NULL,
[FK_ID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblEDI_Dep_Import] ADD CONSTRAINT [PK_tblEDI_Dep_Import] PRIMARY KEY CLUSTERED  ([TID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblEDI_Dep_Import] ADD CONSTRAINT [FK_tblEDI_Dep_Import_tblEDI_Subscr_Import] FOREIGN KEY ([FK_ID]) REFERENCES [dbo].[tblEDI_Subscr_Import] ([TID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used to process dependent data from the import process.', 'SCHEMA', N'dbo', 'TABLE', N'tblEDI_Dep_Import', NULL, NULL
GO
