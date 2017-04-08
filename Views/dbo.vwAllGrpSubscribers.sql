SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwAllGrpSubscribers]
AS
    SELECT SubGroupID, SubSSN, SubLastName, SubFirstName, PlanID, CoverID,
            DepCnt AS DepCnt, SubZip
        FROM dbo.tblSubscr
        WHERE ( SubStatus <> 'PENDG' )
            AND ( SubStatus = 'GRSUB' )
    

GO
