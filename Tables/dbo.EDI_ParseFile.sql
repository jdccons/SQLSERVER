CREATE TABLE [dbo].[EDI_ParseFile]
(
[FileID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_EDI_ParseFile] DEFAULT (newid()),
[FilePath] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VersionID] [uniqueidentifier] NOT NULL,
[ChunkCnt] [int] NULL,
[ComponentCnt] [int] NULL,
[FieldValueCnt] [int] NULL,
[TotalRecordCnt] [int] NULL,
[LoadCompleted] [datetime] NULL,
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_EDI_ParseFile_DateCreated] DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_ParseFile] ADD CONSTRAINT [PK_EDI_ParseFile] PRIMARY KEY CLUSTERED  ([FileID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_ParseFile] ADD CONSTRAINT [FK_EDI_ParseFile_VersionID] FOREIGN KEY ([VersionID]) REFERENCES [dbo].[EDI_Version] ([VersionID])
GO
EXEC sp_addextendedproperty N'MS_Description', 'Processing table used for HIPAA downloads.', 'SCHEMA', N'dbo', 'TABLE', N'EDI_ParseFile', NULL, NULL
GO
