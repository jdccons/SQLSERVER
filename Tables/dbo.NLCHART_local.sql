CREATE TABLE [dbo].[NLCHART_local]
(
[Acct] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctDescription] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctStatus] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctType] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctSubtype] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RsrvInfltyp] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TranslationType] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsolAcctOverride] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ForceDetailToParent] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ForceDetailFrmSubsys] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatisticalMode] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RsrvRptky] [int] NULL,
[RevalRateType] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RevalFEGainKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[APSubsystem] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARSubsystem] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BBSubsystem] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INSubsystem] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PCSubsystem] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRSubsystem] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved1] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved2] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved3] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Spare] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecUserID] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecDate] [datetime] NULL,
[RecTime] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NLCHART_local] ADD CONSTRAINT [PK_NLCHART_local] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Accounting table with chart of accounts.', 'SCHEMA', N'dbo', 'TABLE', N'NLCHART_local', NULL, NULL
GO
