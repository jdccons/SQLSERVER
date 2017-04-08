CREATE TABLE [dbo].[ARTRAN_local]
(
[DocumentNumber] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApplyTo] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TerritoryKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalespersonKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerKey] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerClassKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderNumber] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToKey] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CheckBatch] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionType] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentDate] [datetime] NULL,
[AgeDate] [datetime] NULL,
[DaysTillDue] [smallint] NULL,
[DocumentAmt] [float] NULL,
[DiscountAmt] [float] NULL,
[FreightAmt] [float] NULL,
[TaxAmt] [float] NULL,
[CostAmt] [float] NULL,
[CommissionHomeOvride] [float] NULL,
[RetentionInvoice] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SysDocID] [int] NULL,
[ApplySysDocID] [int] NULL,
[Spare] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecUserID] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecDate] [datetime] NULL,
[RecTime] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ARTRAN_local] ADD CONSTRAINT [PK_ARTRAN_local] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Accounting table which maintains unposted accounts receivable transactions.', 'SCHEMA', N'dbo', 'TABLE', N'ARTRAN_local', NULL, NULL
GO
