SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_Agent_Customer_Indiv]
with schemabinding
AS
SELECT ia.AgentId
	, ic.CustomerKey
	, ic.CustomerName
	, ic.TerritoryKey
	, ic.CustomerAddress1
	, ic.CustomerAddress2
	, ic.CustomerCity
	, ic.CustomerState
	, ic.CustomerZipCode
	, ic.ContactName
	, ic.EmailAddress
	, ic.ContactPhone
	, ic.TelexNumber
	, ic.CustomerClassKey
	, ic.LocationKey
	, ic.CreditHold
	, ic.Spare
	, ic.Spare2
	, ic.Spare3
FROM dbo.tblIndivAgt ia
INNER JOIN dbo.vw_IndividualCustomer ic
	ON ia.PltCustKey = ic.CustomerKey;
GO
