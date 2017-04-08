SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_PFWReceivePayments]
AS
    /* =============================================
	Object:			vw_PFWReceivePayments
	Version:		6
	Author:			John Criswell
	Create date:	2014-09-05	 
	Description:	This version of vw_PFWReceivePayments
					lists out all the payments that are in
					Access/Platinum and not in QuickBooks;
					it should be used to interface from
					Access to QuickBooks	
								
							
	Change Log:
	--------------------------------------------
	Change Date		Changed by		Reason
	2014-09-19		JCriswell		Added a group by 
									to both groups and individuals	
									because the checks are often
									split between invoices;  we
									need the full amount of the check
	
	
============================================= */ 

/*  payment data needing to be interfaced to QuickBooks  */

/*  groups */
SELECT  g.Customer ,
        g.[Check Number] ,
        g.[Transaction Date] ,
        g.[Payment Method] ,
        g.Memo ,
        g.[Apply to Invoice (blank auto-applies)] ,
        g.Amount ,
        g.[Deposit To] ,
        g.[Discount Amount] ,
        g.[Discount Account] ,
        g.[AR Account] ,
        g.OrderNumber
FROM    ( 
		/*  groups grouped to sum distributed checks */
		SELECT g.CustomerName [Customer] ,
                CASE WHEN art.[DocumentNumber] = '' THEN '999999'
                     ELSE art.[DocumentNumber]
                END [Check Number] ,
                art.DocumentDate [Transaction Date] ,
                'Check' [Payment Method] ,
                '' Memo ,
                '' [Apply to Invoice (blank auto-applies)] ,
                SUM(( art.[DocumentAmt] * -1 )) Amount ,
                'Chase-Cash' [Deposit To] ,
                '' [Discount Amount] ,
                '' [Discount Account] ,
                CASE WHEN g.Spare3 = 'QCD Only' THEN 'Accts Rec-QCD Only'
                     WHEN g.Spare3 = 'All American'
                     THEN 'Accts Rec-All American'
                     ELSE 'Accts Rec-Individual'
                END [AR Account] ,
                art.OrderNumber
       FROM      ARTRANH_local art
                LEFT OUTER JOIN vw_Customer g ON art.CustomerKey = g.CustomerKey
       WHERE     art.TransactionType = 'P'
                AND g.CustomerClassKey = 'GROUP'
       GROUP BY  g.CustomerName ,
                art.DocumentNumber ,
                art.DocumentDate ,
                g.Spare3 ,
                art.OrderNumber
        ) g
        LEFT OUTER JOIN QuickBooks.dbo.receivepayment rp ON g.OrderNumber = rp.TxnID
WHERE   rp.CustomerRef_FullName IS NULL
UNION

/*  individuals */
SELECT  i.Customer ,
        i.[Check Number] ,
        i.[Transaction Date] ,
        i.[Payment Method] ,
        i.Memo ,
        i.[Apply to Invoice (blank auto-applies)] ,
        i.Amount ,
        i.[Deposit To] ,
        i.[Discount Amount] ,
        i.[Discount Account] ,
        i.[AR Account] ,
        i.OrderNumber
FROM    ( 
		/*  individuals grouped to sum distributed checks */ 
		SELECT
          s.CustomerName [Customer] ,
          CASE
          WHEN art.[DocumentNumber] = ''
          THEN '999999'
          ELSE art.[DocumentNumber]
          END [Check Number] ,
          art.DocumentDate [Transaction Date] ,
          'Check' [Payment Method] ,
          '' Memo ,
          '' [Apply to Invoice (blank auto-applies)] ,
          SUM(( art.[DocumentAmt]
          * -1 )) Amount ,
          'Chase-Cash' [Deposit To] ,
          '' [Discount Amount] ,
          '' [Discount Account] ,
          'Accts Rec-Individual' [AR Account] ,
          art.OrderNumber
         FROM
          ARTRANH_local art
          LEFT OUTER JOIN vw_Customer s ON art.CustomerKey = s.CustomerKey
         WHERE
          art.TransactionType = 'P'
          AND s.CustomerClassKey = 'INDIV'
         GROUP BY s.CustomerName ,
          art.DocumentNumber ,
          art.DocumentDate ,
          art.OrderNumber
        ) i
        LEFT OUTER JOIN QuickBooks.dbo.receivepayment rp ON i.OrderNumber = rp.TxnID
WHERE   rp.CustomerRef_FullName IS NULL;
GO
