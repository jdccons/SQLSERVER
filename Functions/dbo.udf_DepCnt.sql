SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE FUNCTION [dbo].[udf_DepCnt]
(
	@SubSSN AS VARCHAR(9)
)
RETURNS INTEGER
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar INTEGER

	-- Add the T-SQL statements to compute the return value here
    SELECT  @ResultVar = (
                           SELECT   COUNT(ID) DepSubID
                           FROM     tblDependent
                           WHERE    DepSubId = @SubSSN
                           GROUP BY DepSubID
                         )	
	-- Return the result of the function
	RETURN @ResultVar
END


GO
