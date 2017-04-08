SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE FUNCTION [dbo].[udf_NO_DEP]
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
                           SELECT   COUNT(ID) NO_DEP
                           FROM     dbo.tpa_data_exchange
                           WHERE    SSN = @SubSSN
                           AND RCD_TYPE = 'D'
                           GROUP BY SSN
                         )	
	-- Return the result of the function
	RETURN @ResultVar
END



GO
