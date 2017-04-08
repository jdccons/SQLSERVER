SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vw_IndividualCustomer]
WITH SCHEMABINDING 
AS
    SELECT  CAST(s.PltCustKey AS NVARCHAR(5)) CustomerKey ,
            UPPER(CAST(RTRIM(COALESCE(NULLIF(RTRIM(s.SubLastName), N'') + ', ', N'')
                      + COALESCE(NULLIF(RTRIM(s.SubFirstName), N'') + ' ', N'')
                      + COALESCE(s.SubMiddleName, N'')) AS NVARCHAR(50))) CustomerName ,
            ISNULL(s.SubGeoID, '') TerritoryKey ,
            ISNULL(s.SubStreet1, '') CustomerAddress1 ,
            ISNULL(s.SubStreet2, '') CustomerAddress2 ,
            ISNULL(s.SubCity, '') CustomerCity ,
            ISNULL(s.SubState, '') CustomerState ,
            ISNULL(s.SubZip, '') CustomerZipCode ,
            UPPER(s.SUB_LUname) ContactName ,
            COALESCE(s.Email, s.SubEmail, '') EmailAddress ,
            ISNULL(s.SubPhoneHome, '') ContactPhone ,
            '' TelexNumber ,
            s.SubGroupID Rsrv2 ,
            'INDIV' CustomerClassKey ,
            '' LocationKey ,
            CASE WHEN s.SubCancelled = 1 THEN 'N'
                 WHEN s.SubCancelled = 3 THEN 'Y'
                 ELSE 'Y'
            END CreditHold ,
            s.SubId Spare ,
            s.SubSSN Spare2 ,
            'Individual' Spare3
    FROM    dbo.tblSubscr s
    WHERE   s.SubStatus = 'INDIV';
















GO
