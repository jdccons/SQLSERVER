SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Customer_Agent]
AS
SELECT tblIndivAgt.AgentId
	, vw_Customer.CustomerKey
	, vw_Customer.CustomerName
	, vw_Customer.TerritoryKey
	, vw_Customer.CustomerAddress1
	, vw_Customer.CustomerAddress2
	, vw_Customer.CustomerCity
	, vw_Customer.CustomerState
	, vw_Customer.CustomerZipCode
	, vw_Customer.ContactName
	, vw_Customer.EmailAddress
	, vw_Customer.ContactPhone
	, vw_Customer.TelexNumber
	, vw_Customer.CustomerClassKey
	, vw_Customer.LocationKey
	, vw_Customer.CreditHold
	, vw_Customer.Spare
	, vw_Customer.Spare2
	, vw_Customer.Spare3
FROM tblIndivAgt
INNER JOIN vw_Customer
	ON tblIndivAgt.PltCustKey = vw_Customer.CustomerKey

UNION

SELECT tblGrpAgt.AgentId
	, vw_Customer.CustomerKey
	, vw_Customer.CustomerName
	, vw_Customer.TerritoryKey
	, vw_Customer.CustomerAddress1
	, vw_Customer.CustomerAddress2
	, vw_Customer.CustomerCity
	, vw_Customer.CustomerState
	, vw_Customer.CustomerZipCode
	, vw_Customer.ContactName
	, vw_Customer.EmailAddress
	, vw_Customer.ContactPhone
	, vw_Customer.TelexNumber
	, vw_Customer.CustomerClassKey
	, vw_Customer.LocationKey
	, vw_Customer.CreditHold
	, vw_Customer.Spare
	, vw_Customer.Spare2
	, vw_Customer.Spare3
FROM vw_Customer
INNER JOIN tblGrpAgt
	ON vw_Customer.CustomerKey = tblGrpAgt.GroupId;

GO
