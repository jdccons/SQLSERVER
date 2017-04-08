SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_EDI_MissingRates]
AS
    SELECT
        eas.SubSSN, 
        eas.SubID, 
        eas.wSubID, 
        eas.SubGroupID,
        eas.PlanID AS eas_PlanID, 
        rg.CoverID,
        rg.PlanID AS rg_PlanID, 
        rg.GRname,
        rg.CoverDescr, 
        rg.Rate
    FROM
        tblEDI_App_Subscr AS eas
        INNER JOIN dbo.vw_Rates_Group AS rg
            ON eas.SubGroupID = rg.GroupID
    WHERE
        ( eas.PlanID IS NULL )
        OR ( eas.PlanID = 0 )
GO
