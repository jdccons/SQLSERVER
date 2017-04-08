SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[udf_GetNextTranNo]()

RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar INTEGER

	-- Add the T-SQL statements to compute the return value here
    SELECT  @ResultVar = (
                           SELECT   r9.NextTransaction
                           FROM     ARONE_R9_local r9
                           WHERE    r9.R9Key = 'R9'
                         )	
                         
    SET @ResultVar = @ResultVar + 1  
	
	-- Return the result of the function
	RETURN @ResultVar
END



GO
