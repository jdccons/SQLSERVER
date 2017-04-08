CREATE TABLE [dbo].[EDI_Search]
(
[SearchID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_EDI_Search] DEFAULT (newid()),
[VersionID] [uniqueidentifier] NULL,
[SearchDesc] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MatchBitmap] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_Search] ADD CONSTRAINT [PK_EDI_Search] PRIMARY KEY CLUSTERED  ([SearchID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_Search] ADD CONSTRAINT [FK_EDI_Search_VersionID] FOREIGN KEY ([VersionID]) REFERENCES [dbo].[EDI_Version] ([VersionID])
GO
EXEC sp_addextendedproperty N'MS_Description', 'Processing table used for HIPAA downloads.', 'SCHEMA', N'dbo', 'TABLE', N'EDI_Search', NULL, NULL
GO
