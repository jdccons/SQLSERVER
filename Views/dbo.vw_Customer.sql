SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vw_Customer]
 
AS
    SELECT  CustomerKey ,
            CustomerName ,
            TerritoryKey ,
            CustomerAddress1 ,
            CustomerAddress2 ,
            CustomerCity ,
            CustomerState ,
            CustomerZipCode ,
            ContactName ,
            EmailAddress ,
            ContactPhone ,
            TelexNumber ,
            CustomerClassKey ,
            LocationKey ,
            CreditHold ,
            Spare ,
            Spare2 ,
            Spare3
    FROM    dbo.vw_IndividualCustomer
    UNION
    SELECT  CustomerKey ,
            CustomerName ,
            TerritoryKey ,
            CustomerAddress1 ,
            CustomerAddress2 ,
            CustomerCity ,
            CustomerState ,
            CustomerZipCode ,
            ContactName ,
            EmailAddress ,
            ContactPhone ,
            TelexNumber ,
            CustomerClassKey ,
            LocationKey ,
            CreditHold ,
            Spare ,
            Spare2 ,
            Spare3
    FROM    dbo.vw_GroupCustomer;








GO
