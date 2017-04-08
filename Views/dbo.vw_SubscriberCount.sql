SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_SubscriberCount]
AS
SELECT *
FROM (
	SELECT SubSSN, gt.Description, p.PlanDesc
	FROM vwSubscribersAll s
	INNER JOIN GroupType gt ON s.GroupType = gt.GroupTypeId
	INNER JOIN tblPlans p ON s.PlanID = p.PlanID
	WHERE s.GroupType = 4
	
	UNION
	
	SELECT SubSSN, gt.Description, p.PlanDesc
	FROM vwSubscribersAll s
	INNER JOIN GroupType gt ON s.GroupType = gt.GroupTypeId
	INNER JOIN tblPlans p ON s.PlanID = p.PlanID
	WHERE s.GroupType = 1
	
	UNION
	
	SELECT SubSSN, gt.Description, p.PlanDesc
	FROM vwSubscribersAll s
	INNER JOIN GroupType gt ON s.GroupType = gt.GroupTypeId
	INNER JOIN tblPlans p ON s.PlanID = p.PlanID
	WHERE s.GroupType = 9
	) AS s
PIVOT(Count(SubSSN) FOR [PlanDesc] IN (
			[Red],
			[White],
			[Blue],
			[Red Plus],
			[QCD Only]
			)) AS p

GO
