SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[udf_ConvertDate] ( @Input NCHAR(8) )
RETURNS DATETIME
AS 
    BEGIN

		DECLARE @TextDate VARCHAR(10)
		SET @TextDate = SUBSTRING(@Input,5,4) + '-' + SUBSTRING(@Input,1,2) + '-' + SUBSTRING(@Input,3,2) + ' 00:00:00'

        RETURN
        (        
        SELECT CONVERT(DATETIME, @TextDate,101)
		)

    END


GO
