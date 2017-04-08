SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwRates]
AS
SELECT LTRIM(RTRIM(tblRates.GroupID)) AS GroupID
, tblRates.PlanID
, tblPlans.PlanDesc
, tblRates.CoverID
, tblCoverage.COVERcode
, tblCoverage.COVERdescr
, tblRates.RateID
, tblRates.Rate
FROM tblCoverage INNER JOIN
tblRates ON tblCoverage.CoverID = tblRates.CoverID INNER JOIN
tblPlans ON tblRates.PlanID = tblPlans.PlanID
GO
