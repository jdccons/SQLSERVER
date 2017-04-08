CREATE TABLE [dbo].[ARONE_R9_local]
(
[R9Key] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastCloseDate] [datetime] NULL,
[NextInvoice] [int] NULL,
[NextTransaction] [int] NULL,
[NextDeposit] [int] NULL,
[NextOrder] [int] NULL,
[NextLateCharge] [int] NULL,
[NextFinance] [int] NULL,
[LastFinanceDate] [datetime] NULL,
[InvoiceDefault] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EliminateInvoice] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ARCostDisplayMthd] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOCostDisplayMthd] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttnLineLocation] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceDateLimit] [float] NULL,
[ShipDateLimit] [float] NULL,
[OrderDateLimit] [float] NULL,
[EditListNoAcctAction] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentTotalCheck] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UseCredMemoSlsperson] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultPriceMthd] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NextCreditMemoNum] [int] NULL,
[InvoiceNumMask] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionNumMask] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepositNumMask] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderNumMask] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LateChargeMask] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FinanceMask] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditMemoNumMask] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerKeyMask] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UseInvoiceNumber] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Spare] [nvarchar] (41) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecUserID] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecDate] [datetime] NULL,
[RecSpare] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecTime] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ARONE_R9_local] ADD CONSTRAINT [PK_R9Key] PRIMARY KEY CLUSTERED  ([R9Key]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Accounting table which maintains transaction numbers for invoice transactions.', 'SCHEMA', N'dbo', 'TABLE', N'ARONE_R9_local', NULL, NULL
GO
