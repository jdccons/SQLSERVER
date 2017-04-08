SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_CardMemIndivWeb]
AS
    SELECT  s.SubSSN ,
            s.SubID ,
            s.EIMBRID ,
            s.SubGroupID ,
            s.SubLastName ,
            s.SubFirstName ,
            s.SubMiddleName ,
            s.SubStreet1 ,
            s.SubStreet2 ,
            s.SubCity ,
            s.SubState ,
            s.SubZip ,
            s.SubEffDate ,
            s.SubExpDate ,
            s.SubContBeg ,
            s.SubContEnd ,
            s.SubStatus
    FROM    dbo.tblSubscr s
            INNER JOIN dbo.tmpEDI_Rpt r ON s.SubGroupID = r.GroupID
                                           AND s.SubSSN = r.SubSSN;
GO
