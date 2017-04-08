CREATE TABLE [dbo].[tblState]
(
[STATEabbr] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[STATEname] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblState] ADD CONSTRAINT [PK_tblState] PRIMARY KEY CLUSTERED  ([STATEabbr]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Lookup table with the code and name of states.', 'SCHEMA', N'dbo', 'TABLE', N'tblState', NULL, NULL
GO
