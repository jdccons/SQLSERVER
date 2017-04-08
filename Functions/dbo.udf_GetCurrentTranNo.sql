SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE FUNCTION [dbo].[udf_GetCurrentTranNo]()

RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar VARCHAR(6)

	-- Add the T-SQL statements to compute the return value here
    SELECT  @ResultVar = (
                           SELECT   r9.NextTransaction
                           FROM     ARONE_R9_local r9
                           WHERE    r9.R9Key = 'R9'
                         )	
	-- Return the result of the function
	RETURN @ResultVar
END


GO
