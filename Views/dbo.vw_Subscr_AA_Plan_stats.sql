SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Subscr_AA_Plan_stats]
AS
(
		SELECT *
		FROM (
			SELECT s.SubSSN, g.GroupID, p.PlanDesc
			FROM tblSubscr s
			INNER JOIN tblGrp g ON s.SubGroupID = g.GroupID
			INNER JOIN tblPlans p ON s.PlanID = p.PlanID
				AND g.GRCancelled = 0
			WHERE g.GroupType = 4
				AND g.GRCancelled = 0
				AND s.SubCancelled = 1
			) AS g
		PIVOT(count(g.SubSSN) FOR g.PlanDesc IN (
					[Red],
					[White],
					[Blue],
					[Red Plus]
					)) AS pvt
		);

GO
