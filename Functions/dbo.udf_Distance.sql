SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		John Criswell
-- Create date: 2/24/2014
-- Description:	
-- This function calculates the distance between two points (given the
-- latitude/longitude of those points). It is used to calculate
-- the distance between two locations.
--
-- Calculates distance between two points lat1, long1 and lat2, long2;
-- uses radius of earth in kilometers or miles as an argurments
--
-- Typical radius:  3963.0 (miles) (Default if no value specified)
--                  6387.7 (km)
--
-- =============================================
CREATE FUNCTION [dbo].[udf_Distance]
    (
      @lat1 FLOAT ,
      @long1 FLOAT ,
      @lat2 FLOAT ,
      @long2 FLOAT
    )
RETURNS FLOAT
AS 
    BEGIN
		-- Declare the return variable here
        DECLARE @ResultVar FLOAT

		-- Add the T-SQL statements to compute the return value here
        DECLARE @DegToRad AS FLOAT
        DECLARE @Ans AS FLOAT
        DECLARE @Miles AS FLOAT

        SET @DegToRad = 57.29577951
        SET @Ans = 0
        SET @Miles = 0

        IF @lat1 IS NULL
        OR @lat1 = 0
        OR @long1 IS NULL
        OR @long1 = 0
        OR @lat2 IS NULL
        OR @lat2 = 0
        OR @long2 IS NULL
        OR @long2 = 0 
        BEGIN
            RETURN ( @Miles )
        END
           
		SET @Lat1 = @Lat1/@DegToRad;
		SET @Lat2 = @Lat2/@DegToRad;
		SET @Long1 = @Long1/@DegToRad;
		SET @Long2 = @Long2/@DegToRad;

		SET @Ans = (Sin(@Lat1) * Sin(@Lat2)) + (Cos(@Lat1) * Cos(@Lat2) * COS(ABS(@Long2 - @Long1)));
		IF @Ans <> 1
		BEGIN
			SET @Miles = 3958.75 * Atan(Sqrt(1 - power(@Ans, 2)) / @Ans);
		END
       	
		-- Return the result of the function
        RETURN ( @Miles )

    END


GO
