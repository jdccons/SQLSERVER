SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/* =============================================
	Object:			usp_ReconPayment
	Author:			John Criswell
	Version:		1
	Create date:	10/01/2014	 
	Description:	Reconciles payments between
					QuickBooks and Platinum 
					
							
	Change Log:
	--------------------------------------------
	Change Date		Changed by		Reason
	2014-10-15		JCriswell		Created
									
									
	
============================================= */
CREATE PROCEDURE [dbo].[usp_ReconPayment] @InvoiceDate DATETIME

--exec usp_ReconPayment '2014-10-01 00:00:00'

AS

declare @FirstDayOfMonth datetime
declare @LastDayOfMonth datetime
SET @FirstDayOfMonth = ( SELECT dbo.udf_GetFirstDayOfMonth(@InvoiceDate))
SET @LastDayOfMonth = ( SELECT  dbo.udf_GetLastDayOfMonth(@InvoiceDate))

SET NOCOUNT ON;

SELECT  ISNULL(qb.App , '') App,
        ISNULL(qb.TxnID, '') TxnID ,
        ISNULL(qb.TxnNumber, '')  TxnNumber ,
        ISNULL(qb.CustomerRef_FullName, '') CustomerRef_FullName ,
        ISNULL(qb.ARAccountRef_FullName, '') ARAccountRef_FullName ,
        ISNULL(qb.TxnDate, '') TxnDate ,
        ISNULL(qb.RefNumber, '') RefNumber ,
        ISNULL(qb.TotalAmount,0) TotalAmount ,
        ISNULL(qb.FullName, '') FullName ,
        ISNULL(qb.AccountNumber, '') AccountNumber ,
        ISNULL(pfw.App, '') App ,
        ISNULL(pfw.DocumentNumber, '') DocumentNumber ,
        ISNULL(pfw.DocumentDate, '') DocumentDate,
        ISNULL(pfw.ApplyTo, '') ApplyTo ,
        ISNULL(pfw.CustomerKey, '') CustomerKey ,
        ISNULL(pfw.CustomerClassKey, '') CustomerClassKey ,
        ISNULL(pfw.OrderNumber, '') OrderNumber ,
        ISNULL(pfw.TransactionType, '') TransactionType ,
        ISNULL(pfw.DocumentAmt,0) DocumentAmt ,
        ISNULL(CAST(qb.TotalAmount AS DECIMAL(18,2)),0) - ISNULL(CAST(pfw.DocumentAmt AS DECIMAL(18,2)),0) [Difference]
FROM
/*  QuickBooks  */
(
			SELECT    'QuickBooks' [App] ,
                    rp.TxnID ,
                    rp.TxnNumber ,
                    rp.CustomerRef_FullName ,
                    rp.ARAccountRef_FullName ,
                    rp.TxnDate ,
                    ISNULL(rp.RefNumber, '999999') RefNumber ,
                    CAST(rp.TotalAmount AS DECIMAL(18,2)) TotalAmount ,
                    c.FullName ,
                    c.AccountNumber
			FROM    QuickBooks..receivepayment AS rp
                INNER JOIN QuickBooks..customer AS c ON rp.CustomerRef_FullName = c.FullName
			WHERE   rp.TxnDate BETWEEN @FirstDayOfMonth AND @LastDayOfMonth
) qb
                    
LEFT OUTER JOIN

/* Platinum */                    
(
		   SELECT    'PfW' [App] ,
                    ISNULL(art.DocumentNumber, '999999') DocumentNumber ,
                    ISNULL(art.ApplyTo, '') ApplyTo ,
                    art.DocumentDate,
                    art.CustomerKey ,
                    art.CustomerClassKey ,
                    ISNULL(art.OrderNumber, '') OrderNumber ,
                    art.TransactionType ,
                    CAST((art.DocumentAmt * -1) AS DECIMAL(18,2)) DocumentAmt, 
                    Spare3
          FROM      ARTRANH_local art
          WHERE     art.DocumentDate BETWEEN @FirstDayOfMonth AND @LastDayOfMonth
          AND		art.TransactionType = 'P'
          AND		art.CustomerClassKey = 'GROUP'
                    
) pfw 
        ON qb.AccountNumber = pfw.CustomerKey
        AND qb.RefNumber = pfw.DocumentNumber
        AND qb.TxnDate = pfw.DocumentDate
        AND qb.TotalAmount = pfw.DocumentAmt
        ORDER BY ARAccountRef_FullName, CustomerRef_FullName


GO
