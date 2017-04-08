CREATE TABLE [dbo].[tblCoverage]
(
[CoverID] [int] NOT NULL IDENTITY(1, 1),
[CoverCode] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CoverDescr] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblCoverage] ADD CONSTRAINT [PK_tblCoverage] PRIMARY KEY CLUSTERED  ([CoverID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Descriptions of coverages.', 'SCHEMA', N'dbo', 'TABLE', N'tblCoverage', NULL, NULL
GO
