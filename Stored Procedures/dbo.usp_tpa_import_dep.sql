SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[usp_tpa_import_dep]
@ReturnParm VARCHAR(255) OUTPUT 
AS
/* =============================================
	Object:			usp_tpa_import_dep
	Author:			John Criswell
	Create date:	10/17/2015 
	Description:	inserts dependent records into tpa_data_exchange_dep
								
							
	Change Log:
	--------------------------------------------
	Change Date	Version		Changed by		Reason
	2015-10-17	1.0			J Criswell		Created
	2015-11-14	2.0			J Criswell		Added FK
	2016-02-29	3.0			J Criswell		Removed code to create MBR_ID
	
============================================= */
/*  declarations  */ 
SET NOCOUNT ON;
SET XACT_ABORT ON;
    DECLARE @LastOperation VARCHAR(128) ,
        @ErrorMessage VARCHAR(8000) ,
        @ErrorSeverity INT ,
        @ErrorState INT

BEGIN TRY
   BEGIN TRANSACTION


		-- copy dependents from data exchange table to dependent data exchange table
		SELECT  @LastOperation = 'truncate tpa_data_exchange_dep'
		DELETE FROM tpa_data_exchange_dep

        SELECT
            @LastOperation = 'populate tpa_data_exchange_dep';
		INSERT  INTO tpa_data_exchange_dep
				( GRP_TYPE,RCD_TYPE,SSN,SUB_ID,MBR_ID,DEP_SSN,LAST_NAME,FIRST_NAME,MI,
				  DOB,GRP_ID,EFF_DT,PREX_DT,GENDER,REL,CARD_PRT,CARD_PRT_DT,MBR_ST,
				  DT_UPDT )
				SELECT
					g.GroupType AS GRP_TYPE,r.RCD_TYPE,r.SSN,r.SUB_ID,r.MBR_ID,
					r.DEP_SSN,r.LAST_NAME,r.FIRST_NAME,r.MI,r.DOB,r.GRP_ID,r.EFF_DT,
					r.PREX_DT,r.GENDER,r.REL,r.CARD_PRT,r.CARD_PRT_DT,r.MBR_ST,
					r.DT_UPDT
				FROM
					tpa_data_exchange AS r
				INNER JOIN tblGrp AS g ON r.GRP_ID = g.GroupID
				WHERE
					( g.GroupType = 4 )
					AND ( r.RCD_TYPE = N'D' );

			
		/*  update EIMBRID on tpa_data_exchange_dep  */
        --SELECT
        --    @LastOperation = 'create unique EIMBRID for each dependent';
        --UPDATE
        --    d
        --SET
        --    MBR_ID = m.MBR_ID
        --FROM
        --    tpa_data_exchange_dep d
        --    INNER JOIN ( SELECT
        --                    ID ,
        --                    SSN + '0' + CONVERT(NVARCHAR(2), RANK() OVER ( PARTITION BY SSN ORDER BY ISNULL(DOB, '1901-01-01 00:00:00'), LAST_NAME, FIRST_NAME )) MBR_ID
        --                 FROM
        --                    tpa_data_exchange_dep
        --               ) m
        --        ON d.ID = m.ID;
				
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
EXEC sp_addextendedproperty N'Purpose', N'Imports dependent data from tpa_data_exchange into tpa_data_exchange_dep...', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_tpa_import_dep', NULL, NULL
GO
