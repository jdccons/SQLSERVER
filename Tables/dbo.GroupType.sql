CREATE TABLE [dbo].[GroupType]
(
[GroupTypeId] [int] NOT NULL,
[Description] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GroupType] ADD CONSTRAINT [PK_GroupType] PRIMARY KEY CLUSTERED  ([GroupTypeId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Lookup table which describers the type of groups.', 'SCHEMA', N'dbo', 'TABLE', N'GroupType', NULL, NULL
GO
