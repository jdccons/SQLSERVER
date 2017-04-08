SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_InvoiceHistory]
as
SELECT  i.RefNumber ,
        i.Customer ,
        i.TxnDate ,
        i.DueDate ,
        i.ShipDate ,
        i.ShipMethodName ,
        i.TrackingNum ,
        i.SalesTerm ,
        i.BillAddrLine1 ,
        i.BillAddrLine2 ,
        i.BillAddrLine3 ,
        i.BillAddrLine4 ,
        i.BillAddrLineCity ,
        i.BillAddrLineState ,
        i.BillAddrLinePostalCode ,
        i.BillAddrLineCountry ,
        i.ShipAddrLine1 ,
        i.ShipAddrLine2 ,
        i.ShipAddrLine3 ,
        i.ShipAddrLine4 ,
        i.ShipAddrLineCity ,
        i.ShipAddrLineState ,
        i.ShipAddrLinePostalCode ,
        i.ShipAddrLineCountry ,
        i.Note ,
        i.Msg ,
        i.BillEmail ,
        i.ToBePrinted ,
        i.ToBeEmailed ,
        i.ShipAmt ,
        i.ShipItem ,
        i.ShipTaxCode ,
        i.DiscountAmt ,
        i.DiscountRate ,
        il.ItemKey AS LineItem ,
        il.QtyShipped AS LineQty ,
        il.ItemDescription AS LineDesc ,
        i.LineServiceDate ,
        il.UnitPrice AS LineUnitPrice ,
        i.LineAmt ,
        i.LineTaxCode ,
        i.LineClass
FROM    vw_InvoiceHeader AS i
        INNER JOIN vw_InvoiceLine AS il ON i.RefNumber = il.DocumentNumber
GO
