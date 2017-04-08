SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[usp_InvoicePostIndivOne]
	(
      @InvoiceDate AS DATETIME,
      @UserName AS nvarchar(20)
    )
AS 
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    
/* =============================================
	Object:			usp_InvoicePostIndivOne
	Version:		1.0
	Author:			John Criswell
	Create date:	2016-01-16 
	Description:	Posts all the one offs
					
							
	Change Log:
	--------------------------------------------
	Change Date	Version		Changed by		Reason
	2016-01-16	1.0			J Criswell		Created
============================================= */ 

 /*  declarations  */ 
    DECLARE @LastOperation VARCHAR(128) ,
        @ErrorMessage VARCHAR(8000) ,
        @ErrorSeverity INT ,
        @ErrorState INT   
    DECLARE @SysDocID AS INTEGER,
			@TranNo AS INTEGER         
------------------------------------------------------------------------------
    BEGIN TRY
        BEGIN TRANSACTION
		IF EXISTS(SELECT 1
					FROM tblInvHdr
					WHERE [CUST CLASS] = 'INDIV'
						AND [INV DATE] BETWEEN dbo.udf_GetFirstDayOfMonth(@InvoiceDate)
							AND dbo.udf_GetLastDayOfMonth(@InvoiceDate))
		BEGIN
			/*  create SysDocIDs  */
			SELECT @LastOperation = 'create SysDocIDs';
			SET @SysDocID = ( SELECT dbo.udf_GetNextSysDocId())  -- get the last SysDocID
			IF OBJECT_ID('tempdb..#SysDoc') IS NOT NULL
				DROP TABLE #SysDoc;
			/*  create temp table with SysDocIDs  */
			SELECT IDENTITY(INT, 1, 1) AS [ID]
				, @SysDocID SysDocID
				, 0 AS NextSysDocID
				, ih.[CUST KEY]
				, ih.[INVOICE NO]
			INTO #SysDoc
			FROM (					
					SELECT [CUST KEY], [INVOICE NO]
					FROM tblInvHdr
					WHERE [INV DATE] BETWEEN dbo.udf_GetFirstDayOfMonth(@InvoiceDate) AND dbo.udf_GetLastDayOfMonth(@InvoiceDate)						
						AND [CUST CLASS] = 'INDIV'										
				) ih;
			/*  update NextSysDocID field in temp table  */
			UPDATE a
			SET NextSysDocID = (b.SysDocId + b.Id)
			FROM #SysDoc a
			INNER JOIN #SysDoc b
				ON a.ID = b.ID;
			/*  save SysDocID  */
			IF EXISTS (
					SELECT 1
					FROM #SysDoc
					)
			BEGIN
				SELECT @SysDocID = (
						SELECT MAX(NextSysDocID)
						FROM #SysDoc
						)
				UPDATE dbo.ARNEXTSY_local
				SET NextSysDocID = @SysDocID;
			END;
		    /*  ---  create invoices  ---   */
			SELECT  @LastOperation = 'insert invoice headers into transaction table '
			INSERT INTO ARTRANH_local (
				CustomerKey
				, DocumentNumber
				, ApplyTo
				, Spare
				, Spare2
				, Spare3
				, TerritoryKey
				, SalespersonKey
				, CustomerClassKey
				, OrderNumber
				, ShipToKey
				, CheckBatch
				, TransactionType
				, DocumentDate
				, AgeDate
				, DocumentAmt
				, SysDocID
				, ApplySysDocID
				, RecUserID
				, RecDate
				, RecTime
				, IFStatus
				)

			SELECT ih.[CUST KEY]
				, ih.[TRANS NO]
				, ih.[TRANS NO]
				, ih.SPARE
				, ih.SPARE2
				, ih.SPARE3
				, ih.[TERRITORY KEY]
				, ih.[SALESP    KEY]
				, ih.[CUST CLASS]
				, '' AS OrderNumber
				, '' AS ShipToKey
				, '' AS CheckBatch
				, 'I' AS TransactionType
				, ih.[INV DATE]
				, ih.[INV DATE] AS [AGE DATE]
				, il.INVOICETOTAL AS INVOICETOTAL
				, sd.NextSysDocID AS SysDocID
				, sd.NextSysDocID AS ApplySysDocID
				, @UserName AS RecUser
				, CONVERT(VARCHAR(10), GETDATE(), 101) AS RecDate
				, LTRIM(RIGHT(CONVERT(VARCHAR(20), GETDATE(), 100), 7)) AS RecTime
				, 'U' AS IFStatus
			FROM tblInvHdr ih
			INNER JOIN (
				SELECT [DOCUMENT NO]
					, ISNULL(SUM([UNIT PRICE] * [QTY SHIPPED]), 0) AS INVOICETOTAL
				FROM tblInvLin
				GROUP BY [DOCUMENT NO]
				) il
				ON ih.[TRANS NO] = il.[DOCUMENT NO]
			INNER JOIN #SysDoc sd
				ON ih.[CUST KEY] = sd.[CUST KEY]
					AND ih.[INVOICE NO] = sd.[INVOICE NO]
			WHERE ih.[CUST CLASS] = 'INDIV'
				AND ih.[INV DATE] BETWEEN dbo.udf_GetFirstDayOfMonth(
							@InvoiceDate)
					AND dbo.udf_GetLastDayOfMonth(@InvoiceDate);

	        
	        /*  ---  create detail  ---   */
	        SELECT  @LastOperation = 'insert invoice line item detail into transaction table'
			INSERT INTO ARLINH_local (
				CustomerKey
				, DocumentNumber
				, LocationKey
				, CustomerClassKey
				, ItemKey
				, ItemDescription
				, UnitPrice
				, QtyOrdered
				, QtyShipped
				, TaxKey
				, RevenueAcctKey
				, CostAmt
				, RequestDate
				, ShipDate
				, DocumentDate
				, SysDocID
				, LineItemType
				, SPARE
				, SPARE2
				, SPARE3
				, RecUserID
				, RecDate
				, RecTime
				)

			SELECT ih.[CUST KEY]
				, ih.[TRANS NO]
				, ih.[LOCATION  KEY]
				, ih.[CUST CLASS]
				, il.[ITEM KEY]
				, il.[DESCRIPTION]
				, il.[UNIT PRICE]
				, il.[QTY ORDERED]
				, il.[QTY SHIPPED]
				, il.[TAX CODE]
				, il.[REV ACCT]
				, il.[UNIT PRICE] AS [COST AMT]
				, ih.[INV DATE] AS [REQUEST DATE]
				, ih.[INV DATE] AS [SHIP DATE]
				, ih.[INV DATE] AS [DOCUMENT DATE]
				, ih.SYSDOCID
				, il.LineItemTy
					, ih.Spare
					, ih.Spare2
					, ih.Spare3
				, @UserName AS RecUser
				, CONVERT(VARCHAR(10), GETDATE(), 101) AS RecDate
				, LTRIM(RIGHT(CONVERT(VARCHAR(20), GETDATE(), 100), 7)) AS RecTime
			FROM tblInvHdr AS ih
			LEFT OUTER JOIN tblInvLin AS il
				ON ih.[TRANS NO] = il.[DOCUMENT NO]
			WHERE ih.[CUST CLASS] = 'INDIV'
				AND ih.[INV DATE] BETWEEN dbo.udf_GetFirstDayOfMonth(
							@InvoiceDate)
					AND dbo.udf_GetLastDayOfMonth(@InvoiceDate);

				
			/*  create SysDocIDs  */
			SELECT @LastOperation = 'create SysDocIds for sales receipt transactions.';
			SELECT @SysDocID = MAX(SysDocId)
			FROM ARTRANH_local
				WHERE DocumentDate BETWEEN dbo.udf_GetFirstDayOfMonth(@InvoiceDate) AND dbo.udf_GetLastDayOfMonth(@InvoiceDate);
			IF OBJECT_ID('tempdb..#SysDoc2') IS NOT NULL
				DROP TABLE #SysDoc2;
			/* create temp table for SysDocIDs for sales receipt  */
			SELECT IDENTITY(INT, 1, 1) AS [ID]  --  create SysDocID table
				, @SysDocID SysDocID
				, 0 AS NextSysDocID
				, art.DocumentNumber
				, art.CustomerKey
			INTO #SysDoc2
			FROM (					
					SELECT CustomerKey, DocumentNumber
					FROM dbo.ARTRANH_local
					WHERE DocumentDate BETWEEN dbo.udf_GetFirstDayOfMonth(@InvoiceDate) AND dbo.udf_GetLastDayOfMonth(@InvoiceDate)
						AND TransactionType = 'I'
						AND CustomerClassKey = 'INDIV'
						AND IFStatus = 'U'					
				) art;
			/*  populate SysDocIDs for each record in temp table  */
			UPDATE a
			SET NextSysDocID = (b.SysDocId + b.Id)
			FROM #SysDoc2 a
			INNER JOIN #SysDoc2 b
				ON a.ID = b.ID;				
			/*  save last SysDocID  */
			SELECT @SysDocID = (SELECT MAX(NextSysDocID) FROM #SysDoc2)
			UPDATE  dbo.ARNEXTSY_local
			SET NextSysDocID = @SysDocID
				
			/*  create DocumentNumbers */
			SELECT @LastOperation = 'create DocumentNumbers';
			IF OBJECT_ID('tempdb..#TranNo') IS NOT NULL
				DROP TABLE #TranNo;
			SELECT @TranNo = NextTransaction
			FROM dbo.ARONE_R9_local;
			/*  create DocumentNumber table  */
			SELECT IDENTITY(INT, 1, 1) AS [ID]
				, @TranNo TranNo
				, 0 AS NextTranNo
				, art.CustomerKey
				, art.DocumentNumber
			INTO #TranNo
			FROM (
				SELECT CustomerKey, DocumentNumber
				FROM dbo.ARTRANH_local
				WHERE DocumentDate BETWEEN dbo.udf_GetFirstDayOfMonth(@InvoiceDate) AND dbo.udf_GetLastDayOfMonth(@InvoiceDate)
					AND TransactionType = 'I'
					AND CustomerClassKey = 'INDIV'
					AND IFStatus = 'U'
				) art;
			UPDATE a
			SET NextTranNo = (b.TranNo + b.ID)
			FROM #TranNo a
			INNER JOIN #TranNo b
				ON a.ID = b.ID;				
			/*  save SysDocID  */
			IF EXISTS (
					SELECT 1
					FROM #SysDoc
					)
			BEGIN
				SELECT @SysDocID = (
						SELECT MAX(NextSysDocID)
						FROM #SysDoc
						)
				UPDATE dbo.ARNEXTSY_local
				SET NextSysDocID = @SysDocID;
			END;
						
	        /*  ---  create sales receipts ---  */        
			SELECT @LastOperation = 'create sales receipt transactions for multiple individuals';
			INSERT INTO ARTRANH_local (
				DocumentNumber
				, ApplyTo
				, TerritoryKey
				, SalespersonKey
				, CustomerKey
				, CustomerClassKey
				, OrderNumber
				, ShipToKey
				, CheckBatch
				, TransactionType
				, DocumentDate
				, AgeDate
				, DaysTillDue
				, DocumentAmt
				, DiscountAmt
				, FreightAmt
				, TaxAmt
				, CostAmt
				, CommissionHomeOvride
				, RetentionInvoice
				, SysDocID
				, ApplySysDocID
				, Spare
				, Spare2
				, Spare3
				, RecUserID
				, RecDate
				, RecTime
				, IFStatus
				)

			SELECT SUBSTRING(CONVERT(NVARCHAR(10), @InvoiceDate, 101), 10, 1) + CONVERT(NVARCHAR(9), tn.NextTranNo) AS DocumentNumber
				, art.DocumentNumber AS ApplyTo
				, art.TerritoryKey
				, art.SalespersonKey
				, art.CustomerKey
				, art.CustomerClassKey
				, art.OrderNumber
				, art.ShipToKey
				, '' CheckBatch
				, 'P' AS TransactionType
				, art.DocumentDate
				, art.DocumentDate AS AgeDate
				, art.DaysTillDue
				, art.DocumentAmt * - 1
				, art.DiscountAmt
				, art.FreightAmt
				, art.TaxAmt
				, art.CostAmt
				, art.CommissionHomeOvride
				, art.RetentionInvoice
				, sd.NextSysDocID AS SysDocId
				, art.SysDocId AS ApplySysDocID
				, art.Spare
				, art.Spare2
				, art.Spare3
				, @UserName AS RecUser
				, CONVERT(VARCHAR(10), GETDATE(), 101) AS RecDate
				, LTRIM(RIGHT(CONVERT(VARCHAR(20), GETDATE(), 100), 7)) AS RecTime
				, art.IFStatus
			FROM dbo.ARTRANH_local art
			INNER JOIN #SysDoc2 sd
				ON art.CustomerKey = sd.CustomerKey
					AND art.DocumentNumber = sd.DocumentNumber
			INNER JOIN #TranNo tn
				ON art.CustomerKey = tn.CustomerKey
					AND art.DocumentNumber = tn.DocumentNumber
			WHERE art.CustomerClassKey = 'INDIV'
				AND art.DocumentDate BETWEEN dbo.udf_GetFirstDayOfMonth(@InvoiceDate) AND dbo.udf_GetLastDayOfMonth(@InvoiceDate)
				AND art.TransactionType = 'I'
				AND art.IFStatus = 'U';
	
	    END    
		COMMIT TRANSACTION
		RETURN 1
    END TRY

    BEGIN CATCH 
        IF @@TRANCOUNT > 0 
            ROLLBACK

        SELECT  @ErrorMessage = ERROR_MESSAGE() + ' Last Operation: '
                + @LastOperation ,
                @ErrorSeverity = ERROR_SEVERITY() ,
                @ErrorState = ERROR_STATE()
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
        RETURN 0
    END CATCH
GO
EXEC sp_addextendedproperty N'Purpose', N'One off individuals post to ARTRANH_local as sales receipts.', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_InvoicePostIndivOne', NULL, NULL
GO
