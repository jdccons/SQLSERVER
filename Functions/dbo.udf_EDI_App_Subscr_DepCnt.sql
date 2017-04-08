SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		John Criswell
-- Create date: 09/26/2013
-- Description:	Returns dep cnt for a subscriber
-- =============================================
CREATE FUNCTION [dbo].[udf_EDI_App_Subscr_DepCnt]
(
	@SubSSN AS VARCHAR(9)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @DepCnt int

	-- Add the T-SQL statements to compute the return value here
     IF EXISTS ( SELECT
                    1
                 FROM
                    tblEDI_App_Subscr
                 WHERE
                    SubSSN = @SubSSN ) 
        SELECT
            @DepCnt = ( SELECT
                            COUNT(ID) AS DepCnt
                        FROM
                            tblEDI_App_Dep
                        GROUP BY
                            DepSubID
                        HAVING
                            ( DepSubID = @SubSSN ) )
     IF @DepCnt IS NULL 
        BEGIN
            SET @DepCnt = 0 
        END

	-- Return the result of the function
	RETURN @DepCnt

END


GO
