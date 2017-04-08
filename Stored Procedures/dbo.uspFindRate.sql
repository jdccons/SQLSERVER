SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO


/****** Object:  Stored Procedure dbo.uspFindRate    Script Date: 11/3/2006 11:55:40 AM ******/
/* stored procedure changed to add a parameter @PlanID -- 11/01/207 */
CREATE PROCEDURE [dbo].[uspFindRate]

@GroupID nvarchar(5),
@CoverID int,
@PlanID int

 AS

Select RateID, Rate FROM tblRates 
WHERE GroupID = @GroupID 
AND CoverID = @CoverID 
AND PlanID = @PlanID
GO
