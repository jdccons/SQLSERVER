CREATE TABLE [dbo].[SubIDControl]
(
[LastSubID] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SubIDControl] ADD CONSTRAINT [PK_SubIDControl] PRIMARY KEY CLUSTERED  ([LastSubID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Stores the last subscriber ID.', 'SCHEMA', N'dbo', 'TABLE', N'SubIDControl', NULL, NULL
GO
