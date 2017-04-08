SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[fnCalcDistance]
    (
      @Lat1 DECIMAL(8, 4) ,
      @Long1 DECIMAL(8, 4) ,
      @Lat2 DECIMAL(8, 4) ,
      @Long2 DECIMAL(8, 4)
    )
RETURNS DECIMAL(8, 4)
AS 
    BEGIN
        DECLARE @d DECIMAL(28, 10)
-- Convert to radians
        SET @Lat1 = @Lat1 / 57.2958
        SET @Long1 = @Long1 / 57.2958
        SET @Lat2 = @Lat2 / 57.2958
        SET @Long2 = @Long2 / 57.2958
-- Calc distance
        SET @d = ( SIN(@Lat1) * SIN(@Lat2) ) + ( COS(@Lat1) * COS(@Lat2)
                                                 * COS(@Long2 - @Long1) )
-- Convert to miles
        IF @d <> 0 
            BEGIN
                SET @d = 3958.75 * ATAN(SQRT(1 - POWER(@d, 2)) / @d);
            END
        RETURN @d
    END 
GO
