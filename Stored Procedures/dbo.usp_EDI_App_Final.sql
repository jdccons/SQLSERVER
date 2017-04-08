SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[usp_EDI_App_Final]
    (
      @GroupID AS NVARCHAR(5) ,
      @PlanID AS INTEGER,
	  @UserName AS NVARCHAR(20)
	)
AS /* ======================================================================================
  Object:			usp_EDI_App_Final
  Author:			John Criswell
  Create date:		2015-02-23 
  Description:		Moves data from EDI temp tables
					to permanent tables - tblSubscr,
					tblDependent
  Parameters:		GroupID varchar(5), PlanID integer
  Where Used:		frmImportProcessing (processes 
					flat files from QCD Only customers)
				
  Change Log:
  ---------------------------------------------------------------------------------------
  Change Date		Version			Changed by		Reason
  2015-02-23		1.0				JCriswell		Created	
  2015-03-06		2.0				JCriswell		changed insert into tblSubscr
													to include hardcoded 1 as SubCancelled
  2015-12-01		3.0				JCriswell		Removed several fields
  2016-04-08		4.0				jCriswell		Combined usp_DelEDISubscr with this 
													stored procedure
	
========================================================================================= */
    SET NOCOUNT ON;
/*  ------------------  declarations  --------------------  */ 
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @LastOperation VARCHAR(128) ,
        @ErrorMessage VARCHAR(8000) ,
        @ErrorSeverity INT ,
        @ErrorState INT;

	DECLARE @SUB_ID AS NCHAR(8);
	DECLARE @NextSubID AS NCHAR(8);
