SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetSubID]()
RETURNS INT
AS
	
	BEGIN
		DECLARE @SubscriberID varchar(8)
		SELECT @SubscriberID = ( SELECT CAST(CAST(MAX(SubID) AS int) + 1 AS VARCHAR(8)) FROM dbo.tblSubscr )
		RETURN @SubscriberID
	END
GO
