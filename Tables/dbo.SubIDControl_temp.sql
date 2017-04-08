CREATE TABLE [dbo].[SubIDControl_temp]
(
[LastSubID] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SubIDControl_temp] ADD CONSTRAINT [PK_SubIDControl_temp] PRIMARY KEY CLUSTERED  ([LastSubID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Stores the last temporary subscriber ID.', 'SCHEMA', N'dbo', 'TABLE', N'SubIDControl_temp', NULL, NULL
GO
