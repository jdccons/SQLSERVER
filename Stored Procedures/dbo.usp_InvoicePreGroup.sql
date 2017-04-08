SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_InvoicePreGroup]
    (
      @InvoiceDate AS DATETIME ,
      @GroupType AS NVARCHAR(12),
	  @UserName AS NVARCHAR(20)
    )
AS /* =============================================
	Object:			usp_InvoicePreGroup
	Author:			John Criswell
	Version:		4.0
	Create date:	9/8/2014	 
	Description:	Creates bulk invoices for groups;
					inserts records into staging tables;
					transaction numbers are assigned in
					this stage to each invoice - one for
					each group.  Group invoices are first
					inserted into tblInvHdrPreliminary
					and then into tblInvHdr.
					Subscribers for each group
					are inserted into tblInvLin along with
					their dependents				  
					
							
	Change Log:
	--------------------------------------------
	Change Date			Version		Changed by		Reason
	2014-09-22			1.0			JCriswell		Changed approach on generating
													NextTranNos
	2015-01-03			2.0			JCriswell		Added a where clause to subscriber
													section.  Where clause is SubCancelled != 3.
													Changed frmGrpSubscr so that deleted subscribers
													are now marked as cancelled instead of a record
													deletion.
	2015-01-20			3.0			JCriswell		Added where clause to generate new trans nos
													i.e. where CustomerClassKey = 'GROUP'
	2016-07-07			4.0			JCriswell		Added code to convert pending deletions to deleted
	2017-02-07			5.0			JCriswell		Added addl criterion to where clause to populate
													tblInvHdrPreliminary -- i.e. vw_Customer.CustomerClassKey
	
============================================= */

 /*  declarations  */ 
    DECLARE @LastOperation VARCHAR(128) ,
        @ErrorMessage VARCHAR(8000) ,
        @ErrorSeverity INT ,
        @ErrorState INT   
    
    
    DECLARE @TranNo AS INTEGER 
    DECLARE @NextTranNo AS INTEGER             
