CREATE TABLE [dbo].[EDI_SearchOutcome]
(
[SearchID] [uniqueidentifier] NOT NULL,
[SearchOutcomeID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_EDI_SearchOutcome] DEFAULT (newid()),
[RecordType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FieldSeq] [int] NOT NULL,
[OutcomeName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_SearchOutcome] ADD CONSTRAINT [PK_EDI_SearchOutcome] PRIMARY KEY CLUSTERED  ([SearchOutcomeID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_SearchOutcome] ADD CONSTRAINT [FK_EDI_SearchOutcome] FOREIGN KEY ([SearchID]) REFERENCES [dbo].[EDI_Search] ([SearchID])
GO
EXEC sp_addextendedproperty N'MS_Description', 'Processing table used for HIPAA downloads.', 'SCHEMA', N'dbo', 'TABLE', N'EDI_SearchOutcome', NULL, NULL
GO
