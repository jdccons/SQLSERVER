SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vwRatesfrom_tblSubscr]
AS
    SELECT  dbo.tblSubscr.RateID, dbo.tblSubscr.SubGroupID,
            dbo.tblSubscr.PlanID, dbo.tblSubscr.CoverID, dbo.tblGrp.GroupType
    FROM    dbo.tblSubscr
            INNER JOIN dbo.tblGrp ON dbo.tblSubscr.SubGroupID = dbo.tblGrp.GroupID
    GROUP BY dbo.tblSubscr.RateID, dbo.tblSubscr.SubGroupID,
            dbo.tblSubscr.PlanID, dbo.tblSubscr.CoverID, dbo.tblGrp.GroupType;

GO
