SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		John Criswell
-- Create date: 
-- Description:	
-- rules:
--		if dep count = 1 and dep > 18, then Emp + One
--		if dep count >= 1 and all deps <= 18, then Emp + Child (depends on group type)
--		if dep count > 1 and age of one dep > 18 then Family
--		else Emp Only
--		
-- =============================================

CREATE FUNCTION [dbo].[udf_Cov]
(
	-- Add the parameters for the function here
	@SubSSN AS VARCHAR(9), @TierCnt INT
)
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @DepCnt int
	DECLARE @DepAdult BIT
	DECLARE @CoverID INT
	
	SET @CoverID = 0
	
	-- does the subscriber have any dependents
    SET @DepCnt = 0
    IF EXISTS ( SELECT
                    1
                FROM
                    dbo.tpa_data_exchange
                WHERE
                    SSN = @SubSSN
                    AND RCD_TYPE = 'D' )
     
     -- get the count of dependents               
     SELECT @DepCnt = ( SELECT
                            COUNT(ID) AS DepCnt
                        FROM
                            dbo.tpa_data_exchange
                        WHERE RCD_TYPE = 'D'
                        GROUP BY
                            SSN
                        HAVING
                            ( SSN = @SubSSN ) )

	-- is dependent adult?
	SET @DepAdult = 0
    IF EXISTS ( SELECT
                    1
                FROM
                    dbo.tpa_data_exchange
                WHERE
                    SSN = @SubSSN
                    AND RCD_TYPE = 'D'
                    AND dbo.fAgeCalc(dob) >= 18 ) 
     SET @DepAdult = 1
   
	-- emp plus one (child)
	IF @DepCnt = 1
		AND @DepAdult = 0 
		SET @CoverID = 2
	

	-- emp plus one (adult)
    IF @DepCnt = 1
        AND @DepAdult = 1 
        SET @CoverID = 2
    
        
    -- emp + children
	-- if dep count > 1 and all deps <= 18 then Emp + Children
	-- three tier case
    IF @DepCnt > 1
        AND @DepAdult = 0
        AND @TierCnt = 3 
        SET @CoverID = 4
   
        
    -- four tier case
    IF @DepCnt > 1
        AND @DepAdult = 0
        AND @TierCnt = 4 
        SET @CoverID = 3
    
        
    -- family
	-- if dep count > 1 and age of one dep > 18 then Family
	IF @DepCnt > 1
		AND @DepAdult = 1
		SET @CoverID = 4
    
    
	-- single
	-- else EmpOnly
    IF @DepCnt = 0 
        SET @CoverID = 1
    
    RETURN @CoverID
END




GO
