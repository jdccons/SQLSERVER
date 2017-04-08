SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_Group_Coverage_Tiers]
AS
    SELECT
        GroupID, COUNT(CoverID) TierCnt
    FROM
        ( SELECT
            GroupID, CoverID
          FROM
            dbo.tblRates
          GROUP BY
            GroupID, CoverID
          HAVING
            GroupId <> '' ) cid
    GROUP BY
        GroupID

GO
