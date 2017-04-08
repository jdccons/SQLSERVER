CREATE TABLE [dbo].[tblInvHdrPreliminary]
(
[TID] [int] NOT NULL IDENTITY(1, 1),
[Custkey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custname] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custaddr1] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custaddr2] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custcity] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custstate] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custzip] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustAttn] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tranno] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Invdate] [datetime] NULL,
[Checkno] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Checkamt] [nvarchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Territkey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Salespkey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custclass] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Spare] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Spare2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Spare3] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sysdocid] [int] NULL,
[RecUserID] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecDate] [datetime] NULL,
[RecSpare] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecTime] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Timestmp] [timestamp] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblInvHdrPreliminary] ADD CONSTRAINT [PK_tblInvHdrPreliminary] PRIMARY KEY CLUSTERED  ([TID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used in the invoicing process.', 'SCHEMA', N'dbo', 'TABLE', N'tblInvHdrPreliminary', NULL, NULL
GO
