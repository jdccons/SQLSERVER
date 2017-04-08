SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[uspDelGrpSubscr]
		(
			@SSN nvarchar(9), 
			@UserName nvarchar(20)
		)
AS
/* ====================================================================================
	Object:			uspDelGrpSubscr			
	Author:			John Criswell
	Create date:	2016-03-13	 
	Description:	Deletes group subscriber and dependents by updated cancelled value
	Called from:	frmGrpSubscr		
							
	Change Log:
	-----------------------------------------------------------------------------------
	Change Date		Versions	Changed by		Reason
	2016-03-13		2016-03-13	J Criswell		Created
	
	
======================================================================================= */ 
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
			SET @LastOperation = 'delete group subscriber'

			UPDATE tblSubscr
			SET SubCancelled = 3, TransactionType = 'DELETED', DateDeleted= GetDate(), UserName = @UserName, User01 = 'uspDelGrpSubscr'
			WHERE SubSSN = @SSN;


			SET @LastOperation = 'delete group subscribers dependents'

			IF EXISTS (SELECT 1 from tblDependent WHERE DepSubID = @SSN)
			UPDATE tblDependent
			SET DepCancelled = 3, TransactionType = 'DELETED', DateDeleted= GetDate(), UserName = @UserName, User01 = 'uspDelGrpSubscr'
			WHERE DepSubID = @SSN;



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
EXEC sp_addextendedproperty N'Purpose', N'Deletes a group subscriber and their dependents, if any.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspDelGrpSubscr', NULL, NULL
GO
