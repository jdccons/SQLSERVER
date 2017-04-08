CREATE TABLE [dbo].[tblCommissionBillPayment]
(
[TxnID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TimeCreated] [datetime] NULL,
[TxnNumber] [int] NULL,
[AccountNumber] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RefNumber] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TxnDate] [datetime] NULL,
[Amount] [decimal] (18, 2) NULL,
[Memo] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimeModified] [datetime] NULL,
[EditSequence] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayeeEntityRef_ListID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayeeEntityRef_FullName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[APAccountRef_ListID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[APAccountRef_FullName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankAccountRef_ListID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankAccountRef_FullName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrencyRef_ListID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrencyRef_FullName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExchangeRate] [decimal] (18, 2) NULL,
[AmountInHomeCurrency] [decimal] (18, 2) NULL,
[Address_Addr1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Addr2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_PostalCode] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Country] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Note] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsToBePrinted] [bit] NULL,
[Status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [datetime] NULL CONSTRAINT [DF_tblCommissionBillPayment_DateModified] DEFAULT (getdate())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_tblCommissionBillPayment_DateModified] ON 
	[dbo].[tblCommissionBillPayment]
FOR UPDATE
AS
BEGIN
	/* update date modified */
	UPDATE cbp
	SET DateModified = GETDATE()
	FROM dbo.tblCommissionBillPayment cbp
	INNER JOIN inserted i
		ON cbp.TxnID = i.TxnID;
END
GO
ALTER TABLE [dbo].[tblCommissionBillPayment] ADD CONSTRAINT [PK_tblCommissionBillPayment] PRIMARY KEY CLUSTERED  ([TxnID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Transaction table to hold commissions paid data from QuickBooks.', 'SCHEMA', N'dbo', 'TABLE', N'tblCommissionBillPayment', NULL, NULL
GO
