CREATE TABLE [dbo].[tmpSpecSel]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Spec] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpecDesc] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tmpSpecSel] ADD CONSTRAINT [PK_tmpSpecSel] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used for the Affiliated Dentist report.', 'SCHEMA', N'dbo', 'TABLE', N'tmpSpecSel', NULL, NULL
GO
