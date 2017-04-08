SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[usp_tpa_import_sub]
@ReturnParm VARCHAR(255) OUTPUT 
AS
/* ==============================================================
	Object:			usp_tpa_import_sub
	Author:			John Criswell
	Create date:	10/16/2015 
	Description:	imports subs from tpa_data_exchange table
			into the tpa_data_exchange_sub table
								
							
	Change Log:
	-------------------------------------------------------------
	Change Date	Version		Changed by		Reason
	2015-10-16	1.0			J Criswell		Created
	2016-03-01  4.0			J Criswell		Removed code to assign MBR_ID

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
		-- copy subscribers from data exchange table to subscriber data exchange table
		SELECT  @LastOperation = 'truncate tpa_data_exchange_sub'
		DELETE FROM tpa_data_exchange_sub


		SELECT  @LastOperation = 'populate tpa_data_exchange_sub'
		INSERT  INTO tpa_data_exchange_sub
				( SSN, GRP_TYPE, RCD_TYPE,MBR_ID,SUB_ID,DEP_SSN,LAST_NAME,FIRST_NAME,MI,DOB,
				  GRP_ID,[PLAN],COV,EFF_DT,PREX_DT,GENDER,ADDR1,CITY,[STATE],ZIP,EMAIL,
				  PHONE_HOME,PHONE_WORK,NO_DEP,REL,MBR_ST,TERM_DT,DT_UPDT )
				SELECT
					i.SSN,g.GroupType AS GRP_TYPE, i.RCD_TYPE,i.MBR_ID,i.SUB_ID,i.DEP_SSN,i.LAST_NAME,
					i.FIRST_NAME,i.MI,i.DOB,i.GRP_ID,i.[PLAN],i.COV,i.EFF_DT,i.PREX_DT,
					i.GENDER,i.ADDR1,i.CITY,i.[STATE],i.ZIP,i.EMAIL,i.PHONE_HOME,
					i.PHONE_WORK,i.NO_DEP,i.REL,i.MBR_ST,i.TERM_DT,i.DT_UPDT
				FROM
					tpa_data_exchange AS i
				INNER JOIN tblGrp AS g ON i.GRP_ID = g.GroupID
				WHERE
					( i.RCD_TYPE = 'S' )
					AND ( g.GRCancelled = 0 )
					AND ( g.GroupType = 4 );
		
		/*  update EIMBRID on tpa_data_exchange_sub  */
		--SELECT  @LastOperation = 'populate tpa_data_exchange_sub'
		--UPDATE tpa_data_exchange_sub
		--SET MBR_ID = SSN + '00'

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
EXEC sp_addextendedproperty N'Purpose', N'Imports subscriber data into tpa subscriber table...', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_tpa_import_sub', NULL, NULL
GO
