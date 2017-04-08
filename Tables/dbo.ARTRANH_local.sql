CREATE TABLE [dbo].[ARTRANH_local]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DocumentNumber] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApplyTo] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TerritoryKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalespersonKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerKey] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerClassKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderNumber] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToKey] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[SysDocID] [int] NOT NULL,
[ApplySysDocID] [int] NULL,
[Spare] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Spare2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Spare3] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecUserID] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecDate] [datetime] NULL,
[RecTime] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User01] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User02] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User03] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User04] [datetime] NULL,
[User05] [datetime] NULL,
[User06] [datetime] NULL,
[User07] [int] NULL,
[User08] [int] NULL,
[User09] [int] NULL,
[DateModified] [datetime] NULL,
[IFStatus] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [df_ARTRANH_IFStatus] DEFAULT ('U')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ARTRANH_local] ADD CONSTRAINT [PK_ARTRANH_local] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ARTRANH_local_CustClass_TrnType] ON [dbo].[ARTRANH_local] ([CustomerClassKey], [TransactionType]) INCLUDE ([ApplyTo], [DocumentAmt], [DocumentDate], [DocumentNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ARTRANH_local_CustClass_TranType_CustKey] ON [dbo].[ARTRANH_local] ([CustomerClassKey], [TransactionType], [CustomerKey]) INCLUDE ([ApplyTo], [DocumentAmt], [DocumentDate], [DocumentNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ARTRANH_local_CustKey] ON [dbo].[ARTRANH_local] ([CustomerKey]) INCLUDE ([AgeDate], [ApplySysDocID], [ApplyTo], [CheckBatch], [CommissionHomeOvride], [CostAmt], [CustomerClassKey], [DateModified], [DaysTillDue], [DiscountAmt], [DocumentAmt], [DocumentDate], [DocumentNumber], [FreightAmt], [ID], [IFStatus], [OrderNumber], [RecDate], [RecTime], [RecUserID], [RetentionInvoice], [SalespersonKey], [ShipToKey], [Spare], [Spare2], [Spare3], [SysDocID], [TaxAmt], [TerritoryKey], [TransactionType], [User01], [User02], [User03], [User04], [User05], [User06], [User07], [User08], [User09]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ARTRANH_local_CustKey_DocNumber] ON [dbo].[ARTRANH_local] ([CustomerKey], [DocumentNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ARTRANH_local_CustomerKey_Spare3] ON [dbo].[ARTRANH_local] ([CustomerKey], [Spare3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ARTRANH_local_TransactionType_DocumentDate_] ON [dbo].[ARTRANH_local] ([TransactionType], [DocumentDate]) INCLUDE ([AgeDate], [ApplySysDocID], [ApplyTo], [CheckBatch], [CommissionHomeOvride], [CostAmt], [CustomerClassKey], [CustomerKey], [DateModified], [DaysTillDue], [DiscountAmt], [DocumentAmt], [DocumentNumber], [FreightAmt], [ID], [IFStatus], [OrderNumber], [RecDate], [RecTime], [RecUserID], [RetentionInvoice], [SalespersonKey], [ShipToKey], [Spare], [Spare2], [Spare3], [SysDocID], [TaxAmt], [TerritoryKey], [User01], [User02], [User03], [User04], [User05], [User06], [User07], [User08], [User09]) ON [PRIMARY]
GO
CREATE STATISTICS [_dta_stat_84911374_6_7] ON [dbo].[ARTRANH_local] ([CustomerKey], [CustomerClassKey])
GO
CREATE STATISTICS [_dta_stat_84911374_6_1] ON [dbo].[ARTRANH_local] ([CustomerKey], [ID])
GO
CREATE STATISTICS [_dta_stat_84911374_6_26_1] ON [dbo].[ARTRANH_local] ([CustomerKey], [Spare3], [ID])
GO
CREATE STATISTICS [_dta_stat_84911374_6_11_7] ON [dbo].[ARTRANH_local] ([CustomerKey], [TransactionType], [CustomerClassKey])
GO
CREATE STATISTICS [_dta_stat_84911374_12_11] ON [dbo].[ARTRANH_local] ([DocumentDate], [TransactionType])
GO
CREATE STATISTICS [_dta_stat_84911374_1_26] ON [dbo].[ARTRANH_local] ([ID], [Spare3])
GO
EXEC sp_addextendedproperty N'MS_Description', 'Accounting table which maintains posted accounts receivable transactions.', 'SCHEMA', N'dbo', 'TABLE', N'ARTRANH_local', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'When check, the invoice number the check was applied to', 'SCHEMA', N'dbo', 'TABLE', N'ARTRANH_local', 'COLUMN', N'ApplyTo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Either GRSUB for group ro INDIV for individual.', 'SCHEMA', N'dbo', 'TABLE', N'ARTRANH_local', 'COLUMN', N'CustomerClassKey'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Platinum customer key.  Five digits.', 'SCHEMA', N'dbo', 'TABLE', N'ARTRANH_local', 'COLUMN', N'CustomerKey'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoice or check amount.', 'SCHEMA', N'dbo', 'TABLE', N'ARTRANH_local', 'COLUMN', N'DocumentAmt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoice number when invoice, check number when check', 'SCHEMA', N'dbo', 'TABLE', N'ARTRANH_local', 'COLUMN', N'DocumentNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'P for processed, U for unprocessed.', 'SCHEMA', N'dbo', 'TABLE', N'ARTRANH_local', 'COLUMN', N'IFStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date transaction.', 'SCHEMA', N'dbo', 'TABLE', N'ARTRANH_local', 'COLUMN', N'RecDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Time of transaction.', 'SCHEMA', N'dbo', 'TABLE', N'ARTRANH_local', 'COLUMN', N'RecTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User who created the transaction.', 'SCHEMA', N'dbo', 'TABLE', N'ARTRANH_local', 'COLUMN', N'RecUserID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SubscriberID.  Eight digit number.', 'SCHEMA', N'dbo', 'TABLE', N'ARTRANH_local', 'COLUMN', N'Spare'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Social security number.', 'SCHEMA', N'dbo', 'TABLE', N'ARTRANH_local', 'COLUMN', N'Spare2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'QCD Only, All American, or Individual.', 'SCHEMA', N'dbo', 'TABLE', N'ARTRANH_local', 'COLUMN', N'Spare3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Same as GeoID', 'SCHEMA', N'dbo', 'TABLE', N'ARTRANH_local', 'COLUMN', N'TerritoryKey'
GO
EXEC sp_addextendedproperty N'MS_Description', N'I for invoice, P for payment, C for credit memo.', 'SCHEMA', N'dbo', 'TABLE', N'ARTRANH_local', 'COLUMN', N'TransactionType'
GO