------------------------------------------------------------------------------
    BEGIN TRY
        BEGIN TRANSACTION

		/*  change the status of all pending deletions to deleted (All American only)  */
		SELECT
		@LastOperation = 'set all the pending deletions to deleted';
		IF EXISTS (
		SELECT
			s.SubSSN, s.SubID, s.SubStatus, s.SubGroupID, s.Sub_LUName, s.SubCancelled,
			s.TransactionType, s.DateCreated, s.DateUpdated, s.DateDeleted,s.UserName,  s.User01,
			s.User02, s.User04, s.User05, s.DateModified
		FROM
			tblSubscr AS s
		INNER JOIN tblGrp AS g ON s.SubGroupID = g.GroupID
		WHERE
			( ISNULL(s.DateDeleted, '1901-01-01 00:00:00') < '2016-09-01 00:00:00' )
			AND ( s.DateDeleted > '1901-01-01 00:00:00'
					OR s.DateDeleted IS NOT NULL)
			AND ( s.SubCancelled <> 3 )
			AND ( g.GroupType = 4 ) 
			AND RTRIM(s.User01) = 'usp_tpa_final_sub'  
		)
		UPDATE
			s
		SET s.SubCancelled = 3, 
			User01 = 'usp_InvoicePreGroup',
			User02 = 'change pending deletion to DELETED', 
			User04 = GETDATE(),
			TransactionType = 'DELETED', 
			UserName = @UserName
			/*  
				DateDeleted is not included in the update
				because it should already be populated with
				a non-null date
			*/
		FROM
		tblSubscr AS s
		INNER JOIN tblGrp AS g ON s.SubGroupID = g.GroupID
		WHERE
			( ISNULL(s.DateDeleted, '1901-01-01 00:00:00') < '2016-09-01 00:00:00' )
			AND ( s.DateDeleted > '1901-01-01 00:00:00'
					OR s.DateDeleted IS NOT NULL)
			AND ( s.SubCancelled <> 3 )
			AND ( g.GroupType = 4 ) 
			AND RTRIM(s.User01) = 'usp_tpa_final_sub';  
		
        SELECT  @LastOperation = 'generate new tran nos - one for each group'
		
        SET @TranNo = ( SELECT dbo.udf_GetNextTranNo() )
		
        IF OBJECT_ID('tempdb..#TranNo') IS NOT NULL 
            DROP TABLE #TranNo
        
        SELECT IDENTITY( INT,1,1 ) AS [ID], @TranNo AS TranNo, 0 AS NextTranNo,
                CustKey
            INTO #TranNo
            FROM ( SELECT CustomerKey AS CustKey
                    FROM vw_Customer
                    WHERE RTRIM(Spare3) = RTRIM(@GroupType)
                        AND CreditHold = 'N'
                        AND CustomerClassKey = 'GROUP'
                 ) g;

        UPDATE a
            SET NextTranNo = ( b.TranNo + b.Id )
            FROM #TranNo a 
            INNER JOIN #TranNo b
                ON a.Id = b.Id; 
                
        SELECT  @LastOperation = 'save NextTranNo';
        
        IF EXISTS ( SELECT 1 FROM #TranNo ) 
            BEGIN
                SELECT  @NextTranNo = MAX(NextTranNo)
                    FROM #TranNo
		        
                UPDATE dbo.ARONE_R9_local
                    SET NextTransaction = @NextTranNo + 1
            END
		
        SELECT  @LastOperation = 'insert customers into tblInvHdrPreliminary from tblGrp ';
		--inserts records into temp table - tblInvHdrPreliminary
        DELETE FROM dbo.tblInvHdrPreliminary;		
        INSERT INTO tblInvHdrPreliminary ( Custkey, Custname, Custaddr1,
                                           Custaddr2, Custcity, Custstate,
                                           Custzip, Tranno, Invdate, Custclass,
                                           Territkey, Salespkey, Spare, Spare2,
                                           Spare3, RecUserID, RecDate, RecTime )
                SELECT c.CustomerKey AS Custkey,
                        ISNULL(c.CustomerName, N'') AS Custname,
                        ISNULL(c.CustomerAddress1, N'') AS Custaddr1,
                        ISNULL(c.CustomerAddress2, N'') AS Custaddr2,
                        ISNULL(c.CustomerCity, N'') AS Custcity,
                        ISNULL(c.CustomerState, N'') AS Custstate,
                        ISNULL(c.CustomerZipCode, N'') AS Custzip,
                        tn.NextTranNo, @InvoiceDate AS InvoiceDte,
                        c.CustomerClassKey AS Custclass,
                        ISNULL(c.TerritoryKey, N'') AS SubGeoId,
                        ga.AGENTid AS AgentID, 
                        '' AS Spare,	-- SubID (not at this level) 
                        '' AS Spare2,	--SubSSN (not at this level)
                        c.Spare3,		--group type
                        'QCD db' AS RecUser,
                        CONVERT(VARCHAR(10), GETDATE(), 101) AS RecDate,
                        LTRIM(RIGHT(CONVERT(VARCHAR(20), GETDATE(), 100), 7))
                        AS RecTime
                    FROM vw_Customer AS c
                    LEFT OUTER JOIN vw_GrpAgt ga
                        ON c.CustomerKey = ga.GroupID 
                    INNER JOIN #TranNo tn
                        ON c.CustomerKey = tn.CustKey
                    WHERE c.CustomerClassKey = 'GROUP'
					AND ga.[Level] = 1;
                
        SELECT  @LastOperation = 'insert data into header staging table ';  
		--inserts records into tblInvHdr from tblInvHdrPreliminary for each subscriber in the group   
		
		DELETE FROM tblInvHdr;   
        
        INSERT INTO tblInvHdr ( [CUST KEY], [CUST NAME], [ADDRESS 1],
                                [ADDRESS 2], CITY, [STATE], [ZIP CODE],
                                ATTENTION, [TRANS NO], [INV DATE], [CHECK NO],
                                [CHECK AMTR], [TERRITORY KEY], [SALESP    KEY],
                                [CUST CLASS], SPARE, SPARE2, SPARE3,
                                [INVOICE NO], RecUserID, RecDate, RecTime,
                                SYSDOCID )
                SELECT Custkey, Custname, Custaddr1, Custaddr2, Custcity,
                        Custstate, Custzip, CustAttn,
                        SUBSTRING(CONVERT(NVARCHAR(10), @InvoiceDate, 101), 10,
                                  1) + CONVERT(NVARCHAR(9), Tranno) AS [Trans No],
                        @InvoiceDate AS Invdate, Checkno, Checkamt, Territkey,
                        Salespkey, Custclass, Spare, Spare2, Spare3,
                        SUBSTRING(CONVERT(NVARCHAR(10), @InvoiceDate, 101), 10,
                                  1) + CONVERT(NVARCHAR(9), Tranno) AS [INVOICE NO],
                        'QCD db' AS RecUser,
                        CONVERT(VARCHAR(10), GETDATE(), 101) AS RecDate,
                        LTRIM(RIGHT(CONVERT(VARCHAR(20), GETDATE(), 100), 7))
                        AS RecTime, Sysdocid
               FROM tblInvHdrPreliminary;
                    
        SELECT  @LastOperation = 'insert subscribers into line item staging table ';     
		--creates records in tblInvLin for each subscriber in the group
        INSERT INTO tblInvLin ( LineItemTy, [DOCUMENT NO], [CUST KEY],
                                [ITEM KEY], [DESCRIPTION], [QTY ORDERED],
                                [QTY SHIPPED], [REV ACCT], [REV SUB],
                                [UNIT PRICE], SPARE, SPARE2, SPARE3 )
                SELECT '1' AS LineItemType,
                        SUBSTRING(CONVERT(NVARCHAR(10), @InvoiceDate, 101), 10,
                                  1) + CONVERT(NVARCHAR(9), ihp.Tranno) AS [DOCUMENT NO],
                        s.SubGroupID AS [CUST KEY], s.SubSSN AS [ITEM KEY],
                        s.SUB_LUname AS [Description], 1 AS QtyOrdered,
                        1 AS QtyShipped, '5100' AS Acct, '2000' AS Dept,
                        r.Rate, 
                        s.SubID AS Spare,        -- SubID 
                        s.SubSSN AS Spare2,      -- SubSSN
                        ihp.Spare3               -- GroupType
                    FROM tblSubscr AS s
                    INNER JOIN tblInvHdrPreliminary AS ihp
                        ON s.SubGroupID = ihp.Custkey 
                    INNER JOIN tblRates AS r
                        ON s.RateID = r.RateID
                    WHERE s.SubCancelled != 3;
                       
        SELECT  @LastOperation = 'insert dependents in line item staging table ';                 
		--creates dependent records in tblInvLin for each group subscriber
        INSERT INTO tblInvLin ( LineItemTy, [DOCUMENT NO], [CUST KEY],
                                [ITEM KEY], [DESCRIPTION], [QTY ORDERED],
                                [QTY SHIPPED], [UNIT PRICE], [REV ACCT],
                                [REV SUB], SPARE, SPARE2, SPARE3 )
                SELECT CONVERT(NVARCHAR(2), CONVERT(INTEGER, RANK() OVER ( PARTITION BY s.spare ORDER BY RTRIM(COALESCE(NULLIF(RTRIM(d.[DepLastName]),
                                                              '') + ', ', '')
                                                              + COALESCE(NULLIF(RTRIM(d.[DepFirstName]),
                                                              '') + ' ', '')
                                                              + COALESCE(d.[DepMiddleName],
                                                              '')) )) + 1) AS LineItemType,
                        s.[DOCUMENT NO], s.[CUST KEY],
                        ISNULL(d.DepSSN, N'') AS [ITEM KEY],
                        RTRIM(COALESCE(NULLIF(RTRIM(d.DepLastName), N'')
                                       + ', ', N'')
                              + COALESCE(NULLIF(RTRIM(d.DepFirstName), N'')
                                         + ' ', N'')
                              + COALESCE(d.DepMiddleName, N'')) AS [DESCRIPTION],
                        1 AS QtyOrdered, 1 AS QtyShipped, 0 AS [UNIT PRICE],
                        '5100' AS Acct, '2000' AS Dept, 
                        s.SPARE,			--SubID
                        s.SPARE2,			--SubSSN
                        s.SPARE3			--GroupType
                    FROM tblInvLin AS s 
						INNER JOIN tblDependent AS d
							ON s.SPARE = d.SubID;
                        
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
		EXEC usp_CallProcedureLog 
		@ObjectID       = @@PROCID,
		@AdditionalInfo = @LastOperation;
		RETURN 0
	END CATCH;



GO
EXEC sp_addextendedproperty N'Purpose', N'Creates bulk invoices for groups.', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_InvoicePreGroup', NULL, NULL
GO
