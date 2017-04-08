SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_CommissionCheck_QB]
as

SELECT   c.AccountNumber, rp.TxnID, rp.TxnDate, rp.TotalAmount 
FROM    QuickBooks..receivepayment AS rp
    INNER JOIN QuickBooks..customer AS c ON rp.CustomerRef_FullName = c.FullName
--WHERE   rp.TxnDate between '2014-11-01 00:00:00' and '2014-11-30 00:00:00'
union
SELECT   c.AccountNumber, sr.TxnID, sr.TxnDate, sr.SubTotal
FROM    QuickBooks..salesreceipt AS sr
    INNER JOIN QuickBooks..customer AS c ON sr.CustomerRef_FullName = c.FullName
--WHERE   sr.TxnDate between '2014-11-01 00:00:00' and '2014-11-30 00:00:00'
GO
