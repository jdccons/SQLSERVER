SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [dbo].[vw_PFWCreditMemos]
AS

/*  invoices from PFW */


/*

format for Transaction Pro Importer into QuickBooks

Customer		Transaction Date	RefNumber	PO Number	Terms	Class	Template Name	To Be Printed	Ship Date	BillTo Line1	BillTo Line2	BillTo Line3	BillTo Line4	BillTo City	BillTo State	BillTo PostalCode	BillTo Country	ShipTo Line1	ShipTo Line2	ShipTo Line3	ShipTo Line4	ShipTo City	ShipTo State	ShipTo PostalCode	ShipTo Country	Phone	Fax	Email	Contact Name	First Name	Last Name	Rep	Due Date	Ship Method	Customer Message	Memo	Item	Quantity	Description	Price	Is Pending	Item Line Class	Service Date	Customer Acct No	Sales Tax Item	To Be E-Mailed	Other	Other1	Other2
ABC Wallpaper	10/1/2011			30						Net 30							Y							ABC Wallpaper	1 Main Street									Anytown		NY				12345				USA				ABC Wallpaper	1 Main Street			Anytown	NY	12345	USA	(123) 456-8789			John Smith						Thanks for ordering!		Misc Supplies	1	Misc Supplies	10									
Jones Hardware	10/1/2011			31						Net 30							N							Jones Hardware	12 Smith Road									Anytown		NY				12345				USA				ABC Wallpaper	1 Main Street			Anytown	NY	12345	USA	(999) 999-9999			Jane Doe						Thanks for ordering!		Hardware	1	Hardware	2000									
Jones Hardware	10/1/2011			31						Net 30							N							Jones Hardware	12 Smith Road									Anytown		NY				12345				USA				ABC Wallpaper	1 Main Street			Anytown	NY	12345	USA	(999) 999-9999			Jane Doe						Thanks for ordering!		Paint	1	Paint 	15									
Jones Hardware	10/1/2011			31						Net 30							N							Jones Hardware	12 Smith Road									Anytown		NY				12345				USA				ABC Wallpaper	1 Main Street			Anytown	NY	12345	USA	(999) 999-9999			Jane Doe						Thanks for ordering!		Door Knobs	1	Brass Door Knobs	5									
Bank of Anywho	10/2/2011			32						Net 30							N							Bank of Anywho	1800 State Street								Anytown		NY				12345				USA				Bank of Anywho	1800 State Street			Anytown	NY	12345	USA	(888) 888-8888			Mr. Jones								Light	1	Fancy Light	50									
Bank of Anywho	10/2/2011			32						Net 30							N							Bank of Anywho	1800 State Street								Anytown		NY				12345				USA				Bank of Anywho	1800 State Street			Anytown	NY	12345	USA	(888) 888-8888			Mr. Jones								Light Pull	1	Light Chain Pull	5									
Bank of Anywho	10/2/2011			32						Net 30							N							Bank of Anywho	1800 State Street								Anytown		NY				12345				USA				Bank of Anywho	1800 State Street			Anytown	NY	12345	USA	(888) 888-8888			Mr. Jones								Ceiling Fan	1	Decorative Fan	10									
Bank of Anywho	10/2/2011			32						Net 30							N							Bank of Anywho	1800 State Street								Anytown		NY				12345				USA				Bank of Anywho	1800 State Street			Anytown	NY	12345	USA	(888) 888-8888			Mr. Jones								Mount	1	Wall Mount	10									
																							
*/

/*  history */

