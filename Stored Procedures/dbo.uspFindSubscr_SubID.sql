SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[uspFindSubscr_SubID]
@SubID nvarchar(8), @FoundSubscr int OUTPUT 

AS

SELECT @FoundSubscr = Count(tblSubscr.SubID)
FROM tblSubscr
WHERE (((tblSubscr.SubID)= @SubID ))

GO
