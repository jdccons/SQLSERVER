SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO



/****** Object:  Stored Procedure dbo.uspMbrID_Dependent    Script Date: 4/22/2009 10:54:39 AM ******/
--this stored procedure will record the MemberID
--that is assigned to a subscriber

CREATE PROCEDURE [dbo].[uspMbrID_Dependent]

@DepID int,
@MemberID nvarchar(11)

AS

UPDATE tblDependent
SET EIMBRID = @MemberID
WHERE ID = @DepID




GO