/*  groups */
SELECT  DISTINCT
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
        SUBSTRING(ContactName,1,CHARINDEX(' ', c.ContactName, 1)-1) [First Name], 
        SUBSTRING(ContactName,CHARINDEX(' ', c.ContactName, 1)+1, LEN(ContactName)) [Last Name],
        '' [Rep], 
        
        /* other information */
        DATEADD(DAY, 30, h.DocumentDate) [Due Date],
        '' [Ship Method], 'Thank you for your business.' [Customer Message],
        '' [Memo], 
        gt.[Description] [Item],
        1 [Quantity],        
        gt.[Description] [Description],
        DocumentAmt * -1 [Price], '' [Is Pending], 
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
	LEFT OUTER JOIN dbo.ARCUST_local c 
		ON h.CustomerKey = c.CustomerKey
	LEFT OUTER JOIN tblGrp g
		ON c.CustomerKey = g.GroupId
	LEFT OUTER JOIN GroupType gt
		ON g.GroupType = gt.GroupTypeId
WHERE   h.TransactionType = 'C'
		AND h.CustomerClassKey = 'GROUP'
        
UNION       
        
/*  history individuals */
SELECT	DISTINCT
        ISNULL(c.CustomerName, '') [Customer], 
        h.DocumentDate [Transaction Date],
        h.DocumentNumber [RefNumber], 
        '' [PO Number], 
        'Net 30' [Terms],
        'Individual'  [Class], 
        '' [Template Name], 
        '' [To Be Printed],
        h.DocumentDate [Ship Date], 
  
		/* bill to */ 
		ISNULL(c.CustomerName, '') [BillTo Line1],
        ISNULL(c.CustomerAddress1, '') [BillTo Line2], 
        ISNULL(c.CustomerAddress2, '') [BillTo Line3],
        ISNULL(c.CustomerAddress3, '') [BillTo Line4], 
        ISNULL(c.CustomerCity, '') [BillTo City],
        ISNULL(c.CustomerState, '') [BillTo State], 
        ISNULL(c.CustomerZipCode, '') [BillTo PostalCode],
        '' [BillTo Country], 
  
		/*  ship to */ 
		'' [ShipTo Line1], '' [ShipTo Line2], '' [ShipTo Line3],
        '' [ShipTo Line4], '' [ShipTo City], '' [ShipTo State],
        '' [ShipTo PostalCode], '' [ShipTo Country], 
        
        /* contact information */
        ISNULL(c.ContactPhone, '') [Phone], 
        ISNULL(c. FaxNumber, '') [Fax], 
        '' [Email], 
        ISNULL(c.ContactName, '') [Contact Name], 
        ISNULL(SUBSTRING(ContactName,1,CHARINDEX(' ', ContactName, 1)-1), '') [First Name], 
        ISNULL(SUBSTRING(ContactName,CHARINDEX(' ', ContactName, 1)+1, LEN(ContactName)), '') [Last Name],
        '' [Rep], 
        
        /* other information */ 
        DATEADD(DAY, 30, h.DocumentDate) [Due Date],
        '' [Ship Method], 'Thank you for your business.' [Customer Message],
        '' [Memo], 
        'Individual' [Item], 
        1 [Quantity], 
        'Individual' [Description],
        DocumentAmt * -1 [Price], 
        '' [Is Pending],
        'Individual' [Item Line Class],
        '' [Service Date], '' [FOB], 
        h.CustomerKey [Customer Acct No], 
        '' [Sales Tax Item], 
        '' [To Be E-Mailed], 
        '' [Other], 
        '' [Other1],
        '' [Other2], 
        'Accts Rec-Individual' [AR Account], 
		'' [Sales Tax Code]
FROM    dbo.ARTRANH_local h
	INNER JOIN dbo.ARCUST_local c 
		ON h.CustomerKey = c.CustomerKey
	INNER JOIN dbo.tblSubscr s 
		ON h.CustomerKey = s.PltCustKey
WHERE   h.CustomerClassKey = 'INDIV'
		AND h.TransactionType = 'C'
		
UNION
		
