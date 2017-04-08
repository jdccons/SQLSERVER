CREATE TABLE [dbo].[ARCUST_local]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CustomerKey] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerAddress1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerAddress2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerAddress3] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerCity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerState] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerZipCode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerCountry] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerAttention] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttnPhone] [nvarchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactPhone] [nvarchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResaleNumber] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TelexNumber] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FaxNumber] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditCardNumber] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditCardType] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpirationDate] [datetime] NULL,
[WebCustomer] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VendorKey] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditLimitAmt] [float] NULL,
[CreditHold] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentMthd] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrintStatement] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssessFinanceCharge] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaxKey] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TermsKey] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FobKey] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipViaKey] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerClassKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationKey] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToKey] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TerritoryKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalespersonKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceCommentKey] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatementCommentKey] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaxCountry] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaxID] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rsrv1] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrintTaxID] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rsrv2] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UninvoicedCredit] [float] NULL,
[PrimaryPriceMthd] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondaryPriceMthd] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WebPageURL] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameOnCreditCard] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CVV2Number] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Spare] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Spare2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Spare3] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupType] [int] NULL,
[InvoiceType] [int] NULL,
[RecUserID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecDate] [datetime] NULL,
[RecTime] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [datetime] NULL CONSTRAINT [df_ARCUST_local_DateModified] DEFAULT (getdate())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_ARCUST_local_DateModified] ON 
	[dbo].[ARCUST_local]
FOR UPDATE
AS
BEGIN
	

	/* update date modified */
	UPDATE arc
	SET DateModified = GETDATE()
	from ARCUST_local arc
	INNER JOIN inserted i
		ON arc.Spare = i.Spare;
END
GO
ALTER TABLE [dbo].[ARCUST_local] ADD CONSTRAINT [PK_ARCUST_local] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_dta_index_ARCUST_local_8_1815729571__K24_K2_K3] ON [dbo].[ARCUST_local] ([CreditHold], [CustomerKey], [CustomerName]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Accounting table for customers.', 'SCHEMA', N'dbo', 'TABLE', N'ARCUST_local', NULL, NULL
GO