/*  ------------------  end of declarations  --------------------  */ 

    BEGIN TRY
        BEGIN TRANSACTION;

		-- this process is a delete all and replace all process
		-- need to delete all the subs first then we will add them in

		-- Assign SubIDs to those who don't have one.

		SELECT @LastOperation = 'create new SubIDs';
		SELECT @SUB_ID = (SELECT LastSubID FROM SubIDControl)
		
        IF OBJECT_ID('tempdb..#SubID') IS NOT NULL 
            DROP TABLE #SubID
        
        SELECT IDENTITY( INT,1,1 ) AS [ID], @SUB_ID AS SubID, 0 AS NextSubID,
                SubSSN
            INTO #SubID
            FROM (             
					SELECT SubSSN
					FROM dbo.tblEDI_App_Subscr
					WHERE ((SubID = '')
						OR (SubID IS NULL))
				) s
            
        UPDATE a
            SET NextSubID = ( b.SubID + b.ID )
            FROM #SubID a 
            INNER JOIN #SubID b
                ON a.ID = b.ID 
        
        -- update the import table with SubIDs        
        SELECT @LastOperation = 'update the import table with SubIDs';
        UPDATE  eas
		SET SubID = CAST(s.NextSubID AS NCHAR(8))
	    FROM tblEDI_App_Subscr  eas
			INNER JOIN #SubID s
				ON eas.SubSSN = s.SubSSN;
			
        -- save the last SubID       
        SELECT @LastOperation = 'save the next SubID';        
        IF EXISTS ( SELECT 1 FROM #SubID ) 
            BEGIN
                SELECT  @NextSubID = MAX(NextSubID)
                    FROM #SubID
		        
                UPDATE SubIDControl
                    SET LastSubID = @NextSubID + 1
            END


        SELECT  @LastOperation = 'delete existing group subscribers';
        IF EXISTS ( SELECT  1
                    FROM    tblSubscr
                    WHERE   ( SubGroupID = @GroupID ) )
            DELETE  FROM tblSubscr
            WHERE   SubGroupID = @GroupID;	
        
		SELECT  @LastOperation = 'delete existing subscribers where the SSNs match';
        IF EXISTS ( SELECT  edi.SubSSN
                    FROM    tblEDI_App_Subscr edi
                            INNER JOIN tblSubscr s ON edi.SubSSN = s.SubSSN )
            DELETE  s
            FROM    tblSubscr s
                    INNER JOIN tblEDI_App_Subscr edi ON s.SubSSN = edi.SubSSN;
	
        SELECT  @LastOperation = 'add records to permanent subscriber table';
        IF EXISTS ( SELECT  1
                    FROM    tblEDI_App_Subscr e
                    WHERE   ( (
				( e.TransactionType ) IS NULL
                              OR ( e.TransactionType ) <> 'T'
				)
                            ) )
         INSERT INTO tblSubscr
                (SubSSN
                ,SubID
                ,PlanID
                ,CoverID
                ,RateID
		 /*  version 2 update */
                ,SubCancelled
                ,PltCustKey
                ,SubFirstName
                ,SubMiddleName
                ,SubLastName
                ,SubStreet1
                ,SubStreet2
                ,SubCity
                ,SubState
                ,SubZip
                ,SubPhoneHome
                ,SubPhoneWork
                ,SubGroupID		
		/*
		  version 3 update
		, SUBemployeeName
		*/
                ,SubDOB
                ,DepCnt
                ,SubStatus
                ,PreexistingDate
                ,SubEffDate
                ,SubClassKey
                ,SubExpDate
                ,SubCardPrt
                ,SubCardPrtDte
                ,SubNotes
                ,SubContBeg
                ,SubContEnd
                ,SubPymtFreq
                ,Sub_LUName
                ,SubGeoID		
		/*
		  version 3 update
		, SUBagentID1
		, SUBagentRATE1
		, SUBagentID2
		, SUBagentRATE2
		, GRExecSalesDirID
		, GRExecSalesDirRate		
		*/
                ,SubMissing
                ,DateCreated
                ,DateUpdated
                ,SubBankDraftNo
                ,SubCOBRA
                ,SubLOA
                ,SubFlyerPrtDte
                ,Flag
                ,SubGender
                ,SubAge
				,UserName
                )
                SELECT  e.SubSSN
                       ,e.SubID
                       ,e.PlanID
                       ,e.CoverID
                       ,e.RateID		
		/*  version 2 updated  */
                       ,1 AS SubCancelled
                       ,e.PltCustKey
                       ,UPPER([SubFirstName]) AS FirstName
                       ,UPPER([SubMiddleName]) AS MI
                       ,UPPER([SubLastName]) AS LastName
                       ,e.SubStreet1
                       ,e.SubStreet2
                       ,e.SubCity
                       ,e.SubState
                       ,e.SubZip
                       ,e.SubPhoneHome
                       ,e.SubPhoneWork
                       ,e.SubGroupID		
		/*
		, e.SUBemployeeName
		*/
                       ,e.SUBdob
                       ,e.DepCnt
                       ,e.SubStatus
                       ,e.PreexistingDate
                       ,e.SubEffDate
                       ,e.SubClassKey
                       ,e.SubExpDate
                       ,e.SubCardPrt
                       ,e.SubCardPrtDte
                       ,e.SubNotes
                       ,e.SubContBeg
                       ,e.SubContEnd
                       ,e.SubPymtFreq
                       ,UPPER([SUB_LUname]) AS LU_Name
                       ,e.SubGeoID		
		/*
		, e.SUBagentID1
		, e.SUBagentRATE1
		, e.SUBagentID2
		, e.SUBagentRATE2
		, e.GRExecSalesDirID
		, e.GRExecSalesDirRate
		*/
                       ,e.SUBmissing
                       ,e.DateCreated
                       ,e.DateUpdated
                       ,e.SUBbankDraftNo
                       ,e.SUBCOBRA
                       ,e.SUBLOA
                       ,e.SUBflyerPRTdte
                       ,e.Flag
                       ,CASE e.SubGender
                          WHEN '' THEN 'O'
                          WHEN NULL THEN 'O'
                          ELSE e.SubGender
                        END gender
                       ,e.SubAge
					   ,@UserName
                FROM    tblEDI_App_Subscr e
                WHERE   ( (
				( e.TransactionType ) IS NULL
                          OR ( e.TransactionType ) <> 'T'
				)
                        );
        SELECT  @LastOperation = 'add records to permanent dependent table';
        INSERT  INTO tblDependent
                (DepSSN
                ,DepSubID
                ,DepFirstName
                ,DepMiddleName
                ,DepLastName
                ,DepDOB
                ,DepAge
                ,DepGender
                ,DepRelationship
                ,DepEffDate
                ,PreexistingDate
				,UserName
                )
                SELECT  de.DepSSN
                       ,de.DepSubID
                       ,UPPER(de.DepFirstName) AS FirstName
                       ,UPPER(de.DepMiddleName) AS MI
                       ,UPPER(de.DepLastName) AS LastName
                       ,de.DepDOB
                       ,de.DepAge
                       ,CASE DepGender
                          WHEN '' THEN 'O'
                          WHEN NULL THEN 'O'
                          ELSE de.DepGender
                        END AS Gender
                       ,de.DepRelationship
                       ,de.DepEffDate
                       ,de.PreexistingDate
					   ,@UserName					   
                FROM    tblEDI_App_Subscr AS se
                        RIGHT OUTER JOIN tblEDI_App_Dep AS de ON se.SubSSN = de.DepSubID;
			--where   ( se.TransactionType = 'T' )
        COMMIT TRANSACTION;
        RETURN 1;
    END TRY

    BEGIN CATCH 
        IF @@TRANCOUNT > 0
            ROLLBACK;

        SELECT  @ErrorMessage = ERROR_MESSAGE() + ' Last Operation: '
                + @LastOperation, @ErrorSeverity = ERROR_SEVERITY(),
                @ErrorState = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
        EXEC usp_CallProcedureLog @ObjectID = @@PROCID,
            @AdditionalInfo = @LastOperation;
        RETURN 0;
    END CATCH;




GO
EXEC sp_addextendedproperty N'Purpose', N'Performs a complete delete and replace for QCD Only group members.', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_EDI_App_Final', NULL, NULL
GO
