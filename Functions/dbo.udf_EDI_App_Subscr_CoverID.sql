SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		John Criswell
-- Create date: 09/26/2013
-- Description:	Assigns correct coverage to subscriber
-- rules:
--		if dep count = 1, then Emp + 1 and dep > 18, then Emp + One
--		if dep count >= 1 and all deps <= 18, then Emp + Child (depends on group type)
--		if dep count > 1 and age of one dep > 18 then Family
--		else EmpOnly
--		
-- =============================================

CREATE FUNCTION [dbo].[udf_EDI_App_Subscr_CoverID]
(
	-- Add the parameters for the function here
	@SubSSN AS VARCHAR(9), @TierCnt int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @DepCnt int
	DECLARE @DepAdult BIT
	DECLARE @CoverID INT
	
	SET @CoverID = 0
	-- Add the T-SQL statements to compute the return value here
	-- dependents?
    SET @DepCnt = 0
    IF EXISTS ( SELECT
                    1
                FROM
                    tblEDI_App_Dep
                WHERE
                    DepSubID = @SubSSN ) 
        SELECT @DepCnt = ( SELECT
                            COUNT(ID) AS DepCnt
                        FROM
                            tblEDI_App_Dep
                        GROUP BY
                            DepSubID
                        HAVING
                            ( DepSubID = @SubSSN ) )

	-- is dependent adult?
	SET @DepAdult = 0
    IF EXISTS ( SELECT
                    DepSubID, DepSSN, ID, DepDOB, DepAge
                FROM
                    tblEDI_App_Dep
                WHERE
                    DepSubID = @SubSSN
                    AND DepAge >= 18 ) 
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
