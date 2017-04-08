SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[usp_import_standard]
@ReturnParm VARCHAR(255) OUTPUT 
AS
/* ==============================================================
	Object:			usp_import_standard
	Author:			John Criswell
	Create date:	10/16/2015 
	Description:	imports group subscribers and dependents
					using the standard file layout
								
							
	Change Log:
	-------------------------------------------------------------
	Change Date	Version		Changed by		Reason
	2016-04-03	1.0			J Criswell		Created
	2016-05-04	2.0			J Criswell		Correct problem with insert
											into tblEDI_App_Dep; SubDOB
											needed conversion from string
											to date.
	

================================================================= */
/*  ------------------  declarations  --------------------  */ 
SET NOCOUNT ON;
SET XACT_ABORT ON;
    DECLARE @LastOperation VARCHAR(128) ,
        @ErrorMessage VARCHAR(8000) ,
        @ErrorSeverity INT ,
        @ErrorState INT

	
/*  ------------------------------------------------------  */
BEGIN TRY
   BEGIN TRANSACTION
		-- copy subscribers from temp table to EDI_App_Subscr
		SELECT  @LastOperation = 'clear out edi app subscr'
		DELETE FROM dbo.tblEDI_App_Subscr;

		SELECT  @LastOperation = 'populate EDI_App_Subscr'
		INSERT  INTO tblEDI_App_Subscr ( SubSSN, SubGroupID, PlanID, CoverID, RateID,
										 SubFirstName, SubMiddleName, SubLastName,
										 SubStreet1, SubStreet2, SubCity, SubState,
										 SubZip, SubPhoneHome, SubPhoneWork, SUBdob,
										 DepCnt, SubEffDate, SUB_LUname, SubStatus,
										 SubGender, SubAge )
				SELECT  s.SubSSN, s.SubGroupID, r.PlanID, r.CoverID, r.RateID,
						s.SubFirst, s.SubMI, s.SubLast, s.SubAddr, s.SubAddr2,
						s.SubCity, s.SubState, s.SubZip, s.SubHomePh, s.SubWorkPh,
						dbo.udf_ConvertDate(s.SubDOB) AS DateOfBirth,
						ISNULL(s.SubNoDep, 0) AS DepCnt,
						dbo.udf_ConvertDate(s.SubEffDate) AS EffDate,
						dbo.udf_GetLU_Name(s.SubLast, s.SubFirst, s.SubMI) AS LookUpName,
						'GRSUB' AS Status, s.SubGender,
						dbo.fAgeCalc(dbo.udf_ConvertDate(s.SubDOB)) AS SubAge
				FROM    QCDStandardSubscriber AS s
						INNER JOIN vwRates AS r ON s.SubTypeCov = r.CoverCode
												   AND s.SubGroupID = r.GroupID;
		
		SELECT  @LastOperation = 'update dateupdated'
		UPDATE  tblEDI_App_Subscr
		SET     tblEDI_App_Subscr.DateUpdated = GETDATE()
		FROM    tblEDI_App_Subscr
				INNER JOIN tblGrp ON tblGrp.GroupID = tblEDI_App_Subscr.SubGroupID;
               

		SELECT  @LastOperation = 'update various fields from subscriber table'
		UPDATE  tblEDI_App_Subscr
		SET     tblEDI_App_Subscr.SubID = tblSubscr.SubID,
				tblEDI_App_Subscr.SubCardPrt = tblSubscr.SubCardPrt,
				tblEDI_App_Subscr.SubCardPrtDte = tblSubscr.SubCardPrtDte,
				tblEDI_App_Subscr.SubNotes = tblSubscr.SubNotes,
				tblEDI_App_Subscr.DateCreated = tblSubscr.DateCreated,
				tblEDI_App_Subscr.DateUpdated = tblSubscr.DateUpdated
		FROM    tblEDI_App_Subscr
				INNER JOIN tblSubscr ON tblEDI_App_Subscr.SubSSN = tblSubscr.SubSSN;


		SELECT  @LastOperation = 'clear out edi app dep'
		DELETE FROM dbo.tblEDI_App_Dep;

        SELECT  @LastOperation = 'populate edi app dep'
        INSERT  INTO tblEDI_App_Dep ( DepSSN, DepSubID, DepFirstName,
                                      DepLastName, DepMiddleName, DepDOB,
                                      DepGender, DepRelationship )
                SELECT  DepSSN, SubSSN, DepFirstName, DepLastName, DepMI,
                        dbo.udf_ConvertDate(DepDOB) AS DOB, DepGender,
                        ISNULL(DepRelation, 'O') AS Rel
                FROM    QCDStandardDependent AS d;

	COMMIT TRANSACTION
	SET @ReturnParm = 'Procedure succeeded'
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
    SET @ReturnParm = 'Procedure Failed'
END CATCH






GO
EXEC sp_addextendedproperty N'Purpose', N'Imports group data according to standard file format.', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_import_standard', NULL, NULL
GO
