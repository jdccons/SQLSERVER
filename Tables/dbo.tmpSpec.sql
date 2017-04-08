CREATE TABLE [dbo].[tmpSpec]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Spec] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpecDesc] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Moved] [bit] NOT NULL CONSTRAINT [DF_tmpSpec_Moved] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tmpSpec] ADD CONSTRAINT [PK_tmpSpec] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used for the Affiliated Dentist report.', 'SCHEMA', N'dbo', 'TABLE', N'tmpSpec', NULL, NULL
GO
