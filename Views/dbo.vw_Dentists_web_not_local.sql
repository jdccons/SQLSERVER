SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vw_Dentists_web_not_local]
AS
SELECT
    dr.DentKeyID, dr.FName, dr.LName, dr.[Address], dr.Address2, dr.City, dr.Zipcode,
    dr.Specialty, dr.Phone
FROM
    [TRACENTRMTSRV].QCD.dbo.tblDentists AS dr
    LEFT OUTER JOIN tblDentist AS dl
        ON dr.DentKeyID = dl.DentKeyID
WHERE
    ( dl.DentKeyID IS NULL );




GO
