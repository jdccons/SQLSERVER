CREATE TABLE [dbo].[tmpEDI_Rpt]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SubSSN] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EIMBRID] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubFirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubLastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanDesc] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoverageDesc] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubStreet] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubCity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubState] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubZIP] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Stat] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupID] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRMailCard] [smallint] NULL CONSTRAINT [DF_tmpEDI_Rpt_GRMailCard] DEFAULT ((0)),
[AmtPaid] [money] NULL,
[Cnt] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tmpEDI_Rpt] ADD CONSTRAINT [PK_tmpEDI_Rpt] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Temporary table used for a reconciliation report between on-premise and tpa databases.', 'SCHEMA', N'dbo', 'TABLE', N'tmpEDI_Rpt', NULL, NULL
GO
