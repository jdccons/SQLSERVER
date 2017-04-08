SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[uspGetPlanName]
@SSN nvarchar(9)

AS

SELECT RTrim(LTrim(tblPlans.PlanDesc)) As PlanName
FROM tblSubscr INNER JOIN
tblPlans ON tblSubscr.PlanID = tblPlans.PlanID
WHERE (((tblSubscr.SubSSN) = @SSN))

GO
