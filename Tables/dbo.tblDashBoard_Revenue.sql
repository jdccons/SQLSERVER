CREATE TABLE [dbo].[tblDashBoard_Revenue]
(
[TypeofGroup] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanID] [int] NULL,
[GroupType] [int] NULL,
[Monthly Premium] [money] NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblDashBoard_Revenue] ADD CONSTRAINT [PK_tblDashBoard_Revenue_ID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Temporary table used for monthly revenue stream report.', 'SCHEMA', N'dbo', 'TABLE', N'tblDashBoard_Revenue', NULL, NULL
GO
