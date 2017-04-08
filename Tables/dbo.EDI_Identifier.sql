CREATE TABLE [dbo].[EDI_Identifier]
(
[VersionID] [uniqueidentifier] NOT NULL,
[IdentifierID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_EDIIdentifier_IdentifierID] DEFAULT (newid()),
[IdentifierType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Position] [int] NOT NULL,
[Length] [int] NULL,
[RelativeIdentifier] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_Identifier] ADD CONSTRAINT [PK_EDIIdentifier] PRIMARY KEY CLUSTERED  ([VersionID], [IdentifierType]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_EDIIdentifier_IdentifierID] ON [dbo].[EDI_Identifier] ([IdentifierID]) INCLUDE ([IdentifierType], [Length], [Position], [RelativeIdentifier], [VersionID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_Identifier] ADD CONSTRAINT [FK_EDIIdentifier_EDIVersionID] FOREIGN KEY ([VersionID]) REFERENCES [dbo].[EDI_Version] ([VersionID])
GO
ALTER TABLE [dbo].[EDI_Identifier] ADD CONSTRAINT [FK_EDIIdentifier_IdentifierType] FOREIGN KEY ([IdentifierType]) REFERENCES [dbo].[EDI_IdentifierType] ([IdentifierType])
GO
EXEC sp_addextendedproperty N'MS_Description', 'Processing table used for HIPAA downloads.', 'SCHEMA', N'dbo', 'TABLE', N'EDI_Identifier', NULL, NULL
GO
