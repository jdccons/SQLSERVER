SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[udf_GetLU_Name]
    (
      @LastName AS NVARCHAR(50) ,
      @FirstName AS NVARCHAR(50) ,
      @MiddleInit AS NVARCHAR(10)
    )
RETURNS NVARCHAR(110)
AS 

    BEGIN
        RETURN
		(
		SELECT UPPER(CAST(RTRIM(COALESCE(NULLIF(RTRIM(@LastName),
                                                              N'') + ', ', N'')
                                                + COALESCE(NULLIF(RTRIM(@FirstName),
                                                              N'') + ' ', N'')
                                                + COALESCE(@MiddleInit, N'')) AS NVARCHAR(110)))
		)
    END;

GO
