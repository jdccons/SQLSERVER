CREATE TABLE [dbo].[tblEDI_Subscr_Import]
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
[SUBRate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TID] [int] NOT NULL IDENTITY(1, 1),
[CreateDate] [smalldatetime] NULL,
[ModifyDate] [smalldatetime] NULL CONSTRAINT [DF_tblEDI_Subscr_Import_ModifyDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblEDI_Subscr_Import] ADD CONSTRAINT [PK_tblEDI_Subscr_Import] PRIMARY KEY CLUSTERED  ([TID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used to process subscriber data from the import process.', 'SCHEMA', N'dbo', 'TABLE', N'tblEDI_Subscr_Import', NULL, NULL
GO
