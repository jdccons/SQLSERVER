CREATE TABLE [dbo].[tblRates]
(
[RateID] [int] NOT NULL IDENTITY(1, 1),
[GroupID] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PlanID] [int] NOT NULL,
[CoverID] [int] NOT NULL,
[Rate] [float] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblRates] ADD CONSTRAINT [PK_tblRates] PRIMARY KEY CLUSTERED  ([RateID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_tblRates_GrpID_PlanID_CoverID] ON [dbo].[tblRates] ([GroupID], [PlanID], [CoverID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblRates] ADD CONSTRAINT [FK_tblRates_tblCoverage] FOREIGN KEY ([CoverID]) REFERENCES [dbo].[tblCoverage] ([CoverID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[tblRates] ADD CONSTRAINT [FK_tblRates_tblPlans] FOREIGN KEY ([PlanID]) REFERENCES [dbo].[tblPlans] ([PlanID]) ON UPDATE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', 'Rates for groups and individuals.', 'SCHEMA', N'dbo', 'TABLE', N'tblRates', NULL, NULL
GO
