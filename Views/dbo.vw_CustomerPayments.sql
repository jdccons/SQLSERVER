SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_CustomerPayments]
        AS
        
/* =============================================
	Object:			vw_CustomerPayments
	Version:		2
	Author:			John Criswell
	Create date:	2014-09-05	 
	Description:	Pulls payment transactions
					out of QuickBooks.  The stored procedure,
					usp_CustomerPayments, uses this
					view to move payment transactions
					from QuickBooks to Access/
					Platinum. This view should pull
					only group customer payments -
					no individuals. 
					
							
	Change Log:
	--------------------------------------------
	Change Date		Changed by		Reason
	2014-09-27		JCriswell		Added InvoiceType as Spare3
	
	
============================================= */
        SELECT  rp.RefNumber DocumentNumber,
                '' AS TerritoryKey ,
                '' AS SalespersonKey ,
                c.AccountNumber CustomerKey ,
                CASE WHEN rp.ARAccountRef_FullName = 'Accts Rec-QCD Only' THEN 'GROUP'
                     WHEN rp.ARAccountRef_FullName = 'Accts Rec-All American' THEN 'GROUP'
                     WHEN rp.ARAccountRef_FullName = 'Accts Rec-Individual' THEN 'INDIV'
                     ELSE 'UNK'
                END AS CustomerClassKey ,
                'P' AS TransactionType ,
                rp.TxnDate AS DocumentDate ,
                rp.TotalAmount * -1 AS DocumentAmt ,
                'QCD db' AS RecUser ,
                CONVERT(VARCHAR(10), GETDATE(), 101) AS RecDate ,
                LTRIM(RIGHT(CONVERT(VARCHAR(20), GETDATE(), 100), 7)) AS RecTime ,
                rp.TxnID ,
                '' Spare ,
                '' Spare2 ,
                Case 
					When rp.ARAccountRef_FullName = 'Accts Rec-QCD Only' Then 'QCD Only'
					When rp.ARAccountRef_FullName = 'Accts Rec-All American' Then 'All American'
					Else 'Individual'
				End AS Spare3 
				FROM    QuickBooks.dbo.receivepayment AS rp
                INNER JOIN QuickBooks.dbo.customer AS c ON rp.CustomerRef_FullName = c.FullName
                WHERE   [ARAccountRef_FullName] != 'Accts Rec-Individual' ;


GO
