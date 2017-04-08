SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_WriteStringToFile]
 (
@String VARCHAR(MAX), --8000 in SQL Server 2000
@Path VARCHAR(255),
@Filename VARCHAR(100)

--
)
AS
DECLARE  @objFileSystem INT
        ,@objTextStream INT,
		@objErrorObject INT,
		@strErrorMessage VARCHAR(1000),
	    @Command VARCHAR(1000),
	    @hr INT,
		@fileAndPath VARCHAR(80)

SET NOCOUNT ON

SELECT @strErrorMessage='opening the File System Object'
EXECUTE @hr = sp_OACreate  'Scripting.FileSystemObject' , @objFileSystem OUT

SELECT @FileAndPath=@path+'\'+@filename
IF @HR=0 SELECT @objErrorObject=@objFileSystem , @strErrorMessage='Creating file "'+@FileAndPath+'"'
IF @HR=0 EXECUTE @hr = sp_OAMethod   @objFileSystem   , 'CreateTextFile'
	, @objTextStream OUT, @FileAndPath,2,True

IF @HR=0 SELECT @objErrorObject=@objTextStream, 
	@strErrorMessage='writing to the file "'+@FileAndPath+'"'
IF @HR=0 EXECUTE @hr = sp_OAMethod  @objTextStream, 'Write', NULL, @String

IF @HR=0 SELECT @objErrorObject=@objTextStream, @strErrorMessage='closing the file "'+@FileAndPath+'"'
IF @HR=0 EXECUTE @hr = sp_OAMethod  @objTextStream, 'Close'

IF @hr<>0
	BEGIN
	DECLARE 
		@Source VARCHAR(255),
		@Description VARCHAR(255),
		@Helpfile VARCHAR(255),
		@HelpID INT
	
	EXECUTE sp_OAGetErrorInfo  @objErrorObject, 
		@source OUTPUT,@Description OUTPUT,@Helpfile OUTPUT,@HelpID OUTPUT
	SELECT @strErrorMessage='Error whilst '
			+COALESCE(@strErrorMessage,'doing something')
			+', '+COALESCE(@Description,'')
	RAISERROR (@strErrorMessage,16,1)
	END
EXECUTE  sp_OADestroy @objTextStream
EXECUTE sp_OADestroy @objFileSystem

GO