/*  group - current transactions */
SELECT	DISTINCT
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
        
        /* contact information */
        c.ContactPhone [Phone], 
        c. FaxNumber [Fax], 
        '' [Email], 
        c.ContactName [Contact Name], 
        SUBSTRING(ContactName,1,CHARINDEX(' ', ContactName, 1)-1) [First Name], 
        SUBSTRING(ContactName,CHARINDEX(' ', ContactName, 1)+1, LEN(ContactName)) [Last Name],
        '' [Rep], 
        
        /* other information */ 
        DATEADD(DAY, 30, h.DocumentDate) [Due Date],
        '' [Ship Method], 'Thank you for your business.' [Customer Message],
        '' [Memo],
        gt.[Description] [Item],
        1 [Quantity],
        gt.[Description] [Description],
        DocumentAmt * -1 [Price], '' [Is Pending],
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
FROM    dbo.ARTRAN_local h
	LEFT OUTER JOIN dbo.ARCUST_local c 
		ON h.CustomerKey = c.CustomerKey
	LEFT OUTER JOIN dbo.tblGrp g 
		ON h.CustomerKey = g.GroupId
	LEFT OUTER JOIN GroupType gt
		ON g.GroupType = gt.GroupTypeId
WHERE   h.TransactionType = 'C'
        AND h.CustomerClassKey = 'GROUP'
       
       
UNION       
        
/*  individuals - current transactions  */
SELECT	DISTINCT
        ISNULL(c.CustomerName, '') [Customer], 
        h.DocumentDate [Transaction Date],
        h.DocumentNumber [RefNumber], 
        '' [PO Number], 
        'Net 30' [Terms],
        'Individual'  [Class], 
        '' [Template Name], 
        '' [To Be Printed],
        h.DocumentDate [Ship Date], 
  
		/* bill to */ 
		ISNULL(c.CustomerName, '') [BillTo Line1],
        ISNULL(c.CustomerAddress1, '') [BillTo Line2], 
        ISNULL(c.CustomerAddress2, '') [BillTo Line3],
        ISNULL(c.CustomerAddress3, '') [BillTo Line4], 
        ISNULL(c.CustomerCity, '') [BillTo City],
        ISNULL(c.CustomerState, '') [BillTo State], 
        ISNULL(c.CustomerZipCode, '') [BillTo PostalCode],
        '' [BillTo Country], 
  
		/*  ship to */ 
		'' [ShipTo Line1], '' [ShipTo Line2], '' [ShipTo Line3],
        '' [ShipTo Line4], '' [ShipTo City], '' [ShipTo State],
        '' [ShipTo PostalCode], '' [ShipTo Country], 
        
        /* contact information */
        ISNULL(c.ContactPhone, '') [Phone], 
        ISNULL(c. FaxNumber, '') [Fax], 
        '' [Email], 
        ISNULL(c.ContactName, '') [Contact Name], 
        ISNULL(SUBSTRING(ContactName,1,CHARINDEX(' ', ContactName, 1)-1), '') [First Name], 
        ISNULL(SUBSTRING(ContactName,CHARINDEX(' ', ContactName, 1)+1, LEN(ContactName)), '') [Last Name],
        '' [Rep], 
        
        /* other information */ 
        DATEADD(DAY, 30, h.DocumentDate) [Due Date],
        '' [Ship Method], 'Thank you for your business.' [Customer Message],
        '' [Memo], 
        'Individual' [Item], 
        1 [Quantity], 
        'Individual' [Description],
        DocumentAmt * -1 [Price], 
        '' [Is Pending],
        'Individual' [Item Line Class],
        '' [Service Date], '' [FOB], 
        h.CustomerKey [Customer Acct No], 
        '' [Sales Tax Item], 
        '' [To Be E-Mailed], 
        '' [Other], 
        '' [Other1],
        '' [Other2], 
        'Accts Rec-Individual' [AR Account], 
		'' [Sales Tax Code]
FROM    dbo.ARTRAN_local h
	INNER JOIN dbo.ARCUST_local c 
		ON h.CustomerKey = c.CustomerKey
	INNER JOIN dbo.tblSubscr s 
		ON h.CustomerKey = s.PltCustKey
WHERE   h.CustomerClassKey = 'INDIV'
		AND h.TransactionType = 'C';
GO
