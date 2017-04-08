CREATE TABLE [dbo].[EDI_IdentifierLevel]
(
[IdentifierID] [uniqueidentifier] NOT NULL,
[IdentifierLevelID] [uniqueidentifier] NOT NULL CONSTRAINT [PK_EDIIdentifierLevel_IdentifierLevelID] DEFAULT (newid()),
[Level] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_IdentifierLevel] ADD CONSTRAINT [FK_EDIIdentifierLevel_IdentifierID] FOREIGN KEY ([IdentifierID]) REFERENCES [dbo].[EDI_Identifier] ([IdentifierID])
GO
EXEC sp_addextendedproperty N'MS_Description', 'Processing table used for HIPAA downloads.', 'SCHEMA', N'dbo', 'TABLE', N'EDI_IdentifierLevel', NULL, NULL
GO
