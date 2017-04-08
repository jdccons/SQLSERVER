SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--exec usp_CommissionCreateBills_csv '2017-02-01', 'John Criswell', '\\sqlserver\SQLServerData\Microsoft SQL Server\MSSQL11.MSSQLSERVER\SSIS\QuickBooks\CommissionBills', 'CommissionBills'

CREATE PROCEDURE [dbo].[usp_CommissionCreateBills_csv]
		(
		@CommissionDate			datetime,
		@UserName				nvarchar(20),
		@File					nvarchar(100)
		)
AS
/* ======================================================================================
	Object:			usp_CommissionCreateBills_csv
	Version:		1.0
	Author:			John Criswell
	Create date:	2016-01-13 
	Description:	
	
					
	Parameters:		
	Where Used:		
					
				
	Change Log:
	---------------------------------------------------------------------------------------
	Change Date		Version			Changed by		Reason
	2016-01-13		1.0				J Criswell		Created
	2017-04-07		2.0				J Criswell		Added path and file parameters	


	========================================================================================= */
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

	/* t-sql to call an SSIS package with a package variable
			Webpage with reference:
			https://www.mssqltips.com/sqlservertip/1395/pass-dynamic-parameter-values-to-sql-server-integration-services/ 
			*/
	SET @LastOperation = 'export data to csv file'

	DECLARE @cmd VARCHAR(1000);
	DECLARE @ssispath VARCHAR(1000);
	DECLARE @PackagePassword VARCHAR(20);
	--E:\Microsoft SQL Server\MSSQL11.MSSQLSERVER\SSIS\QuickBooks\
	SET @ssispath = '\\sqlserver\SQLServerData\Microsoft SQL Server\MSSQL11.MSSQLSERVER\SSIS\QuickBooks\CommissionBills.dtsx';
	SET @PackagePassword = 'd!7kZ[Cs8Qsw~7H';

	SELECT @cmd = 'dtexec /de ' + '"' + @PackagePassword + '"' + ' /F "' + @ssispath + '"'
	SELECT @cmd = @cmd + ' /SET \Package.Variables[User::FileName].Properties[Value];"' + @File + '"'
	SELECT @cmd = @cmd + ' /SET \Package.Variables[User::CommissionDate].Properties[Value];"' + convert(varchar(12),@CommissionDate) + '"'
	SELECT @cmd = @cmd + ' /SET \Package.Variables[User::UserName].Properties[Value];"' + @UserName + '"'
	EXEC master..xp_cmdshell @cmd;

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
EXEC sp_addextendedproperty N'Purpose', N'Creates commission bill interface file for QuickBooks...', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_CommissionCreateBills_csv', NULL, NULL
GO
