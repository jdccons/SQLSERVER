CREATE TABLE [dbo].[EDI_Version]
(
[VersionID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_EDIVersion_VersionID] DEFAULT (newid()),
[Version] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VersionDesc] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BegDtTm] [datetime] NOT NULL CONSTRAINT [DF_EDIVersion_BegDtTm] DEFAULT (getdate()),
[EndDtTm] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_Version] ADD CONSTRAINT [PK_EDIVersion] PRIMARY KEY CLUSTERED  ([VersionID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Processing table used for HIPAA downloads.', 'SCHEMA', N'dbo', 'TABLE', N'EDI_Version', NULL, NULL
GO
