SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[usp_tpa_import_csv]
				(@User NVARCHAR(50), 
				@Path NVARCHAR(100), 
				@File NVARCHAR(50),
				@SetRtn INT=0 OUTPUT)
AS
  /* ======================================================================================
  Object:			usp_tpa_import_csv
  Version:			3.0
  Author:			John Criswell
  Create date:		2015-10-18 
  Description:		Runs SSIS package (tpa_data_exchange_import.dtsx) to import
					tpa file
					
  Parameters:		@User varchar(50) - this is the user who call the sp from the clinet
					not needed for this sp
					@Path varchar(50) - this is the path the user selected with the
					common file dialog from the client; this is where the tpa text
					file will be located
					@File varchar(50) - this is the name of the tpa incoming import file
  Where Used:		fdlgAASync	
					
				
  Change Log:
  ---------------------------------------------------------------------------------------
  Change Date		Version			Changed by		Reason
  2015-10-18		1.0				J Criswell		Created	
  2015_11_11		2.0				J Criswell		this version points to a different package
  													with a connection to the dev database instead of temp
  2015-11-18		3.0				J Criswell		Added parameters (User, Path, and File)
													these parameters are needed to support a 
													common file dialog from the client													
	
========================================================================================= */
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

	/* t-sql to call an SSIS package with a package variable
	Webpage with reference:
	https://www.mssqltips.com/sqlservertip/1395/pass-dynamic-parameter-values-to-sql-server-integration-services/ 
	*/

	
	
        DECLARE @cmd VARCHAR(1000);
        DECLARE @ssispath VARCHAR(1000);
		DECLARE @PackagePassword VARCHAR(20);
        
        SET @ssispath = '\\sql\ssis\data_exchange\tpa_data_exchange_import_dev2.dtsx';
		--\\sql\SSIS\data_exchange\
        SET @PackagePassword = 'HiRainwus304';
        
        SELECT @cmd = 'dtexec /de ' + '"' + @PackagePassword + '"' + ' /F "' + @ssispath + '"';
        SELECT @cmd = @cmd + ' /SET \Package.Variables[User::PathName].Properties[Value];"' + @Path + '"'
        SELECT @cmd = @cmd + ' /SET \Package.Variables[User::FileName].Properties[Value];"' + @File + '"'
		
        EXEC master..xp_cmdshell @cmd;
	 
		COMMIT TRANSACTION
		SELECT @SetRtn = 1
		RETURN @SetRtn		
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
		SELECT @SetRtn = 0
		RETURN @SetRtn
	END CATCH;







GO
EXEC sp_addextendedproperty N'Purpose', N'Runs SSIS package to import data from tpa...', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_tpa_import_csv', NULL, NULL
GO
