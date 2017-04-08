SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_PFWSalesReceipts]

AS
/* =============================================
	Object:			vw_PFWSalesReceipts
	Version:		5
	Author:			John Criswell
	Create date:	2014-09-05	 
	Description:	Shows all the individual
					sales receipt transactions
					created in Access/Platinum.
					
					The purpose is to export these
					transactions to QuickBooks as 
					Sales Receipt transactions.
					
					There are two SSIS
					packages that use this view -
						SalesReceipts.dtsx
						SalesReceiptsOneOff.dtsx
					
					
								
							
	Change Log:
	--------------------------------------------
	Change Date		Changed by		Reason
	2014-10-14		JCriswell		Added SubID, SSN,
									and Group Type to
									Other, Other1 and Other2
	
	2014-11-24		JCriswell		Added interface status to
									[Is Pending] - U = not interfaced
									and I = interfaced
	2015-11-19		JCriswell		Added a join to tblSubscr to 
									include GroupID in the Memo field
============================================= */ 
/*

sample from TPI folder
Customer		Transaction Date	RefNumber	Payment Method	Check Number	Class	Template Name	To Be Printed	Ship Date	BillTo Line1	BillTo Line2				BillTo Line3	BillTo Line4	BillTo City	BillTo State	BillTo PostalCode	BillTo Country	ShipTo Line1	ShipTo Line2	ShipTo Line3	ShipTo Line4	ShipTo City	ShipTo State	ShipTo PostalCode	ShipTo Country	Phone	Fax	Email	Contact Name	First Name	Last Name	Rep	Due Date	Ship Method	Customer Message	Memo	Item	Quantity	Description	Price	Deposit To	Is Pending	Item Line Class	Service Date	FOB	Customer Acct No	Sales Tax Item	To Be E-Mailed	Other	Other1	Other2	Sales Tax Code
Anne's Bakery	9/1/2011			100			Check			123										Y	9/15/2009				Anne's Bakery	One Harbor Street											Anytown		NY				12345				USA				Anne's Bakery	One Harbor Street			Anytown	NY	12345	USA	(123) 456-7890											Cabinets	10	Cabinets	1000	Checking											
Anne's Bakery	9/1/2011	100	Check	123			Y	9/15/2009	Anne's Bakery	One Harbor Street			Anytown	NY	12345	USA	Anne's Bakery	One Harbor Street			Anytown	NY	12345	USA	(123) 456-7890											Hardware	10	Hardware	50	Checking											
John's Barber Shope	9/2/2011	101	Check	89			Y	9/15/2009	John's Barber Shope	1 Main Street			Anytown	NY	12345	USA	John's Barber Shope	1 Main Street			Anytown	NY	12345	USA	(999) 888-8888											Blueprints	1	Blueprints	500	Checking											
Main St Bank	9/3/2011	102	Check	18			N	9/16/2009	Main St Bank	1 State Street			Anytown	NY	12345	USA	Main St Bank	1 State Street			Anytown	NY	12345	USA	(888) 888-8888											Door	1	Door	300	Checking											
Main St Bank	9/3/2011	102	Check	18			N	9/16/2009	Main St Bank	1 State Street			Anytown	NY	12345	USA	Main St Bank	1 State Street			Anytown	NY	12345	USA	(888) 888-8888											Handles	1	Handle	10	Checking											
Main St Bank	9/3/2011	102	Check	18			N	9/16/2009	Main St Bank	1 State Street			Anytown	NY	12345	USA	Main St Bank	1 State Street			Anytown	NY	12345	USA	(888) 888-8888											Hinges	3	Hinges	5	Checking											
Main St Bank	9/3/2011	102	Check	18			N	9/16/2009	Main St Bank	1 State Street			Anytown	NY	12345	USA	Main St Bank	1 State Street			Anytown	NY	12345	USA	(888) 888-8888											Lock	1	Lock	15	Checking											
Main St Bank	9/3/2011	102	Check	18			N	9/16/2009	Main St Bank	1 State Street			Anytown	NY	12345	USA	Main St Bank	1 State Street			Anytown	NY	12345	USA	(888) 888-8888											Paint	1	Paint	8	Checking											
Gulf Gas Station	9/4/2011	103	Check	703			Y	9/17/2009	Gulf Gas Station	1 North Street			Anytown	NY	12345	USA	Gulf Gas Station	1 North Street			Anytown	NY	12345	USA	(777) 777-7777											Toilet	1	Toilet	50	Checking											
Gulf Gas Station	9/4/2011	103	Check	703			Y	9/17/2009	Gulf Gas Station	1 North Street			Anytown	NY	12345	USA	Gulf Gas Station	1 North Street			Anytown	NY	12345	USA	(777) 777-7777											Pump	1	Pump	8	Checking											
Gulf Gas Station	9/4/2011	103	Check	703			Y	9/17/2009	Gulf Gas Station	1 North Street			Anytown	NY	12345	USA	Gulf Gas Station	1 North Street			Anytown	NY	12345	USA	(777) 777-7777											Gasket	1	Gasket	5	Checking											
*/

