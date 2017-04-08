SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_EDI_App_Subscr]
@ReturnParm VARCHAR(255) OUTPUT 

AS
/* ================================================================
	Object:			usp_EDI_App_Subscr			
	Author:			John Criswell
	Create date:    2013-10-12		 
	Description:	Downloads all group maintenance
					subscribers from the website
					who were added, changed, or
					deleted
					
	Parameters:		None
	Where use:		frmOnlineEnrollmentProcessing
					(used to download individual,
					initial, and maintenance subscribers
					from the website; this procedure
					processes maintenance subscribers)
					
	Change Log:
	---------------------------------------------------------------
	Change Date		Version		Changed by		Reason
	2015-02-23		2.0			JCriswell		Added error handling
	2015-05-26		3.0			JCriswell		Found an issue where the membershipstatus
												needs to be limited to Added and Changed.
												Deleted cannot be there.  Otherwise there
												will be duplicates.
	2015-11-10		4.0			J Criswell		Added code to populate Status 
												field on tblEDI_App_Subscr
	2016-01-08		5.0			J Criswell		Removed update to tblSubscr_Bexar;
												all Bexar County objects were removed from the 
												application.
	2016-03-26		6.0			J Criswell		Added code section to process deleted subscribers
	
=================================================================== */


SET NOCOUNT ON;
SET XACT_ABORT ON;
DECLARE	@LastOperation varchar(128), 
		@ErrorMessage varchar(8000), 
		@ErrorSeverity int, 
		@ErrorState int
