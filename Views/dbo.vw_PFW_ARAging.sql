SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vw_PFW_ARAging]
AS
/*  need to figure out what was unpaid @12/31/2013  */

/* invoices from history transactions */
SELECT  'Invoice' TransactionType, 
		CustomerKey, DocumentNumber InvoiceNumber, '' CheckNumber, ApplyTo, DocumentDate,
        DocumentAmt
FROM    dbo.ARTRANH_local
WHERE   TransactionType = 'I'

UNION

/* payments, credit memos, etc. from history transactions */
SELECT  CASE 
			WHEN TransactionType = 'P' THEN 'Payment'
			WHEN TransactionType = 'C' THEN 'Credit Memo'
			ELSE 'Other'
		END TransactionType,
		CustomerKey, '' InvoiceNumber, DocumentNumber, ApplyTo, DocumentDate,
        DocumentAmt
FROM    dbo.ARTRANH_local
WHERE   TransactionType != 'I'

UNION

/* invoices from current transactions */
SELECT  'Invoice' TransactionType, 
		CustomerKey, DocumentNumber InvoiceNumber, '' CheckNumber, ApplyTo, DocumentDate,
        DocumentAmt
FROM    dbo.ARTRAN_local
WHERE   TransactionType = 'I'

UNION

/* payments and credit memos */
SELECT  CASE 
			WHEN TransactionType = 'P' THEN 'Payment'
			WHEN TransactionType = 'C' THEN 'Credit Memo'
			ELSE 'Other'
		END TransactionType,
		CustomerKey, '' InvoiceNumber, DocumentNumber, ApplyTo, DocumentDate,
        DocumentAmt
FROM    dbo.ARTRAN_local
WHERE   TransactionType != 'I';

GO
