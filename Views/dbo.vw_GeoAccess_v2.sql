SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_GeoAccess_v2]
AS
    SELECT  x.SubID ,
            x.SubZip ,
            x.Miles ,
        /*x.SubLong ,
        x.SubLat ,
        x.DentLong ,
        x.DentLat,
        s.SubSSN ,
        s.SUB_LUname ,
        s.SubCity ,
        s.SubState ,
        s.SubZip ,*/
            x.DentKeyID ,
            d.Dent_LUName ,
            d.DentCity ,
            d.DentState ,
            d.DentZip ,
            CASE WHEN DentSpecialty = 'GEN' THEN '1'
                 WHEN DentSpecialty = 'GEN1' THEN '1'
                 WHEN DentSpecialty = 'ORT' THEN '2'
                 ELSE '3'
            END SpecID
		
        /*,
        ds.SPECIALITYdesc SpecDesc*/
    FROM    Distances AS x --INNER JOIN tblSubscr AS s ON x.SubID = s.SubID
            INNER JOIN tblDentist AS d ON x.DentKeyID = d.DentKeyID
            INNER JOIN tblDentistSpec AS ds ON d.DentSpecialty = ds.SPECIALTYID;

GO
