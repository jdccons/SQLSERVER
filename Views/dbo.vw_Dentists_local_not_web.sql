SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vw_Dentists_local_not_web]
AS
SELECT
    dl.DentKeyID, dl.DentFirst, dl.DentLast, dl.DentStreet1, dl.DentStreet2,
    dl.DentCity, dl.DentState, dl.DentZip, dl.DentPhoneOffice, dl.DentStatus
FROM
    [TRACENTRMTSRV].QCD.dbo.tblDentists AS dr
    RIGHT OUTER JOIN tblDentist AS dl
        ON dr.DentKeyID = dl.DentKeyID
WHERE
    ( dr.DentKeyID IS NULL )



GO
