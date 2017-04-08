SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

	CREATE VIEW [dbo].[vw_InvoiceHeader] as
	
	SELECT  
		h.DocumentNumber RefNumber,
		c.CustomerName Customer,
		h.DocumentDate TxnDate,
		DATEADD(DAY, 30, h.DocumentDate) DueDate,
		h.DocumentDate ShipDate,
		'' ShipMethodName,
		'' TrackingNum,
		'Net 30' SalesTerm,
		c.CustomerAddress1 [BillAddrLine1],
		c.CustomerAddress2 [BillAddrLine2],
		c.CustomerAddress3 [BillAddrLine3],
		'' [BillAddrLine4],
		c.CustomerCity [BillAddrLineCity],
		c.CustomerState [BillAddrLineState],
		c.CustomerZipCode [BillAddrLinePostalCode],
		'' [BillAddrLineCountry],
		'' [ShipAddrLine1],
	    '' [ShipAddrLine2],
	    '' [ShipAddrLine3],
	    '' [ShipAddrLine4],
	    '' [ShipAddrLineCity],
	    '' [ShipAddrLineState],
	    '' [ShipAddrLinePostalCode],
	    '' [ShipAddrLineCountry],
	    '' Note,
	    'Thank you for your business' Msg,
	    '' BillEmail,
	    'Y' ToBePrinted,
	    'N' ToBeEmailed,
	    '' ShipAmt,
	    '' ShipItem,
	    '' ShipTaxCode,
	    '' DiscountAmt,
	    '' DiscountRate,
	    '' LineServiceDate,
	    '' LineAmt,
	    '' LineTaxCode,
	    '' LineClass
FROM    dbo.ARTRANH_local h
			LEFT OUTER JOIN dbo.ARCUST_local c 
				ON h.CustomerKey = c.CustomerKey
WHERE   h.TransactionType = 'I'
     	AND DocumentAmt != 0
UNION
	SELECT  
		i.DocumentNumber RefNumber,
		c.CustomerName Customer,
		i.DocumentDate TxnDate,
		DATEADD(DAY, 30, i.DocumentDate) DueDate,
		i.DocumentDate ShipDate,
		'' ShipMethodName,
		'' TrackingNum,
		'Net 30' SalesTerm,
		c.CustomerAddress1 [BillAddrLine1],
		c.CustomerAddress2 [BillAddrLine2],
		c.CustomerAddress3 [BillAddrLine3],
		'' [BillAddrLine4],
		c.CustomerCity [BillAddrLineCity],
		c.CustomerState [BillAddrLineState],
		c.CustomerZipCode [BillAddrLinePostalCode],
		'' [BillAddrLineCountry],
		'' [ShipAddrLine1],
	    '' [ShipAddrLine2],
	    '' [ShipAddrLine3],
	    '' [ShipAddrLine4],
	    '' [ShipAddrLineCity],
	    '' [ShipAddrLineState],
	    '' [ShipAddrLinePostalCode],
	    '' [ShipAddrLineCountry],
	    '' Note,
	    'Thank you for your business' Msg,
	    '' BillEmail,
	    'Y' ToBePrinted,
	    'N' ToBeEmailed,
	    '' ShipAmt,
	    '' ShipItem,
	    '' ShipTaxCode,
	    '' DiscountAmt,
	    '' DiscountRate,
	    '' LineServiceDate,
	    '' LineAmt,
	    '' LineTaxCode,
	    '' LineClass
FROM    dbo.ARTRAN_local i
			LEFT OUTER JOIN dbo.ARCUST_local c 
				ON i.CustomerKey = c.CustomerKey
WHERE   i.TransactionType = 'I'
     	AND DocumentAmt != 0
GO
