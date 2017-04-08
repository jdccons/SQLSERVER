SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[usp_Refresh_Temp]
AS
/* ============================================================
	Object:			usp_Refresh_Temp
	Author:			John Criswell
	Create date:	2015-10-13	 
	Description:	Copies data from prod to temp		
							
	Change Log:
	-----------------------------------------------------------
	Change Date		Versions	Changed by		Reason
	2015-10-13		1.0			J Criswell		Created.
	2015-10-14		2.0			J Criswell		Added group table.
	2015-10-15		3.0			J Criswell		Added rates table.
	2015-10-18		4.0			J Criswell		Added assign EIMBRID
	2015-10-23		5.0			J Criswell		Error handling code
	2015-11-10		6.0			J Criswell		Added an insert for group agents
	2016-07-23		7.0			J Criswell		Added drop/create FK for group agents
	2016-07-24		8.0			J Criswell		Added an insert for agents
	2016-08-21		9.0			J Criswell		Added section of refresh ARTRANH_local
	2017-03-19		10.0		J Criswell		Added step for individual agents
	
=============================================================== */
/*  declarations  */
DECLARE @LastOperation VARCHAR(128), @ErrorMessage VARCHAR(8000), 
	@ErrorSeverity INT, @ErrorState INT

BEGIN TRY
	BEGIN TRANSACTION
	
	/*  drop foreign keys  */
	SELECT @LastOperation = 'drop foreign keys'
	PRINT @LastOperation	
	
	SELECT @LastOperation = 'drop FK_tblSubscr_tblGrp'
	IF EXISTS (
			SELECT *
			FROM sys.foreign_keys
			WHERE object_id = OBJECT_ID(
					N'[dbo].[FK_tblSubscr_tblGrp]')
				AND parent_object_id = OBJECT_ID(
					N'[dbo].[tblSubscr]')
			)
	ALTER TABLE [dbo].[tblSubscr]
	DROP CONSTRAINT [FK_tblSubscr_tblGrp]
	PRINT @LastOperation
	
	-- FK_tblSubscr_tblRates
	SELECT @LastOperation = 'drop FK_tblSubscr_tblRates'
	IF EXISTS (
			SELECT *
			FROM sys.foreign_keys
			WHERE object_id = OBJECT_ID(
					N'[dbo].[FK_tblSubscr_tblRates]')
				AND parent_object_id = OBJECT_ID(
					N'[dbo].[tblSubscr]')
			)
		ALTER TABLE [dbo].[tblSubscr]
	DROP CONSTRAINT [FK_tblSubscr_tblRates]
	PRINT @LastOperation
	
	-- FK_tblSubscr_tblRates_GrpID_PlanID_CoverID]
	SELECT @LastOperation = 'drop FK_tblSubscr_tblRates_GrpID_PlanID_CoverID'
	IF EXISTS (
			SELECT *
			FROM sys.foreign_keys
			WHERE object_id = OBJECT_ID(
					N'[dbo].[FK_tblSubscr_tblRates_GrpID_PlanID_CoverID]'
				)
				AND parent_object_id = OBJECT_ID(N'[dbo].[tblSubscr]')
			)
		ALTER TABLE [dbo].[tblSubscr]
	DROP CONSTRAINT [FK_tblSubscr_tblRates_GrpID_PlanID_CoverID]
	PRINT @LastOperation

	-- FK_tblDependent_tblSubscr
	SELECT @LastOperation = 'drop FK_tblDependent_tblSubscr'
	IF EXISTS (
			SELECT *
			FROM sys.foreign_keys
			WHERE object_id = OBJECT_ID(
					N'[dbo].[FK_tblDependent_tblSubscr]')
				AND parent_object_id = OBJECT_ID(
					N'[dbo].[tblDependent]')
			)
	ALTER TABLE [dbo].[tblDependent]
	DROP CONSTRAINT [FK_tblDependent_tblSubscr]
	PRINT @LastOperation
	
	-- FK_tblRates_tblCoverage
	SELECT @LastOperation = 'drop FK_tblRates_tblCoverage'
	IF EXISTS (
			SELECT *
			FROM sys.foreign_keys
			WHERE object_id = OBJECT_ID(
					N'[dbo].[FK_tblRates_tblCoverage]')
				AND parent_object_id = OBJECT_ID(N'[dbo].[tblRates]')
			)
	ALTER TABLE [dbo].[tblRates]
	DROP CONSTRAINT [FK_tblRates_tblCoverage]
	PRINT @LastOperation
	
	-- FK_tblRates_tblPlans
	SELECT @LastOperation = 'drop FK_tblRates_tblPlans'
	IF EXISTS (
			SELECT *
			FROM sys.foreign_keys
			WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblRates_tblPlans]')
				AND parent_object_id = OBJECT_ID(N'[dbo].[tblRates]')
			)
	ALTER TABLE [dbo].[tblRates]
	DROP CONSTRAINT [FK_tblRates_tblPlans]
	PRINT @LastOperation


	--FK_tblGrpAgt_tblAgent
	SELECT @LastOperation = 'drop FK_tblGrpAgt_tblAgent'
	IF EXISTS (
			SELECT *
			FROM sys.foreign_keys
			WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblGrpAgt_tblAgent]')
				AND parent_object_id = OBJECT_ID(N'[dbo].[tblGrpAgt]')
			)
	ALTER TABLE [dbo].[tblGrpAgt] 
	DROP CONSTRAINT [FK_tblGrpAgt_tblAgent]
	PRINT @LastOperation


	/*  end of drop foreign keys  */
	SELECT @LastOperation = 'end of drop foreign keys'
	PRINT @LastOperation
	
	SELECT @LastOperation = 'dropped FK_tblGrpAgt_tblAgent'


	/*  drop trigger */
		IF EXISTS (
			SELECT *
			FROM sys.triggers
			WHERE object_id = OBJECT_ID(N'[dbo].[trg_ARTRANH_local_DateModified]'))
		DROP TRIGGER [dbo].[trg_ARTRANH_local_DateModified];
		PRINT @LastOperation


	-- groups
	SELECT @LastOperation = 'deleted all records from tblGrp'
	DELETE
	FROM tblGrp;
	PRINT @LastOperation

	SELECT @LastOperation = 'transfer groups to temp'
	SET IDENTITY_INSERT tblGrp ON;
	INSERT INTO tblGrp (
		ID, GroupID, GRName, GRGeoID, GRStreet1, GRStreet2, GRCity, GRState
		, GRZip, GRPhone1, GRPhone2, GRFax, GRMainCont, GRSrvCont, 
		GRMarkDir, GRContBeg, GRContEnd, GRClassKey, [GRAgent%], 
		GRNotes, GRClientSvcRepID, GREE, GRAnnvDate, GRFirstInvAmt, 
		GRSubLabelsPrinted, DateCreated, DateUpdated, GRCancelled, 
		GRAcctMgr, GRCardStock, GRMailCard, GRInvSort, GREmail, 
		GRMainContTitle, GRSrvConTitle, GRInitialSubscr, GRHold, 
		GRCancelledDate, GRReinstatedDate, Ins, GroupType, 
		InvoiceType, OrthoCoverage, OrthoLifeTimeLimit, 
		WaitingPeriod, RecUserID, RecDate, RecTime, User01, User02, 
		User03, User04, User05, User06, User07, User08, User09, 
		DateModified
		)
	SELECT ID, GroupID, GRName, GRGeoID, GRStreet1, GRStreet2, GRCity, 
		GRState, GRZip, GRPhone1, GRPhone2, GRFax, GRMainCont, 
		GRSrvCont, GRMarkDir, GRContBeg, GRContEnd, GRClassKey, 
		[GRAgent%], GRNotes, GRClientSvcRepID, GREE, GRAnnvDate, 
		GRFirstInvAmt, GRSubLabelsPrinted, DateCreated, DateUpdated, 
		GRCancelled, GRAcctMgr, GRCardStock, GRMailCard, GRInvSort, 
		GREmail, GRMainContTitle, GRSrvConTitle, GRInitialSubscr, 
		GRHold, GRCancelledDate, GRReinstatedDate, Ins, GroupType, 
		InvoiceType, OrthoCoverage, OrthoLifeTimeLimit, 
		WaitingPeriod, RecUserID, RecDate, RecTime, User01, User02, 
		User03, User04, User05, User06, User07, User08, User09, 
		DateModified
	FROM QCDdataSQL2005..tblGrp AS tblGrp_1;
	SET IDENTITY_INSERT tblGrp OFF;
	PRINT @LastOperation

	-- subscribers
	SELECT @LastOperation = 'deleted all records from tblSubscr'
	DELETE
	FROM tblSubscr;
	PRINT @LastOperation

	SELECT @LastOperation = 'transferred subscribers to temp'
	SET IDENTITY_INSERT tblSubscr ON;
	INSERT INTO tblSubscr (
		ID, SubSSN, SubID, EIMBRID, SubStatus, SubGroupID, PltCustKey, 
		PlanID, CoverID, RateID, SubCancelled, Sub_LUName, SubLastName
		, SubFirstName, SubMiddleName, SubStreet1, SubStreet2, SubCity
		, SubState, SubZip, SubPhoneWork, SubPhoneHome, SubEmail, 
		SubDOB, DepCnt, SubGender, SubAge, SubMaritalStatus, 
		SubEffDate, SubExpDate, PreexistingDate, SubCardPrt, 
		SubCardPrtDte, SubNotes, TransactionType, SubContBeg, 
		SubContEnd, SubPymtFreq, SubGeoID, SubBankDraftNo, Flag, 
		UserName, DateCreated, DateUpdated, DateDeleted, 
		SubFlyerPrtDte, SubRate, SubCOBRA, SubLOA, SubMissing, 
		CreateDate, AmtPaid, wSubID, User01, User02, User03
		, User04, User05, User06, User07, User08, User09, Email
		)
	SELECT ID, SubSSN, SubID, EIMBRID, SubStatus, SubGroupID, PltCustKey, 
		PlanID, CoverID, RateID, SubCancelled, Sub_LUName, SubLastName
		, SubFirstName, SubMiddleName, SubStreet1, SubStreet2, SubCity
		, SubState, SubZip, SubPhoneWork, SubPhoneHome, SubEmail, 
		SubDOB, DepCnt, SubGender, SubAge, SubMaritalStatus, 
		SubEffDate, SubExpDate, PreexistingDate, SubCardPrt, 
		SubCardPrtDte, SubNotes, TransactionType, SubContBeg, 
		SubContEnd, SubPymtFreq, SubGeoID, SubBankDraftNo, Flag, 
		UserName, DateCreated, DateUpdated, DateDeleted, 
		SubFlyerPrtDte, SubRate, SubCOBRA, SubLOA, SubMissing, 
		CreateDate, AmtPaid, wSubID, User01, User02, User03
		, User04, User05, User06, User07, User08, User09, Email
	FROM QCDdataSQL2005..tblSubscr AS tblSubscr_1;
	SET IDENTITY_INSERT tblSubscr OFF;
	PRINT @LastOperation

	-- dependents
	SELECT @LastOperation = 'deleted all records from tblDependent'
	DELETE
	FROM tblDependent;
	PRINT @LastOperation

	SELECT @LastOperation = 'transferred dependents to temp'
	SET IDENTITY_INSERT tblDependent ON;
	INSERT INTO tblDependent (
		ID, SubID, DepSubID, DepSSN, EIMBRID, DepFirstName, DepMiddleName, 
		DepLastName, DepDOB, DepAge, DepRelationship, DepGender, 
		DepEffDate, PreexistingDate, CreateDate, User01, 
		User02, User03, User04, User05, User06, User07, User08, User09
		)
	SELECT ID, SubID, DepSubID, DepSSN, EIMBRID, DepFirstName, 
		DepMiddleName, DepLastName, DepDOB, DepAge, DepRelationship, 
		DepGender, DepEffDate, PreexistingDate, CreateDate, 
		User01, User02, User03, User04, User05, User06, 
		User07, User08, User09
	FROM QCDdataSQL2005..tblDependent AS tblDependent_1;
	SET IDENTITY_INSERT tblDependent OFF;
	PRINT @LastOperation
	
	-- rates	
	SELECT @LastOperation = 'delete all records from tblRates'
	SET IDENTITY_INSERT tblRates ON;
	DELETE
	FROM tblRates;
	PRINT @LastOperation

	SELECT @LastOperation = 'transferred rates to temp'
	INSERT INTO tblRates (RateID, GroupID, PlanID, CoverID, Rate)
	SELECT RateID, GroupID, PlanID, CoverID, Rate
	FROM QCDdataSQL2005..tblRates AS tblRates_1
	SET IDENTITY_INSERT tblRates OFF;
	PRINT @LastOperation

	-- agent	
	SELECT @LastOperation = 'delete all records from tblAgent'
	DELETE FROM tblAgent;
	PRINT @LastOperation

	SELECT @LastOperation = 'transfer agents to temp'
	SET IDENTITY_INSERT tblAgent ON;
    INSERT  INTO tblAgent
            ( ID, AgentId, Agency, AgentSSN, Agent_LUname, AgentFirst,
              AgentLast, AgentMiddle, AgentStreet1, AgentStreet2, AgentCity,
              AgentState, AgentZip, AgentPhone, AgentFax, AgentCell,
              AgentEmail, AgentCommission, AgentTaxID, AgentGeoID, AgentActive,
              PayCommTo, AgentNotes, AgentCLIC, AgentNGL, UserName, User01,
              User02, User03, User04, User05, User06, User07, User08, User09,
              DateModified )
            SELECT
                ID, AgentId, Agency, AgentSSN, Agent_LUname, AgentFirst,
                AgentLast, AgentMiddle, AgentStreet1, AgentStreet2, AgentCity,
                AgentState, AgentZip, AgentPhone, AgentFax, AgentCell,
                AgentEmail, AgentCommission, AgentTaxID, AgentGeoID,
                AgentActive, PayCommTo, AgentNotes, AgentCLIC, AgentNGL,
                UserName, User01, User02, User03, User04, User05, User06,
                User07, User08, User09, DateModified
            FROM
                 QCDdataSQL2005..tblAgent AS tblAgent_1;
		SET IDENTITY_INSERT tblAgent OFF;
		 PRINT @LastOperation;
	
	-- GrpAgt 
	SELECT @LastOperation = 'deleted all records from tblGrpAgt'
    DELETE FROM tblGrpAgt;
	PRINT @LastOperation;
	SELECT @LastOperation = 'transfered group agents to temp';
    SET IDENTITY_INSERT tblGrpAgt ON;	
    INSERT  INTO tblGrpAgt
            ( ID, AgentId, GroupId, [Primary], AgentRate, CommOwed, Sort,
              DateModified )
            SELECT
                ID, AgentId, GroupId, [Primary], AgentRate, CommOwed, Sort,
                DateModified
            FROM
                QCDdataSQL2005..tblGrpAgt AS tblGrpAgt_1;
    SET IDENTITY_INSERT tblGrpAgt OFF;
    PRINT @LastOperation;

	-- IndivAgt
	SELECT @LastOperation = 'deleted all records from tblIndivAgt';
	DELETE FROM tblIndivAgt;
	SELECT @LastOperation = 'transfered individual agents to temp';
	SET IDENTITY_INSERT tblIndivAgt ON;
	INSERT INTO tblIndivAgt (
		[ID], [AgentId], [SubSSN], [SubscrId], [PltCustKey], [Primary], [AgentRate], [CommOwed], 
		[Sort]
		)
	SELECT sia.[ID], sia.[AgentId], sia.[SubSSN], sia.[SubscrId], sia.[PltCustKey], sia.[Primary], 
		sia.[AgentRate], sia.[CommOwed], sia.[Sort]
	FROM QCDdataSQL2005.dbo.tblIndivAgt sia
	INNER JOIN tblSubscr s ON sia.SubscrId = s.SubID
	INNER JOIN tblAgent a ON sia.AgentId = a.AgentId;
	SET IDENTITY_INSERT tblIndivAgt OFF;
	PRINT @LastOperation;

	-- ARTRANH_local
	SELECT @LastOperation = 'deleted all records from ARTRANH_local'
    DELETE FROM
        ARTRANH_local;
	PRINT @LastOperation

	SELECT
    @LastOperation = 'transferred transactions to temp';
    SET IDENTITY_INSERT ARTRANH_local ON;	
    INSERT  INTO ARTRANH_local
			( ID, DocumentNumber, ApplyTo, TerritoryKey, SalespersonKey,
			  CustomerKey, CustomerClassKey, OrderNumber, ShipToKey, CheckBatch,
			  TransactionType, DocumentDate, AgeDate, DaysTillDue, DocumentAmt,
			  DiscountAmt, FreightAmt, TaxAmt, CostAmt, CommissionHomeOvride,
			  RetentionInvoice, SysDocID, ApplySysDocID, Spare, Spare2, Spare3,
			  RecUserID, RecDate, RecTime, User01, User02, User03, User04, User05,
			  User06, User07, User08, User09, DateModified, IFStatus )
			SELECT
				ID, DocumentNumber, ApplyTo, TerritoryKey, SalespersonKey,
				CustomerKey, CustomerClassKey, OrderNumber, ShipToKey, CheckBatch,
				TransactionType, DocumentDate, AgeDate, DaysTillDue, DocumentAmt,
				DiscountAmt, FreightAmt, TaxAmt, CostAmt, CommissionHomeOvride,
				RetentionInvoice, SysDocID, ApplySysDocID, Spare, Spare2, Spare3,
				RecUserID, RecDate, RecTime, User01, User02, User03, User04,
				User05, User06, User07, User08, User09, DateModified, IFStatus
			FROM
				QCDDataSQL2005.dbo.ARTRANH_local AS ARTRANH_local_1;
	SET IDENTITY_INSERT tblGrpAgt OFF
	PRINT @LastOperation;

	SET @LastOperation = ''
	PRINT @LastOperation;

	/* create foreign keys  */	
	SELECT @LastOperation = 'create foreign keys'
	PRINT @LastOperation
	
	SELECT @LastOperation = 'created FK_tblSubscr_tblGrp'
	ALTER TABLE [dbo].[tblSubscr]
		WITH CHECK ADD CONSTRAINT [FK_tblSubscr_tblGrp] FOREIGN KEY ([SubGroupID]
				) REFERENCES [dbo].[tblGrp]([GroupID])
	ALTER TABLE [dbo].[tblSubscr] CHECK CONSTRAINT [FK_tblSubscr_tblGrp]
	PRINT @LastOperation

	SELECT @LastOperation = 'created FK_tblSubscr_tblRates'
	ALTER TABLE [dbo].[tblSubscr]
		WITH NOCHECK ADD CONSTRAINT [FK_tblSubscr_tblRates] FOREIGN KEY ([RateID]
				) REFERENCES [dbo].[tblRates]([RateID]) ON
	UPDATE CASCADE
	ALTER TABLE [dbo].[tblSubscr] CHECK CONSTRAINT [FK_tblSubscr_tblRates]
	PRINT @LastOperation
	
	-- FK_tblSubscr_tblRates_GrpID_PlanID_CoverID
	SELECT @LastOperation = 'created FK_tblSubscr_tblRates_GrpID_PlanID_CoverID'
	ALTER TABLE [dbo].[tblSubscr]
		WITH CHECK ADD CONSTRAINT 
			[FK_tblSubscr_tblRates_GrpID_PlanID_CoverID] FOREIGN KEY ([SubGroupID], [PlanID], [CoverID]
				) REFERENCES [dbo].[tblRates]([GroupID], [PlanID], 
				[CoverID])
	ALTER TABLE [dbo].[tblSubscr] CHECK CONSTRAINT 
		[FK_tblSubscr_tblRates_GrpID_PlanID_CoverID]
	PRINT @LastOperation
	
	-- FK_tblDependent_tblSubscr
	SELECT @LastOperation = 'created FK_tblDependent_tblSubscr'
	ALTER TABLE [dbo].[tblDependent]
		WITH CHECK ADD CONSTRAINT [FK_tblDependent_tblSubscr] FOREIGN KEY ([DepSubID]
				) REFERENCES [dbo].[tblSubscr]([SubSSN]) ON
	UPDATE CASCADE
		ON
	DELETE CASCADE
	ALTER TABLE [dbo].[tblDependent] CHECK CONSTRAINT 
		[FK_tblDependent_tblSubscr]
	PRINT @LastOperation
		
	-- FK_tblRates_tblCoverage
	SELECT @LastOperation = 'created FK_tblRates_tblCoverage'
	ALTER TABLE [dbo].[tblRates]
		WITH CHECK ADD CONSTRAINT [FK_tblRates_tblCoverage] FOREIGN KEY ([CoverID]
				) REFERENCES [dbo].[tblCoverage]([CoverID]) ON
	UPDATE CASCADE
	ALTER TABLE [dbo].[tblRates] CHECK CONSTRAINT 
		[FK_tblRates_tblCoverage]
	PRINT @LastOperation

	-- FK_tblRates_tblPlans
	SELECT @LastOperation = 'created FK_tblRates_tblPlans'
	ALTER TABLE [dbo].[tblRates]
		WITH CHECK ADD CONSTRAINT [FK_tblRates_tblPlans] FOREIGN KEY ([PlanID]
				) REFERENCES [dbo].[tblPlans]([PlanID]) ON
	UPDATE CASCADE
	ALTER TABLE [dbo].[tblRates] CHECK CONSTRAINT [FK_tblRates_tblPlans]
	PRINT @LastOperation

	SELECT @LastOperation = 'created FK_tblGrpAgt_tblAgent'
	ALTER TABLE [dbo].[tblGrpAgt]  WITH CHECK ADD  CONSTRAINT [FK_tblGrpAgt_tblAgent] FOREIGN KEY([AgentId])
	REFERENCES [dbo].[tblAgent] ([AgentId])
	ON UPDATE CASCADE
	ON DELETE CASCADE
	ALTER TABLE [dbo].[tblGrpAgt] CHECK CONSTRAINT [FK_tblGrpAgt_tblAgent]
	PRINT @LastOperation
	
	/*  end of create foreign keys  */
	SELECT @LastOperation = 'end of create foreign keys'
	PRINT @LastOperation
	
	/*  assign EIMBRIDs  */
	
	/*  update EIMBRID on tblSubscr  */
	SELECT @LastOperation = 'assign EIMBRID to subscribers'
	UPDATE tblSubscr
	SET EIMBRID = SubSSN + '00'
	, User01 = 'refresh temp from prod'
	, User02 = 'set EIMBRID'
	, User04 = GETDATE()
	, DateUpdated = GETDATE() --dbo.udf_GetLastDayOfMonth(@DT_UPDT)
	, TransactionType = 'UPDATED'
	PRINT @LastOperation

	
	/*  update EIMBRID on tblDependent  */
	SELECT @LastOperation = 'assign EIMBRID to dependents'
	UPDATE d
	SET EIMBRID = m.EIMBRID
	, User01 = 'refresh temp from prod'
	, User02 = 'set EIMBRID'
	, User04 = GETDATE()
	FROM tblDependent d
	INNER JOIN (
			SELECT ID, DepSubID + '0' + CONVERT(NVARCHAR(2), RANK() OVER (
						PARTITION BY DepSubID ORDER BY ISNULL(DepDOB, '1901-01-01 00:00:00'), 
							DepLastName, DepFirstName
						)) EIMBRID
			FROM tblDependent
			) m
	ON d.ID = m.ID
	PRINT @LastOperation
	
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK

	SELECT @ErrorMessage = ERROR_MESSAGE() + ' Last Operation: ' + 
		@LastOperation, @ErrorSeverity = ERROR_SEVERITY(), 
		@ErrorState = ERROR_STATE()

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState
			)
END CATCH



GO