------------------------------------------------------------------------------
BEGIN TRY
	BEGIN TRANSACTION

		/*   ---   get web data   ---   */
		-- group subscribers
		SELECT	@LastOperation = 'group subscribers'
		IF EXISTS (SELECT
			1
		FROM
			[TRACENTRMTSRV].QCD.dbo.vwGrpSub
		WHERE
			(Download = 'Yes'
			AND MembershipStatus IN ( 'Added', 'Changed', 'Deleted' )))
    
		DELETE FROM tblSubscriber_temp;

		INSERT  INTO tblSubscriber_temp
				( SSN, EIMBRID, SubscriberID, GroupID, PlanID, CoverID, LastName,
				  FirstName, MiddleInitial, Street1, Street2, City, State, Zip,
				  PhoneWork, PhoneHome, Email, DOB, DepCnt, Gender, Age,
				  EffectiveDate, PreexistingDate, EmploymentDate, EmploymentStatus,
				  Occupation_Title, MaritalStatus, CardPrinted, CardPrintedDate,
				  MembershipStatus, DateCreated, DateChanged, DateDeleted, Download,
				  DownloadDate )
				SELECT
					SSN, EIMBRID, SubscriberID, GroupID, PlanID, CoverID, LastName,
					FirstName, MiddleInitial, Street1, Street2, City, State, Zip,
					PhoneWork, PhoneHome, Email, DOB, DepCnt, Gender, Age,
					EffectiveDate, PreexistingDate, EmploymentDate, EmploymentStatus,
					Occupation_Title, MaritalStatus, CardPrinted, CardPrintedDate,
					MembershipStatus, DateCreated, DateChanged, DateDeleted, Download,
					DownloadDate
				FROM
					[TRACENTRMTSRV].QCD.dbo.vwGrpSub AS gs				
				WHERE
					( gs.Download = 'Yes' )
					AND ( gs.MembershipStatus IN ( 'Added', 'Changed', 'Deleted' ) );


		/*  ---  group depdendents   ---  */
		SELECT	@LastOperation = 'fetch group depdendents'
		IF EXISTS (SELECT
			1
		FROM
			[TRACENTRMTSRV].QCD.dbo.vwDepDwnGrp)
    
		DELETE FROM tblDependent_temp

		INSERT  INTO tblDependent_temp
				( SubSSN, EIMBRID, DepSSN, FirstName, MiddleInitial, LastName, DOB,
				  Age, Relationship, Gender, EffDate, PreexistingDate )
				SELECT
					gd.SubSSN, gd.EIMBRID,
					gd.DepSSN, gd.FirstName,
					gd.MiddleInitial, gd.LastName,
					gd.DOB, gd.Age,
					gd.Relationship, gd.Gender,
					gd.EffDate, gd.PreexistingDate
				FROM
					[TRACENTRMTSRV].QCD.dbo.vwDepDwnGrp gd;

		/*   move group subscribers to EDI_App_Subscr   */
		DELETE FROM tblEDI_App_Subscr;
		SELECT	@LastOperation = 'move group subscribers to EDI_App_Subscr'
		IF EXISTS (SELECT
			1
		FROM
			tblSubscriber_temp)
		INSERT  INTO tblEDI_App_Subscr
        ( SubSSN, EIMBRID, SubID, SubStatus, SubGroupID, PlanID, CoverID,
          SubLastName, SubFirstName, SubMiddleName, SUB_LUname, SubStreet1,
          SubStreet2, SubCity, SubState, SubZip, SubPhoneHome, SubPhoneWork,
          SUBdob, DepCnt, SubGender, SubAge, SubEffDate, PreexistingDate,
          SubMaritalStatus, SubCardPrt, SubCardPrtDte, TransactionType,
          DateCreated, DateUpdated, DateDeleted, wSubID, wUpt, AmtPaid )
        SELECT
            t.SSN, t.EIMBRID, ISNULL(t.SubscriberID, '') SubscriberID, 
            case 
				when g.GroupType = 1 then 'QCDON'
				when g.GroupType = 4 then 'ALLAM'
				when g.GroupType = 9 then 'INDIV'
				else 'UNKWN'
			end AS [Status],																		-- version 4.0
            t.GroupID,
            t.PlanID, t.CoverID, t.LastName, t.FirstName, ISNULL(t.MiddleInitial,'') MiddleInitial,
            [LastName] + ', ' + [FirstName] + ' ' + SUBSTRING(ISNULL([MiddleInitial],''),1, 1) AS LU_Name,
            UPPER(t.Street1) Street1, UPPER(t.Street2) Street2, UPPER(t.City) City, UPPER(t.[State]) AS [State], 
            REPLACE(t.Zip, '-', '') Zip,
            ISNULL(REPLACE(t.PhoneHome, '-', ''), '') PhoneHome,
            ISNULL(REPLACE(t.PhoneWork, '-', ''), '') PhoneWork, t.DOB, t.DepCnt,
            t.Gender, t.Age, t.EffectiveDate, t.PreexistingDate,
            t.MaritalStatus, t.CardPrinted, t.CardPrintedDate,
            t.MembershipStatus, t.DateCreated, t.DateChanged, t.DateDeleted,
            t.wSubID, 1 AS setU, t.AmtPaid
        FROM
            tblSubscriber_temp t
				inner join tblGrp g
					on t.GroupID = g.GroupID
        WHERE
            ( ( ( t.EIMBRID ) NOT IN ( 'INDIV' )) );		
            
		SELECT	@LastOperation = 'update fields from tblSubscr esp SubID for non BEXHM groups'
		--update fields from tblSubscr esp SubID for non BEXHM groups
		UPDATE
			eas
		SET eas.SubID = s.SubID, 
			eas.SubCardPrt = s.SUBcardPRT,
			eas.SubCardPrtDte = s.SUBcardPRTdte, 
			eas.SubNotes = s.SUBnotes
		FROM
			tblEDI_App_Subscr eas
				INNER JOIN tblSubscr s
					ON eas.SubSSN = s.SubSSN;

		SELECT	@LastOperation = 'fix PlanID for QCD Only groups'
		--if the group type is a 1 (QCD Only),
		--then change the PlanID to 5 (QCD Only plan)
		UPDATE
			eas
		SET eas.PlanID = 5
		FROM
			tblEDI_App_Subscr AS eas
			INNER JOIN tblGrp AS g
				ON eas.SubGroupID = g.GroupID
		WHERE
			g.GroupType = 1;

		SELECT	@LastOperation = 'update rate ids for group subscribers'
		--update rate id's for group subscribers
		UPDATE
			eas
		SET eas.RateID = r.RateID
		FROM
			tblEDI_App_Subscr AS eas
			INNER JOIN tblRates AS r
				ON eas.CoverID = r.CoverID
				   AND eas.PlanID = r.PlanID
				   AND eas.SubGroupID = r.GroupID
				   AND eas.SubStatus <> 'INDIV';


		/*   ---   move group dependents to EDI_App_Dep   ---   */
		SELECT	@LastOperation = 'move group dependents to EDI_App_Dep'
		IF EXISTS (SELECT
			1
		FROM
			tblEDI_App_Dep)
    
		DELETE FROM tblEDI_App_Dep

		/*  move dependents */
		INSERT  INTO tblEDI_App_Dep
				( DEPssn, EIMBRID, DEPsubID, DEPfirstNAME, DEPlastNAME, DEPmiddleNAME,
				  DepDOB, DepAge, DepRelationship, DEPgender, DepEffDate,
				  PreexistingDate )
				SELECT
					td.DepSSN, td.EIMBRID, td.SubSSN, td.FirstName, td.LastName,
					td.MiddleInitial, td.DOB, td.Age, td.Relationship,
					SUBSTRING(td.[Gender], 1, 1) AS DepGender, td.EffDate,
					td.PreexistingDate
				FROM
					tblDependent_temp td
					INNER JOIN tblSubscriber_temp ts
						ON td.SubSSN = ts.SSN
				WHERE
					( ( ( ts.MembershipStatus ) = 'Added'
						OR ( ts.MembershipStatus ) = 'Changed'
					  )
					  AND ( ( ts.GroupID ) NOT IN ( 'INDIV' ) )
					);

		/*  clean up data on EDI_App_Subscr  */
		--fix dep cnts
		UPDATE
			s
		SET s.DepCnt = depcnt.DepCnt
		FROM
			tblEDI_App_Subscr s
			INNER JOIN ( SELECT
							SubSSN, dbo.udf_EDI_App_Subscr_DepCnt(SubSSN) DepCnt
						 FROM
							tblEDI_App_Subscr ) depcnt
				ON s.SubSSN = depcnt.SubSSN;
        
		--fix CoverIDs
		UPDATE
			s
		SET s.CoverID = c.CoverId
		FROM
			tblEDI_App_Subscr s
			INNER JOIN ( SELECT
							s.SubSSN, gct.TierCnt,
							dbo.udf_EDI_App_Subscr_CoverID(s.SubSSN, gct.TierCnt) CoverID
						 FROM
							tblEDI_App_Subscr AS s
							INNER JOIN tblGrp g
								ON s.SubGroupID = g.GroupID
							INNER JOIN vw_Group_Coverage_Tiers gct
								ON g.GroupID = gct.GroupID ) c
				ON s.SubSSN = c.SubSSN;


		--add the coverage description for the export file to the TPA
		--UPDATE
		--    eas
		--SET eas.Coverage = c.CoverDescr, eas.CoverDesc = c.CoverDescr
		--FROM
		--    tblEDI_App_Subscr AS eas
		--    INNER JOIN tblRates AS r
		--        ON eas.CoverID = r.CoverID
		--           AND eas.PlanId = r.PlanId
		--           AND eas.SubGroupID = r.GroupID
		--    INNER JOIN tblCoverage AS c
		--        ON r.CoverID = c.CoverID

		-- move deleted subscribers
		SELECT @LastOperation = 'Move deleted subscribers to tblEDI_App_Subscr_delete'
		IF EXISTS (SELECT 1
					FROM tblSubscriber_temp AS st
				INNER JOIN tblGrp g ON st.GroupID = g.GroupID
		WHERE   ( g.GroupType = 4 )
				AND ( MembershipStatus ='Deleted' ))		
		INSERT  INTO tblEDI_App_Subscr_delete ( SubSSN, EIMBRID, SubID, SubStatus,
										SubGroupID, PlanID, CoverID,
										SubLastName, SubFirstName,
										SubMiddleName, SUB_LUname,
										SubStreet1, SubStreet2, SubCity,
										SubState, SubZip, SUBdob, DepCnt,
										SubGender, SubAge, SubEffDate,
										SubMaritalStatus, SubCardPrt,
										SubCardPrtDte, TransactionType,
										DateCreated, DateUpdated,
										DateDeleted, wSubID )
		SELECT  SSN, EIMBRID, SubscriberID, 'GRSUB' AS [STATUS],
				st.GroupID, PlanID, CoverID, LastName, FirstName,
				MiddleInitial,
				LastName + ', ' + FirstName + ' '
				+ SUBSTRING(MiddleInitial, 1, 1) AS LU_Name, Street1,
				Street2, City, [State], Zip, DOB, DepCnt, Gender, Age,
				EffectiveDate, MaritalStatus, CardPrinted, CardPrintedDate,
				MembershipStatus, st.DateCreated, st.DateChanged,
				st.DateDeleted, wSubID
		FROM    tblSubscriber_temp AS st
				INNER JOIN tblGrp g ON st.GroupID = g.GroupID
		WHERE   ( g.GroupType = 4 )
				AND ( MembershipStatus ='Deleted' );


	COMMIT TRANSACTION
	SET @ReturnParm = 'Procedure succeeded'
END TRY

-- Error Handler
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
    SET @ReturnParm = 'Procedure Failed'
END CATCH

GO
EXEC sp_addextendedproperty N'Purpose', N'Downloads all group maintenance subscribers from the website who were added, changed, or deleted.', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_EDI_App_Subscr', NULL, NULL
GO
