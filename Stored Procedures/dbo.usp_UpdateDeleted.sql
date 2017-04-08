SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_UpdateDeleted]
@DateDeleted AS DATETIME = NULL, @UserName AS NVARCHAR(50) = NULL,
@ReturnParm VARCHAR(255) OUTPUT
AS /* =============================================
		Object:			usp_UpdateDeleted
		Author:			John Criswell
		Version:		1
		Create date:	2016-12-02	 
		Description:	Updates pending deletion subscribers
						to deleted
						 
						
								
		Change Log:
		--------------------------------------------
		Change Date		Version		Changed by		Reason
		2016-12-02		1.0			J Criswell		Created
		
	============================================= */
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

    SELECT  @LastOperation = 'update pending deletions if no date deleted provided'
    IF @DateDeleted IS NOT NULL OR @DateDeleted != ''
	BEGIN
        UPDATE
            s
        SET 
			SubCancelled = 3, 
			flag = 0, 
			TransactionType = 'DELETED',
            DateDeleted = @DateDeleted,
			UserName = @UserName,
			User01 = 'updated pending deletion to SubCancelled = 3',
			User02 = '',
			User04 = GETDATE()
        FROM
            tblSubscr s
        INNER JOIN vw_PendingDeletions pd ON s.SubSSN = pd.SubSSN
        WHERE
            pd.Flag = 1;
    END
	SELECT  @LastOperation = 'update pending deletions if date deleted provided'
    UPDATE
        s
    SET 
		SubCancelled = 3, 
		flag = 0, 
		TransactionType = 'DELETED',
		UserName = @UserName,
		User01 = 'updated pending deletion to SubCancelled = 3',
		User02 = '',
		User04 = GETDATE()
    FROM
        tblSubscr s
    INNER JOIN vw_PendingDeletions pd ON s.SubSSN = pd.SubSSN
    WHERE
        pd.Flag = 1;
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
