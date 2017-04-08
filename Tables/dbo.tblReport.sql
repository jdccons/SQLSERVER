CREATE TABLE [dbo].[tblReport]
(
[TID] [int] NOT NULL IDENTITY(1, 1),
[ReportID] [int] NULL,
[MenuItem] [int] NULL,
[ReportTitle] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportDescription] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CriteriaForm] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comments] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblReport] ADD CONSTRAINT [PK_tblReport] PRIMARY KEY CLUSTERED  ([TID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblReport_MenuItem_ReportID] ON [dbo].[tblReport] ([MenuItem], [ReportID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table for attributes for various reports.', 'SCHEMA', N'dbo', 'TABLE', N'tblReport', NULL, NULL
GO
