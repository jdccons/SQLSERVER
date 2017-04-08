SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[udf_GetLastDayOfMonth] ( @InputDate DATETIME )
RETURNS DATETIME
AS 
    BEGIN

        RETURN(
        SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@InputDate))),DATEADD(mm,1,@InputDate)),101) AS LastDayofMonth)

    END
GO
