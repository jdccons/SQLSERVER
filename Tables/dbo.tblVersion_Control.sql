CREATE TABLE [dbo].[tblVersion_Control]
(
[ID] [int] NOT NULL,
[Version] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblVersion_Control] ADD CONSTRAINT [PK_tblVersion_Control] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used for version control', 'SCHEMA', N'dbo', 'TABLE', N'tblVersion_Control', NULL, NULL
GO
