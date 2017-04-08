CREATE TABLE [dbo].[EDI_Parse]
(
[FileID] [uniqueidentifier] NOT NULL,
[ParentID] [uniqueidentifier] NULL,
[EntryID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_EDI_Parse] DEFAULT (newid()),
[ChunkNum] [int] NOT NULL,
[Level] [int] NOT NULL,
[Seq] [int] NOT NULL,
[Value] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RecordType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntitySeq] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_Parse] ADD CONSTRAINT [PK_EDI_Parse] PRIMARY KEY CLUSTERED  ([EntryID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_EDI_Parse] ON [dbo].[EDI_Parse] ([FileID], [Level], [RecordType], [EntitySeq]) INCLUDE ([ChunkNum], [EntryID], [ParentID], [Seq], [Value]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_Parse] ADD CONSTRAINT [FK_EDI_Parse_FileID] FOREIGN KEY ([FileID]) REFERENCES [dbo].[EDI_ParseFile] ([FileID])
GO
ALTER TABLE [dbo].[EDI_Parse] ADD CONSTRAINT [FK_EDI_Parse_ParentID] FOREIGN KEY ([ParentID]) REFERENCES [dbo].[EDI_Parse] ([EntryID])
GO
EXEC sp_addextendedproperty N'MS_Description', 'Processing table used for HIPAA downloads.', 'SCHEMA', N'dbo', 'TABLE', N'EDI_Parse', NULL, NULL
GO
