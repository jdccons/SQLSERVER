CREATE TABLE [dbo].[tblPlans]
(
[PlanID] [int] NOT NULL,
[PlanDesc] [char] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblPlans] ADD CONSTRAINT [PK_tblPlans] PRIMARY KEY CLUSTERED  ([PlanID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Descriptions of group plans.', 'SCHEMA', N'dbo', 'TABLE', N'tblPlans', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', 'Primary key', 'SCHEMA', N'dbo', 'TABLE', N'tblPlans', 'COLUMN', N'PlanID'
GO
