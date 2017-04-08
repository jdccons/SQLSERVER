SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[usp_tpa_final_sub]
(			@UserName NVARCHAR(50),
			@Path NVARCHAR(50),
			@File NVARCHAR(50)
)
AS
/* ==============================================================
	Object:			usp_tpa_final_sub
	Author:			John Criswell
	Create date:	10/10/2015 
	Description:	final insert into tblSubscr from tpa file
								
							
	Change Log:
	-------------------------------------------------------------
	Change Date	Version		Changed by		Reason
	2015-10-10	1.0			J Criswell		Created.
	2015-10-14	2.0			J Criswell		Removed two updates - 
											SSN and SUB_ID;
											removed field update for 
											SSN and SUB_ID when all other
											fields are updated.
	2015-10-14	3.0			J Criswell		Changed the where clause on
											adding new subscribers.
	2015-10-14	4.0			J Criswell		Filtered the sql statements
											to process All American groups only
	2015-10-15	5.0			J Criswell		Added some additional logic for terming
	2015-10-17	6.0			J Criswell		Added dependents
	2015-10-18	7.0			J Criswell		Removed dependents (will do in a separate sp);
											added code to re-active termed subscribers
	2015-10-20	8.0			J Criswell		Added code to terminate subscribers that
	2015-11-20	9.0			J Criswell		Removed output parm and added a return parm instead
			 								tpa identified to terminate;
			 								and the update procedure was modified to
			 								update the GroupID for a subscriber if he
			 								moved from one group to another in the database
	2015-11-10	10.0		J Criswell		Added UserName parameter
	2015-11-15	11.0		J Criswell		Assigned temp SUB_IDs to those who don't have one.		 								
	2015-11-30	12.0		J Criswell		Added parameters (Path and File - they are not really used)
	2016-03-01	13.0		J Criswell		Added MBR_ID from tpa file to updates and inserts
	2016-05-04	14.0		J Criswell		Changed logic on subscriber reactivation.
	2016-06-05	15.0		J Criswell		Changed the criteria for group type;  previously depended on the
											tpa to populate this field.  tpa can no longer be trusted to do this.
											Change involved joining tblGrp to all statements and using the GroupType
											field on tblGrp.
	2016-07-07	16.0		J Criswell		Remove the code to convert pending deletions to delete
	2016-08-21	17.0		J Criswell		Changed date deleted on pending deletions to the end of the month
================================================================= */
/*  ------------------  declarations  --------------------  */ 
SET NOCOUNT ON;
SET XACT_ABORT ON;
    DECLARE @LastOperation VARCHAR(128) ,
        @ErrorMessage VARCHAR(8000) ,
        @ErrorSeverity INT ,
        @ErrorState INT

	DECLARE @SUB_ID INTEGER
	DECLARE @NextSubID AS INTEGER
	DECLARE @DT_UPDT AS DATETIME		
/*  ------------------------------------------------------  */

