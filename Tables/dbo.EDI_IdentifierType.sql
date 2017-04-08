CREATE TABLE [dbo].[EDI_IdentifierType]
(
[IdentifierType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IdentifierTypeDesc] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_IdentifierType] ADD CONSTRAINT [PK_EDIIdentifierType] PRIMARY KEY CLUSTERED  ([IdentifierType]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Processing table used for HIPAA downloads.', 'SCHEMA', N'dbo', 'TABLE', N'EDI_IdentifierType', NULL, NULL
GO
