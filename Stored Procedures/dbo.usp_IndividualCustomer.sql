SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_IndividualCustomer] 

					(
					@UserName NVARCHAR(20)	
					)
AS
/* ================================================================
  Object:			usp_IndividualCustomer
  Author:			John Criswell
  Version:			2
  Create date:		9/1/2014	 
  Description:		sync vw_IndivudalCustomer to ARCUST_local		
					
					
  Parameters:		@UserName
  Where Used:		frmIndivSubscr, frmInvIndiv
					
				
  Change Log:
  -----------------------------------------------------------------
  Change Date		Version		Changed by		Reason
  2014-09-01		1.0			J Criswell		Created
  2015-12-29		2.0			J Criswell		Added UserName and error
												handling to the procedure
	
	
=================================================================== */
/*  ------------------  declarations  --------------------  */
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @LastOperation VARCHAR(128)
	, @ErrorMessage VARCHAR(8000)
	, @ErrorSeverity INT
	, @ErrorState INT

/*  ------------------------------------------------------  */
BEGIN TRY
	BEGIN TRANSACTION

	/*  update the individual customers  */
	SET @LastOperation = 'update the individual customers'

	UPDATE arc
	SET CustomerName = c.CustomerName
		, TerritoryKey = c.TerritoryKey
		, CustomerAddress1 = c.CustomerAddress1
		, CustomerAddress2 = c.CustomerAddress2
		, CustomerCity = c.CustomerCity
		, CustomerState = c.CustomerState
		, CustomerZipCode = c.CustomerZipCode
		, ContactName = c.ContactName
		, EmailAddress = c.EmailAddress
		, ContactPhone = c.ContactPhone
		, TelexNumber = c.TelexNumber
		, CustomerKey = c.CustomerKey
		, CustomerClassKey = c.CustomerClassKey
		, CreditHold = c.CreditHold
		, LocationKey = c.LocationKey
		--, Spare = c.Spare  SubID (join is on SubID)
		, Spare2 = c.Spare2
		, Spare3 = c.Spare3
		, RecUserID = @UserName
		, RecDate = CONVERT(VARCHAR(10), GETDATE(), 101)
		, RecTime = LTRIM(RIGHT(CONVERT(VARCHAR(20), GETDATE(), 100), 7
			))
	FROM ARCUST_local arc
	INNER JOIN vw_IndividualCustomer c
		ON arc.Spare = c.Spare
	WHERE c.CustomerClassKey = 'INDIV'

	/*  inserts new records for the individual customers */
	SET @LastOperation = 'inserts new records for the individual customers'
	INSERT INTO ARCUST_local (
		CustomerKey
		, CustomerName
		, CustomerAddress1
		, CustomerAddress2
		, CustomerAddress3
		, CustomerCity
		, CustomerState
		, CustomerZipCode
		, ContactName
		, EmailAddress
		, ContactPhone
		, TelexNumber
		, CustomerClassKey
		, CreditHold
		, LocationKey
		, Spare 
		, Spare2
		, Spare3
		, RecUserID
		, RecDate
		, RecTime
		)
	SELECT c.CustomerKey
		, c.CustomerName
		, c.TerritoryKey
		, c.CustomerAddress1
		, c.CustomerAddress2
		, c.CustomerCity
		, c.CustomerState
		, c.CustomerZipCode
		, c.ContactName
		, c.EmailAddress
		, c.ContactPhone
		, c.TelexNumber
		, c.CustomerClassKey
		, c.CreditHold
		, c.LocationKey
		, c.Spare 
		, c.Spare2
		, c.Spare3
		, @UserName RecUserID
		, CONVERT(VARCHAR(10), GETDATE(), 101) RecDate
		, LTRIM(RIGHT(CONVERT(VARCHAR(20), GETDATE(), 100), 7)) 
		RecTime
	FROM vw_Customer AS c
	LEFT OUTER JOIN ARCUST_local AS arc
		ON arc.Spare = c.Spare
	WHERE c.CustomerClassKey = 'INDIV'
		AND (arc.Spare IS NULL)

	COMMIT TRANSACTION

	RETURN 1
END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK

	SELECT @ErrorMessage = ERROR_MESSAGE() + ' Last Operation: ' + 
		@LastOperation
		, @ErrorSeverity = ERROR_SEVERITY()
		, @ErrorState = ERROR_STATE()

	RAISERROR (
			@ErrorMessage
			, @ErrorSeverity
			, @ErrorState
			)

	EXEC usp_CallProcedureLog @ObjectID = @@PROCID
		, @AdditionalInfo = @LastOperation;

	RETURN 0
END CATCH;



GO
EXEC sp_addextendedproperty N'Purpose', N'sync vw_IndividualCustomer to ARCUST_local', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_IndividualCustomer', NULL, NULL
GO