BEGIN TRY
   BEGIN TRANSACTION
		
		/*  variable assignments  */
		--SET @DT_UPDT = (SELECT MAX(DT_UPDT) FROM tpa_data_exchange_sub);
		
		/*  create SubIDs for those who don't have one  */	
		SELECT @LastOperation = 'save the last SubID used';
		SELECT @SUB_ID = (SELECT LastSubID FROM SubIDControl_temp)
		
        IF OBJECT_ID('tempdb..#SubID') IS NOT NULL 
            DROP TABLE #SubID
        
        SELECT IDENTITY( INT,1,1 ) AS [ID], @SUB_ID AS SubID, 0 AS NextSubID,
                SSN
            INTO #SubID
            FROM (             
					SELECT SSN
					FROM tpa_data_exchange_sub
					WHERE ((SUB_ID = '')
						OR (SUB_ID IS NULL))
						AND RCD_TYPE = 'S'
						AND GRP_TYPE = '4'				
				) s
            
        UPDATE a
            SET NextSubID = ( b.SubID + b.ID )
            FROM #SubID a 
            INNER JOIN #SubID b
                ON a.ID = b.ID; 
        
        -- update the import table with SubIDs        
        SELECT @LastOperation = 'update the import table with SubIDs';
        UPDATE  tpa_data_exchange_sub
		SET tpa_data_exchange_sub.SUB_ID = CAST(#SubID.NextSubID AS VARCHAR(8))
	    FROM tpa_data_exchange_sub  
			INNER JOIN #SubID
				ON tpa_data_exchange_sub.SSN = #SubID.SSN;
			
        -- save the last SubID used        
        SELECT @LastOperation = 'save the last SubID used';        
        IF EXISTS ( SELECT 1 FROM #SubID ) 
            BEGIN
                SELECT  @NextSubID = MAX(NextSubID)
                    FROM #SubID
		        
                UPDATE SubIDControl_temp
                    SET LastSubID = @NextSubID + 1
            END
            
        /*  changes in SSN  ?  */
		UPDATE s
		SET s.SubSSN = des.SSN
		FROM tblSubscr s
		INNER JOIN tpa_data_exchange_sub des
			ON s.SubID = des.SUB_ID
				AND s.SubSSN != des.SSN;
				
		/*  changes in SubID ?  */		
		UPDATE s
		SET s.SubID = des.SUB_ID
		FROM tblSubscr s
		INNER JOIN tpa_data_exchange_sub des
			ON s.SubID != des.SUB_ID
				AND s.SubSSN = des.SSN;
		
		/*  reactivations  */
		-- change SubCancelled for those subscribers
		-- who are being reactivated
		SELECT  @LastOperation = 'reactivate termed subscribers'
		IF EXISTS(
				/* AA subs at QCD who are cancelled and they are active at TPA  */
                SELECT  s.SubGroupID, s.SubSSN, s.GrpType, s.SubLastName, s.SubFirstName,
                        s.GrpName
                FROM    [dbo].[vw_GrpSubscr] s
                        INNER JOIN dbo.tpa_data_exchange_sub r ON s.SubSSN = r.SSN
                WHERE   s.GrpType = 'All American'
                        AND s.SubCancel = 'Cancelled'
						 AND ( r.MBR_ST != 3 ) 
				)
		UPDATE s
		SET SubCancelled = 1
			, s.User01 = 'usp_tpa_final_sub'
			, s.User02 = 'reactivate termed subscriber'
			, s.User04 = GETDATE()
			, s.DateDeleted = NULL
			, s.DateUpdated =   GETDATE()  --dbo.udf_GetLastDayOfMonth(@DT_UPDT)
			, s.TransactionType = 'UPDATED'
			, s.UserName = @UserName
            FROM    [dbo].[tblSubscr] s
                        INNER JOIN dbo.tpa_data_exchange_sub r ON s.SubSSN = r.SSN
						INNER JOIN tblGrp g ON s.SubGroupID = g.GroupID
                WHERE   g.GroupType = 4
                        AND g.GRCancelled = 0
						 AND ( r.MBR_ST != 3 );

		/*  updates  */
		-- update all non-key fields for current subscribers
		SELECT  @LastOperation = 'update all other tblSubscr fields'
		IF EXISTS (
				SELECT s.SubSSN
				FROM tblSubscr AS s
				INNER JOIN tpa_data_exchange_sub AS r
					--ON ((s.SubGroupID = r.GRP_ID)			
					-- AND (ISNULL(s.SubSSN, '') = ISNULL(r.SSN, '')))		-- version 9 change
				ON (ISNULL(s.SubSSN, '') = ISNULL(r.SSN, ''))
				INNER JOIN tblGrp g
					ON r.GRP_ID = g.GroupID
				WHERE (r.RCD_TYPE = 'S')
					AND (g.GroupType = 4)
					AND (g.GRCancelled = 0)
					AND (r.MBR_ST !=3)
					AND ((ISNULL(s.SubGroupID, '') <> ISNULL(r.GRP_ID, ''))  -- version 9 change
					OR (ISNULL(s.SubLastName, '') <> ISNULL(r.LAST_NAME, ''))
					OR (ISNULL(s.SubFirstName, '') <> ISNULL(r.FIRST_NAME, ''))
					OR (ISNULL(s.SubMiddleName, '') <> ISNULL(r.MI, ''))
					OR (s.PlanID <> r.[PLAN])
					OR (s.CoverID <> r.COV)
					OR (ISNULL(s.SubStreet1, '') <> ISNULL(r.ADDR1, ''))
					OR (ISNULL(s.SubStreet2, '') <> ISNULL(r.ADDR2,''))
					OR (ISNULL(s.SubCity, '') <> ISNULL(r.CITY, ''))
					OR (s.SubState <> r.[STATE])
					OR (ISNULL(s.SubZip, '') <> ISNULL(r.ZIP, ''))
					OR (ISNULL(s.SubEmail, '') <> ISNULL(r.EMAIL, ''))
					OR (s.SubEffDate <> r.EFF_DT)
					OR (ISNULL(s.PreexistingDate, '1901-01-01 00:00:00.000') <> ISNULL(r.PREX_DT, '1901-01-01 00:00:00.000'))
					OR (s.SubPhoneHome <> r.PHONE_HOME)
					OR (s.SubPhoneWork <> r.PHONE_WORK)
					OR (ISNULL(s.SubDOB, '1901-01-01 00:00:00.000') <> ISNULL(r.DOB, '1901-01-01 00:00:00.000'))
					OR (s.DepCnt <> r.NO_DEP))
				)
			UPDATE s
				SET 
				--	s.SubSSN = r.SSN,
					s.SubGroupID = r.GRP_ID,									-- version 9 change
					s.SubID = r.SUB_ID,
					s.EIMBRID = r.MBR_ID,										-- version 13 change
					s.SubStatus = CASE 
									WHEN r.GRP_TYPE = 1 THEN 'GRSUB'
									WHEN r.GRP_TYPE = 4 THEN 'GRSUB'
									ELSE 'INDIV'
									END,
					--s.SubGroupID = r.GRP_ID,
					s.PlanID = r.[PLAN],
					s.CoverID = r.COV,
					s.SubCancelled = 1,
					s.SubLastName = ISNULL(r.LAST_NAME, ''),
					s.SubFirstName = ISNULL(r.FIRST_NAME, ''),
					s.SubMiddleName = ISNULL(r.MI, ''),
					s.SubStreet1 = ISNULL(SUBSTRING(r.ADDR1, 1, 50), ''),
					s.SubStreet2 = ISNULL(SUBSTRING(r.ADDR2, 1, 50), ''),
					s.SubCity = ISNULL(r.CITY, ''),
					s.SubState = ISNULL(r.[STATE], ''),
					s.SubZip = ISNULL(r.ZIP, ''),			
					s.SubPhoneHome = ISNULL(r.PHONE_HOME, ''),
					s.SubPhoneWork = ISNULL(r.PHONE_WORK, ''),
					s.SubEmail = ISNULL(r.EMAIL, ''),
					s.SubDOB = ISNULL(r.DOB, '1901-01-01 00:00:00'),
					s.DepCnt = r.NO_DEP,
					s.SubGender = r.GENDER,
					s.SubEffDate = r.EFF_DT,
					s.PreexistingDate = r.PREX_DT,			
					s.User01 = 'usp_tpa_final_sub',
					s.User02 = 'subscriber update from tpa',
					s.User04 = GETDATE(),
					s.DateUpdated = GETDATE(),
					s.TransactionType = 'UPDATED',
					s.UserName = @UserName
				FROM tblSubscr AS s
				INNER JOIN tpa_data_exchange_sub AS r
					--ON ((s.SubGroupID = r.GRP_ID)			
					-- AND (ISNULL(s.SubSSN, '') = ISNULL(r.SSN, '')))				-- version 9 change
					ON (ISNULL(s.SubSSN, '') = ISNULL(r.SSN, ''))
				INNER JOIN tblGrp g
					ON r.GRP_ID = g.GroupID
				WHERE (r.RCD_TYPE = 'S')
					AND (g.GroupType = 4)
					AND (g.GRCancelled = 0)
					AND (r.MBR_ST != 3)
					AND ((ISNULL(s.SubGroupID, '') <> ISNULL(r.GRP_ID, ''))			-- version 9 change
					OR (ISNULL(s.SubLastName, '') <> ISNULL(r.LAST_NAME, ''))
					OR (ISNULL(s.SubFirstName, '') <> ISNULL(r.FIRST_NAME, ''))
					OR (ISNULL(s.SubMiddleName, '') <> ISNULL(r.MI, ''))
					OR (s.PlanID <> r.[PLAN])
					OR (s.CoverID <> r.COV)
					OR (ISNULL(s.SubStreet1, '') <> ISNULL(r.ADDR1, ''))
					OR (ISNULL(s.SubStreet2, '') <> ISNULL(r.ADDR2,''))
					OR (ISNULL(s.SubCity, '') <> ISNULL(r.CITY, ''))
					OR (s.SubState <> r.[STATE])
					OR (ISNULL(s.SubZip, '') <> ISNULL(r.ZIP, ''))
					OR (ISNULL(s.SubEmail, '') <> ISNULL(r.EMAIL, ''))
					OR (s.SubEffDate <> r.EFF_DT)
					OR (ISNULL(s.PreexistingDate, '1901-01-01 00:00:00.000') <> ISNULL(r.PREX_DT, '1901-01-01 00:00:00.000'))
					OR (s.SubPhoneHome <> r.PHONE_HOME)
					OR (s.SubPhoneWork <> r.PHONE_WORK)
					OR (ISNULL(s.SubDOB, '1901-01-01 00:00:00.000') <> ISNULL(r.DOB, '1901-01-01 00:00:00.000'))
					OR (s.DepCnt <> r.NO_DEP)
					);

		/*  adds  */
		/*
		insert All American subscribers from tpa file;
		mismatch comparison on SSN;
		if subscriber in tpa file and not in QCD database,
		then it is an add and insert the record in the tpa data excange table                 
		*/
		SELECT  @LastOperation = 'populate tblSubscr with new subscribers'
		IF EXISTS (			
			SELECT r.SSN
			FROM (
				SELECT s.SubSSN
				FROM tblSubscr s
				WHERE s.SubCancelled = 1					-- active subscribers only
				) s
			RIGHT OUTER JOIN (
				SELECT r.SSN
				FROM tpa_data_exchange_sub r
				INNER JOIN tblGrp g
					ON r.GRP_ID = g.GroupID
				WHERE r.RCD_TYPE = 'S'						-- subscribers only
					AND g.GroupType = 4						-- All American groups only
					AND g.GRCancelled = 0					-- active groups only
					AND (r.MBR_ST !=3)						-- no terms from tpa
				) r
				ON s.SubSSN = r.SSN
			WHERE (s.SubSSN IS NULL)					
			)

			/*  insert new All American subscribers */
            INSERT  INTO tblSubscr
                    ( SubSSN, SubID, SubGroupID, SubLastName, SubFirstName,
                      SubMiddleName, SubDOB, PlanID, CoverID, SubEffDate,
                      PreexistingDate, SubGender, SubStreet1, SubStreet2,
                      SubCity, SubState, SubZip, SubEmail, SubPhoneHome,
                      SubPhoneWork, DepCnt, SubStatus, SubCancelled, User01,
                      User02, User04, DateCreated, TransactionType, EIMBRID,
                      UserName )
            SELECT 
                r.SSN, r.SUB_ID, r.GRP_ID, r.LAST_NAME, r.FIRST_NAME,
                r.MI, r.DOB, r.[PLAN], r.COV, r.EFF_DT, r.PREX_DT,
                r.GENDER, r.ADDR1, r.ADDR2, r.CITY, r.[STATE], r.ZIP,
                r.[EMAIL], r.PHONE_HOME, r.PHONE_WORK, r.NO_DEP,
                'GRSUB' SubStatus, r.SubCancelled,
                'usp_tpa_final_sub' User01,
                'subscriber add from tpa' User02, GETDATE() User04,
                GETDATE() AS DateCreated, 'ADDED' AS TransactionType,
                ( r.MBR_ID ) AS EIMBRID,												--version 13 change
                @UserName
            FROM
           (
           /*  All American Subscribers from QCD database   */
            SELECT 
                s.SubSSN, s.SubID, s.SubLastName, s.SubFirstName,
                s.SubMiddleName, s.SubGroupID, s.SubCancelled
            FROM
                tblSubscr s
            WHERE
                s.SubCancelled = 1 -- active subscribers only
            ) s
            RIGHT OUTER JOIN 
			(
            /*  Direct Care Administrators All American Subscribers  */
            SELECT 
                r.SSN, r.SUB_ID, r.MBR_ID,												--version 13 change
                ISNULL(r.LAST_NAME, '') LAST_NAME,
                ISNULL(r.FIRST_NAME, '') FIRST_NAME, r.MI, r.GRP_ID, r.DOB,
                r.[PLAN], COV, EFF_DT, PREX_DT, GENDER,
                ISNULL(r.ADDR1, '') ADDR1, ISNULL(r.ADDR2, '') ADDR2,
                ISNULL(r.CITY, '') CITY, r.[STATE], ISNULL(r.ZIP, '') ZIP,
                ISNULL(r.[EMAIL], '') [EMAIL],
                ISNULL(r.PHONE_HOME, '') PHONE_HOME,
                ISNULL(r.PHONE_WORK, '') PHONE_WORK, 
				NO_DEP, 1 AS SubCancelled
            FROM
                tpa_data_exchange_sub r
            INNER JOIN tblGrp g ON r.GRP_ID = g.GroupID
            WHERE
                r.RCD_TYPE = 'S'					-- subscribers only
                AND r.GRP_TYPE = 4					-- All American groups only
                AND g.GRCancelled = 0				-- active groups only
                AND r.MBR_ST !=3  				    -- only add and change transactions from tpa
			) r 
			ON ISNULL(s.SubSSN, '') = ISNULL(r.SSN,'')
                    WHERE ( s.SubSSN IS NULL );

		
		/*  terminations  */
		/* 
		    identifies subscribers to terminate by comparing the subscribers' SSNs in the tpa
			file versus the on premise database; if the subscriber is not in the tpa file, 
			but is in the QCD on premise database, then the subscribers' SubCancelled status is set to 3 (cancelled).
			
			-- NEW CODE version 8 (2015-10-20):
			tpa is now identifying records to be terminated with a MBR_ST code equal to 3;  
			update was added to perform this action.

			-- NEW CODE version 17 (2016-08-21)
			if DCA says the subscriber should be deleted 
			or if the subscriber is not in the DCA file 
			but is in the subscriber table with SubCancelled = 1, 
			then set the DateDeleted date to the last day of the month 
			in which the DCA file was imported.  
			Leave the SubCancelled = 1 until invoices for the next month are run.
		*/
		SELECT  @LastOperation = 'processing identified terms from tpa'
		IF EXISTS(
					SELECT s.SubSSN
					FROM tpa_data_exchange_sub r
					INNER JOIN tblSubscr s
						ON r.SSN = s.SubSSN
					INNER JOIN tblGrp g
						ON r.GRP_ID = g.GroupID
					WHERE MBR_ST = 3
						AND g.GroupType = 4
						AND g.GRCancelled = 0		
				)
        UPDATE
            s
        SET --	s.SubSSN = r.SSN,
			s.SubID = r.SUB_ID, 
			s.EIMBRID = r.MBR_ID ,												--version 13 change
            s.SubStatus = CASE WHEN r.GRP_TYPE = 1 THEN 'GRSUB'
                                 WHEN r.GRP_TYPE = 4 THEN 'GRSUB'
                                 ELSE 'INDIV'
                            END, 
			s.SubGroupID = r.GRP_ID, 
			s.PlanID = r.[PLAN],
            s.CoverID = r.COV, 
			s.SubCancelled = 1,
            s.SubLastName = ISNULL(r.LAST_NAME, ''),
            s.SubFirstName = ISNULL(r.FIRST_NAME, ''),
            s.SubMiddleName = ISNULL(r.MI, ''),
            s.SubStreet1 = ISNULL(SUBSTRING(r.ADDR1, 1, 50), ''),
            s.SubStreet2 = ISNULL(SUBSTRING(r.ADDR2, 1, 50), ''),
            s.SubCity = ISNULL(r.CITY, ''), 
			s.SubState = ISNULL(r.[STATE], ''),
            s.SubZip = ISNULL(r.ZIP, ''),
            s.SubPhoneHome = ISNULL(r.PHONE_HOME, ''),
            s.SubPhoneWork = ISNULL(r.PHONE_WORK, ''),
            s.SubEmail = ISNULL(r.EMAIL, ''),
            s.SubDOB = ISNULL(r.DOB, '1901-01-01 00:00:00'),
            s.DepCnt = r.NO_DEP, 
			s.SubGender = r.GENDER,
            s.SubEffDate = r.EFF_DT, 
			s.PreexistingDate = r.PREX_DT,
            s.User01 = 'usp_tpa_final_sub',
            s.User02 = 'subscriber term from tpa', 
			s.User04 = GETDATE(),
            s.DateDeleted = dbo.udf_GetLastDayOfMonth(GETDATE()),  -- version 17 change
            s.TransactionType = 'UPDATED', 
			s.UserName = @UserName
        FROM
            tblSubscr AS s
        INNER JOIN tpa_data_exchange_sub AS r ON ( ( s.SubGroupID = r.GRP_ID )
                                                   AND ( ISNULL(s.SubSSN, '') = ISNULL(r.SSN,
                                                              '') )
                                                 )
        INNER JOIN tblGrp g ON ( r.GRP_ID = g.GroupID )
        WHERE
            MBR_ST = 3
            AND g.GroupType = 4
			AND g.GRCancelled = 0
            AND s.SubCancelled = 1;		

		/* terminations based on mismatch  */
		/*
		if DCA says the subscriber should be deleted 
		or if the subscriber is not in the DCA file 
		but is in the subscriber table with SubCancelled = 1, 
		then set the DateDeleted date to the last day of the month 
		in which the DCA file was imported.  
		Leave the SubCancelled = 1 until invoices for the next month are run.
		*/
		SELECT  @LastOperation = 'processing mis-matched terms from tpa'	
		IF EXISTS (
			SELECT s.SubSSN
			FROM tblSubscr AS s
				INNER JOIN tblGrp g
					ON s.SubGroupID = g.GroupID				
			LEFT OUTER JOIN (
				SELECT r.SSN
				FROM tpa_data_exchange_sub r
					INNER JOIN tblGrp g
						ON r.GRP_ID = g.GroupID
				WHERE r.RCD_TYPE = 'S'						-- subscribers only
				AND r.GRP_TYPE = 4							-- All American groups only
				AND g.GRCancelled = 0						-- active groups only				
				) r
				ON s.SubSSN = r.SSN
			WHERE 					
				(r.SSN IS NULL)
				AND (g.GroupType = 4)						-- All American groups only
				AND (g.GRCancelled = 0)						-- active groups only
				AND (s.SubCancelled = 1)					-- active subscribers only		
			)
		UPDATE s
		SET SubCancelled = 1 ,
		DateDeleted = dbo.udf_GetLastDayOfMonth(GETDATE()),
		User01 = 'usp_tpa_final_sub', 
		User02 = 'pending terminations until the end of the month', 
		User04 = GETDATE(),
		TransactionType = 'UPDATED',
		UserName = @UserName
		FROM tblSubscr AS s
				INNER JOIN tblGrp g
					ON s.SubGroupID = g.GroupID				
			LEFT OUTER JOIN (
				SELECT r.SSN, r.DT_UPDT
				FROM tpa_data_exchange_sub r
					INNER JOIN tblGrp g
						ON r.GRP_ID = g.GroupID
				WHERE r.RCD_TYPE = 'S'						-- subscribers only
				AND r.GRP_TYPE = 4							-- All American groups only
				AND g.GRCancelled = 0						-- active groups only
				) r
				ON s.SubSSN = r.SSN
		WHERE 					
			(r.SSN IS NULL)
			AND (g.GroupType = 4)							-- All American groups only
			AND (g.GRCancelled = 0)							-- active groups only
			AND (s.SubCancelled = 1)						-- active subscribers only
			;
			
		-- set all the pending deletions to deleted
		/*
		SELECT @LastOperation = 'update SubCancelled for terms'
		IF EXISTS
			(
			SELECT s.SubSSN, *
			FROM tblSubscr s
			--INNER JOIN tpa_data_exchange_sub r
			--	ON s.SubSSN = r.SSN
			--INNER JOIN tblGrp g
			--	ON s.SubGroupID = g.GroupID
			WHERE (GETDATE() > ISNULL(s.DateDeleted, '1901-01-01 00:00:00'))
				AND (s.SubCancelled != 3)			
			)
		UPDATE tblSubscr
		SET SubCancelled = 3, 
			User01 = 'usp_tpa_final_sub', 
			User02 = 'final terminations from tpa', 
			User04 = GETDATE(), 
			TransactionType = 'DELETED',
			UserName = @UserName
		FROM tblSubscr s
			--INNER JOIN tpa_data_exchange_sub r
			--	ON s.SubSSN = r.SSN
			--INNER JOIN tblGrp g
			--	ON s.SubGroupID = g.GroupID
			WHERE (GETDATE() > s.DateDeleted)
				AND (s.SubCancelled != 3);
		*/
		
		-- update the RateIDs
		SELECT @LastOperation = 'update RateIDs'
		UPDATE s
		SET RateID = r.RateID
		FROM tblSubscr s
		INNER JOIN tblRates r
			ON s.SubGroupID = r.GroupID
				AND s.PlanID = r.PlanID
				AND s.CoverID = r.CoverID
		WHERE DATEADD(ss, - 5, GETDATE()) <= DateModified;
				
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
    EXEC usp_CallProcedureLog 
	@ObjectID       = @@PROCID,
	@AdditionalInfo = @LastOperation;
		RETURN 0
END CATCH;


GO
EXEC sp_addextendedproperty N'Purpose', N'Processes data received from tpa and updates tblSubscr...', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_tpa_final_sub', NULL, NULL
GO
