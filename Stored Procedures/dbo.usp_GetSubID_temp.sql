SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_GetSubID_temp]
	@NextSubID NVARCHAR(8) OUTPUT
AS
SET NOCOUNT ON
BEGIN

	SELECT @NextSubID = CAST(CAST(LastSubID AS int) + 1 AS VARCHAR(8)) FROM dbo.SubIDControl_temp;
	
	UPDATE dbo.SubIDControl_temp
	SET LastSubID = @NextSubID;
	
END


GO