SELECT DISTINCT
        arc.CustomerName AS [Customer] ,
        art.DocumentDate AS [Transaction Date] ,
        art.ApplyTo AS [RefNumber] ,
        'Check' AS [Payment Method] ,
        ISNULL(art.DocumentNumber, '9999999') AS [Check Number] ,
        'Individual' AS [Class] ,
        '' AS [Template Name] ,
        'N' AS [To Be Printed] ,
        art.DocumentDate AS [Ship Date] ,
        
        /*  bill to */
        arc.CustomerName AS [BillTo Line1] ,
        arc.CustomerAddress1 AS [BillTo Line2] ,
        arc.CustomerAddress2 AS [BillTo Line3] ,
        '' AS [BillTo Line4] ,
        arc.CustomerCity AS [BillTo City] ,
        arc.CustomerState AS [BillTo State] ,
        arc.CustomerZipCode AS [BillTo PostalCode] ,
        '' AS [BillTo Country] ,
        
        /*  ship to */
        arc.CustomerName AS [ShipTo Line1] ,
        arc.CustomerAddress1 AS [ShipTo Line2] ,
        arc.CustomerAddress2 AS [ShipTo Line3] ,
        '' AS [ShipTo Line4] ,
        arc.CustomerCity AS [ShipTo City] ,
        arc.CustomerState AS [ShipTo State] ,
        arc.CustomerZipCode AS [ShipTo PostalCode] ,
        '' AS [ShipTo Country] ,
        
        /* contact information */
        arc.ContactPhone AS [Phone] ,
        '' AS [Fax] ,
        arc.EmailAddress AS [Email] ,
        arc.ContactName AS [Contact Name] ,
        '' AS [First Name] ,
        '' AS [Last Name] ,
        
        /* other information */
        '' AS [Rep] ,        
        '' AS [Due Date] ,
        '' AS [Ship Method] ,
        '' AS [Customer Message] ,
        s.SubGroupID AS [Memo] ,
        
        /*  billing detail */
        'Individual' AS [Item] ,
        '1' AS [Quantity] ,
        'Individual' [Description],
        art.DocumentAmt * -1 [Price], 
        'Chase-Cash' [Deposit To],
        IFStatus AS [Is Pending] ,
        '' AS [Item Line Class] ,
        '' AS [Service Date] ,
        '' AS [FOB] ,
        arc.CustomerKey AS [Customer Acct No] ,
        '' AS [Sales Tax Item] ,
        '' AS [To Be E-Mailed] ,
        art.Spare AS [Other] ,
        art.Spare2 AS [Other1] ,
        art.Spare3 AS [Other2] ,
        '' AS [Sales Tax Code]
FROM    ARTRANH_local art
	INNER JOIN ARCUST_local arc
		ON art.CustomerKey = arc.CustomerKey
	INNER JOIN tblSubscr s
		ON art.CustomerKey = s.PltCustKey
	WHERE ((art.TransactionType = 'P')
	AND (art.CustomerClassKey = 'INDIV'));

GO
