CREATE TABLE [dbo].[tlkpImportSpec]
(
[GROUPID] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ImportType] [int] NULL,
[ImportDesc] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tlkpImportSpec] ADD CONSTRAINT [PK_tlkpImportSpec] PRIMARY KEY CLUSTERED  ([GROUPID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used for import specs and the groups who use them.', 'SCHEMA', N'dbo', 'TABLE', N'tlkpImportSpec', NULL, NULL
GO
