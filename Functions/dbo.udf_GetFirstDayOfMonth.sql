SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[udf_GetFirstDayOfMonth] ( @InputDate DATETIME )
RETURNS DATETIME
AS 
    BEGIN

        RETURN
        (        
        SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@InputDate)-1),@InputDate),101)
		)
    END

GO
