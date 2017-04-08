SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[usp_ReconInvoice] (@InvoiceDate DATETIME)
AS
/* =============================================
	Object:			usp_ReconInvoice
	Author:			John Criswell
	Version:		1
	Create date:	2014-10-18	 
	Description:	reconciliation of invoices; 
					compares QuickBooks invoices
					to PfW invoices; identifies
					the differences		
							
	Change Log:
	--------------------------------------------
	Change Date		Changed by		Reason
	
	
	
============================================= */
/*  reconcile invoice to ARTRANH */
SELECT  ISNULL(qb.App , 'QuickBooks') App,
        ISNULL(qb.TxnID, '') TxnID ,
        ISNULL(qb.TxnNumber, '')  TxnNumber ,
        ISNULL(qb.CustomerRef_FullName, '') CustomerRef_FullName ,
        ISNULL(qb.ARAccountRef_FullName, '') ARAccountRef_FullName ,
        ISNULL(qb.TxnDate, '') TxnDate ,
        ISNULL(qb.RefNumber, '') RefNumber ,
        ISNULL(qb.Subtotal,0) SubTotal ,
        ISNULL(qb.FullName, '') FullName ,
        ISNULL(qb.AccountNumber, '') AccountNumber ,
        ISNULL(pfw.App, 'PfW') App ,
        ISNULL(pfw.DocumentNumber, '') DocumentNumber ,
        ISNULL(pfw.ApplyTo, '') ApplyTo ,
        ISNULL(pfw.CustomerKey, '') CustomerKey ,
        ISNULL(pfw.CustomerClassKey, '') CustomerClassKey ,
        ISNULL(pfw.OrderNumber, '') OrderNumber ,
        ISNULL(pfw.TransactionType, '') TransactionType ,
        ISNULL(pfw.DocumentAmt,0) DocumentAmt ,
        (ISNULL(CAST(qb.Subtotal AS DECIMAL(18,2)),0) - ISNULL(CAST(pfw.DocumentAmt AS DECIMAL(18,2)), 0)) [Difference]
FROM    ( 
			/* txns from QuickBooks */
			SELECT    'QuickBooks' [App] ,
                    i.TxnID ,
                    i.TxnNumber ,
                    i.CustomerRef_FullName ,
                    i.ARAccountRef_FullName ,
                    i.TxnDate ,
                    i.RefNumber ,
                    CAST(i.Subtotal AS DECIMAL(18,2)) Subtotal ,
                    c.FullName ,
                    c.AccountNumber
          FROM      QuickBooks..invoice AS i
                    INNER JOIN QuickBooks..customer AS c ON i.CustomerRef_FullName = c.FullName
          WHERE     MONTH(i.TxnDate) = MONTH(@InvoiceDate)
                    AND YEAR(i.TxnDate) = YEAR(@InvoiceDate)
        ) qb     
        
        FULL OUTER JOIN 
        
        ( 
			/*  txns from PfW  */
			SELECT    'PfW' [App] ,
                    art.DocumentNumber ,
                    art.ApplyTo ,
                    art.CustomerKey ,
                    art.CustomerClassKey ,
                    art.OrderNumber ,
                    art.TransactionType ,
                    CAST(art.DocumentAmt AS DECIMAL(18,2)) DocumentAmt, 
                    Spare3
          FROM      ARTRANH_local art
          WHERE     MONTH(art.DocumentDate) = MONTH(@InvoiceDate)
                    AND YEAR(art.DocumentDate) = YEAR(@InvoiceDate)
                    AND art.TransactionType = 'I'
                        
        ) pfw 
        ON qb.AccountNumber = pfw.CustomerKey
        AND qb.RefNumber = pfw.DocumentNumber
        ORDER BY ARAccountRef_FullName, CustomerRef_FullName;




GO
