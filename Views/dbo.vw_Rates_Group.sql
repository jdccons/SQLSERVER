SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_Rates_Group]
AS   
SELECT
g.GroupID, r.PlanID, p.PlanDesc, c.CoverID, c.CoverDescr, g.GRName, r.RateID, r.Rate
FROM
tblGrp AS g
INNER JOIN tblRates AS r
    ON g.GroupID = r.GroupID
INNER JOIN tblPlans AS p
    ON r.PlanId = p.PlanId
INNER JOIN tblCoverage AS c
    ON r.CoverID = c.CoverID
GO
