CREATE TABLE [dbo].[tblCommission]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CommCustKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommCustName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommCheckNo] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommCheckDate] [datetime] NULL,
[CommCheckAmt] [float] NULL,
[CommAgent] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommRate] [float] NULL,
[CommAgentType] [smallint] NULL,
[CommInvoiceNo] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommCustClass] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EnrollmentFee] [bit] NOT NULL CONSTRAINT [DF_tblCommission_EnrollmentFee] DEFAULT ((0)),
[PayCommTo] [smallint] NULL,
[DateModified] [datetime] NOT NULL CONSTRAINT [df_tblCommission_DateModified] DEFAULT (getdate()),
[CommOrderNo] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblCommission] ADD CONSTRAINT [PK_tblCommission] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Temporary table to hold commissions earned by third parties in the current month.', 'SCHEMA', N'dbo', 'TABLE', N'tblCommission', NULL, NULL
GO
