SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vwSubscribersAll]
AS
    SELECT  s.SubGroupID ,
            g.GroupType ,
            s.SubStatus ,
            s.SubSSN ,
            s.SubLastName ,
            s.SubFirstName ,
            s.PlanID ,
            s.CoverID ,
            s.SubCity ,
            s.SubState ,
            s.SubZip
    FROM    dbo.tblSubscr AS s
            INNER JOIN dbo.tblGrp AS g ON s.SubGroupID = g.GROUPid
    WHERE   ( g.GRcancelled = 0 )
            AND ( s.SubCancelled = 1
                  OR s.SubCancelled IS NULL
                );
GO
