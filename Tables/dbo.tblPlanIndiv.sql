CREATE TABLE [dbo].[tblPlanIndiv]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[PlanIndDesc] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanIndType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanIndRate] [decimal] (18, 2) NULL,
[Plan Cities] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoverID] [int] NULL,
[GroupID] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanID] [int] NULL,
[PlanMonths] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblPlanIndiv] ADD CONSTRAINT [PK_tblPlanIndiv] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Descriptions of individual plans.', 'SCHEMA', N'dbo', 'TABLE', N'tblPlanIndiv', NULL, NULL
GO
