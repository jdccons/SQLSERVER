SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO


/****** Object:  Stored Procedure dbo.uspMbrID_Subscr    Script Date: 4/22/2009 10:54:39 AM ******/
--this stored procedure will record the MemberID
--that is assigned to a subscriber

CREATE PROCEDURE [dbo].[uspMbrID_Subscr]

@SSN nvarchar(9),
@SubscriberID nvarchar(11)

AS

UPDATE tblSubscr
SET EIMBRID = @SubscriberID
WHERE SubSSN = @SSN



GO
