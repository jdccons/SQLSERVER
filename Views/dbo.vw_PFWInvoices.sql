SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vw_PFWInvoices]
WITH SCHEMABINDING
AS
/* ====================================================================
	Object:			vw_PFWInvoices
	Version:		2
	Author:			John Criswell
	Create date:	2017-04-08	 
	Description:	Transactions from ARTRANH_local
					reformatted in QuickBooks invoice
					format; used to interface QCDOnly
					and All American invoices into
					QuickBooks
	Change Log:
	-------------------------------------------------------------------
	Change Date		Version		Changed by		Reason
	2015-01-01		1.0			JCriswell		Created
	2017-04-08		2.0			JCriswell		Simplified and added
												schemabinding for better
												performance
	
====================================================================== */
SELECT  
        c.CustomerName [Customer], h.DocumentDate [Transaction Date],
        h.DocumentNumber [RefNumber], '' [PO Number], 'Net 30' [Terms],
        gt.[Description] [Class],
        '' [Template Name], '' [To Be Printed],
        h.DocumentDate [Ship Date], 
  
		/* bill to */ 
		c.CustomerName [BillTo Line1],
        c.CustomerAddress1 [BillTo Line2], c.CustomerAddress2 [BillTo Line3],
        c.CustomerAddress3 [BillTo Line4], c.CustomerCity [BillTo City],
        c.CustomerState [BillTo State], c.CustomerZipCode [BillTo PostalCode],
        '' [BillTo Country], 
  
		/*  ship to */ 
		'' [ShipTo Line1], '' [ShipTo Line2], '' [ShipTo Line3],
        '' [ShipTo Line4], '' [ShipTo City], '' [ShipTo State],
        '' [ShipTo PostalCode], '' [ShipTo Country], 
        
        /*  contact information */
        c.ContactPhone [Phone], 
        c. FaxNumber [Fax], 
        '' [Email], 
        c.ContactName [Contact Name], 
        '' [First Name], 
        '' [Last Name],
        '' [Rep], 
        
        /* other information */
        DATEADD(DAY, 30, h.DocumentDate) [Due Date],
        '' [Ship Method], 'Thank you for your business.' [Customer Message],
        g.GroupID [Memo], 
        gt.[Description] [Item],
        1 [Quantity],        
        gt.[Description] [Description],
        DocumentAmt [Price], 
        h.IFStatus [Is Pending], 
        gt.[Description] [Item Line Class],
        '' [Service Date], '' [FOB], 
        h.CustomerKey [Customer Acct No],
        '' [Sales Tax Item], '' [To Be E-Mailed], 
        '' [Other], 
        '' [Other1],
        '' [Other2], 
        CASE
			WHEN g.GroupType = 1 THEN 'Accts Rec-QCD Only'
			WHEN g.GroupType = 4 THEN 'Accts Rec-All American'
			WHEN g.GroupType = 9 THEN 'Accts Rec-Individual'
			ELSE 'Accts Rec-Other'			
		END [AR Account], 
		'' [Sales Tax Code]
FROM    dbo.ARTRANH_local h
	 JOIN dbo.ARCUST_local c 
		ON h.CustomerKey = c.CustomerKey
	 JOIN dbo.tblGrp g
		ON c.CustomerKey = g.GroupId
	 JOIN dbo.GroupType gt
		ON g.GroupType = gt.GroupTypeId
WHERE   h.TransactionType = 'I';
GO
