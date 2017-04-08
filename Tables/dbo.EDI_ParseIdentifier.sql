CREATE TABLE [dbo].[EDI_ParseIdentifier]
(
[FileID] [uniqueidentifier] NOT NULL,
[IdentifierID] [uniqueidentifier] NOT NULL,
[Level] [int] NOT NULL,
[Value] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_ParseIdentifier] ADD CONSTRAINT [PK_EDI_ParseIdentifier] PRIMARY KEY CLUSTERED  ([FileID], [IdentifierID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_ParseIdentifier] ADD CONSTRAINT [FK_EDI_ParseIdentifier_FileID] FOREIGN KEY ([FileID]) REFERENCES [dbo].[EDI_ParseFile] ([FileID])
GO
ALTER TABLE [dbo].[EDI_ParseIdentifier] ADD CONSTRAINT [FK_EDI_ParseIdentifier_IdentifierID] FOREIGN KEY ([IdentifierID]) REFERENCES [dbo].[EDI_Identifier] ([IdentifierID])
GO
EXEC sp_addextendedproperty N'MS_Description', 'Processing table used for HIPAA downloads.', 'SCHEMA', N'dbo', 'TABLE', N'EDI_ParseIdentifier', NULL, NULL
GO
