SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[usp_Synch_TxnID]
    (
      @InvoiceDate DATETIME                                                                                   
    )
AS 

/* ================================================================================================
	Object:			usp_Sync_TxnID
	Version:		7
	Author:			John Criswell
	Create date:	2014-09-21	 
	Description:	Synchronizes the QuickBooks TxnID
					on receivepayments table
					and the salesreceipts table with
					DocumentNumber, CustomerKey and DocumentDate
					on ARTRANH_local;
					
								
							
	Change Log:
	--------------------------------------------
	Change Date		Version			Changed by		Reason
	2014-10-28		3.0				JCriswell		Changed the logic of the update
													to include IFStatus on ARTRANH_local
	2015-12-03		4.0				JCriswell		Changed QuickBooks select to include sales
													receipts from individuals
	2015-12-08		5.0				JCriswell		Changed the where clause on Access payments
													so that it pull non-interfaced and pending
													interface transactions.
	2016-05-28		6.0				JCriswell		Completely rewrote the logic to improve performance
	2016-06-27		7.0				JCriswell		Corrected serious bug; need to update OrderNumber
													with TxnID; not RefNumber.
=================================================================================================== */

	/*  declarations  */
	DECLARE @LastOperation VARCHAR(128) ,
        @ErrorMessage VARCHAR(8000) ,
        @ErrorSeverity INT ,
        @ErrorState INT   
    DECLARE @FirstDayOfMonth DATETIME ,
        @LastDayOfMonth DATETIME
        
        ------------------------------------------------------------------------------
BEGIN TRY
    BEGIN TRANSACTION	
    
    SET @FirstDayOfMonth = ( SELECT dbo.udf_GetFirstDayOfMonth(@InvoiceDate))
    SET @LastDayOfMonth = ( SELECT  dbo.udf_GetLastDayOfMonth(@InvoiceDate))
    
    SELECT  @LastOperation = 'update ARTRANH_local with TxnIds '
        
	UPDATE  plt
	SET     plt.OrderNumber = qb.TxnID,
	plt.User01 = 'usp_Synch_TxnID',
	plt.IFStatus = 'I'
	FROM    
	( SELECT    DocumentNumber ,
                    CustomerKey ,
                    DocumentDate ,
                    DocumentAmt * -1 AS DocumentAmt ,
                    OrderNumber ,
					User01,
                    IFStatus
          FROM      ARTRANH_local
          WHERE     ( TransactionType = 'P' )
                    AND ( DocumentDate >= '2014-01-01 00:00:00' )
                    AND (DocumentDate BETWEEN @FirstDayOfMonth AND @LastDayOfMonth)
        ) AS plt
    INNER JOIN 
		( /*  group receipts  */
			SELECT CASE WHEN rp.RefNumber = '' THEN '999999' WHEN rp.RefNumber IS 
				NULL THEN '999999' ELSE RTRIM(rp.RefNumber) END 
				RefNumber, 
				RTRIM(cqb.AccountNumber) AccountNumber, rp.
				TxnDate, rp.TotalAmount, rp.TxnID
			FROM QuickBooks.dbo.receivepayment AS rp
			LEFT OUTER JOIN QuickBooks.dbo.customer cqb
				ON rp.CustomerRef_FullName = cqb.FullName
			WHERE rp.TxnDate BETWEEN @FirstDayOfMonth
					AND @LastDayOfMonth
			UNION
		/*  individual sales receipts  */
			SELECT  
					/*  with reference to sales receipts, must match the check number to the document number  */
					CASE WHEN sr.CheckNumber = '' THEN '999999'
							WHEN sr.CheckNumber IS NULL THEN '999999'
							ELSE RTRIM(sr.CheckNumber)
					END AS RefNumber ,
					RTRIM(cqb.AccountNumber) AccountNumber ,
					sr.TxnDate ,
					sr.TotalAmount ,
					sr.TxnID
			FROM    QuickBooks.dbo.salesreceipt sr
			LEFT OUTER JOIN QuickBooks.dbo.customer cqb 
				ON sr.CustomerRef_FullName = cqb.FullName
			WHERE sr.TxnDate BETWEEN @FirstDayOfMonth
						AND @LastDayOfMonth 
					   ) AS qb 
	ON plt.DocumentNumber = qb.RefNumber
	AND plt.CustomerKey = qb.AccountNumber
	AND plt.DocumentAmt = qb.TotalAmount;
            
	COMMIT TRANSACTION
END TRY

BEGIN CATCH 
    IF @@TRANCOUNT > 0 
        ROLLBACK

    SELECT  @ErrorMessage = ERROR_MESSAGE() + ' Last Operation: '
            + @LastOperation ,
            @ErrorSeverity = ERROR_SEVERITY() ,
            @ErrorState = ERROR_STATE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
END CATCH



GO
