SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[udf_GetNextSysDocId]()

RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar INTEGER

	-- Add the T-SQL statements to compute the return value here
    SELECT  @ResultVar = ( SELECT   NextSysDocId
                           FROM     dbo.ARNEXTSY_local ans
                         )
    SET @ResultVar = @ResultVar + 1  
    
    --EXEC dbo.usp_NextSysDocId @ResultVar    
	
	-- Return the result of the function
	RETURN @ResultVar
END

GO
