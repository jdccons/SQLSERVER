SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwDentists_Active]

AS

SELECT      d.DentKeyID,
			RTrim(LTrim(d.DentFirst)) FirstName, 
			RTrim(LTrim(d.DentMiddleInit)) MiddleInitial, 
			RTrim(LTrim(d.DentLast)) LastName, 
			RTrim(LTrim(d.DentStreet1)) Addr1, 
			RTrim(LTrim(d.DentStreet2)) Addr2, 
			RTrim(LTrim(d.DentCity)) City, 
			RTrim(LTrim(d.DentState)) ST, 
			RTrim(LTrim(d.DentZip)) Zip, 
			RTrim(LTrim(d.DentPhoneHome)) PhoneHome, 
			RTrim(LTrim(d.DentPhoneOffice)) PhoneOffice, 
			RTrim(LTrim(d.DentFax)) Fax, 
			RTrim(LTrim(d.DentSpecialty)) Specialty, 
			Convert(varchar(10), d.DentAffilDate, 101) AffiliationDate, 
			RTrim(LTrim(d.DentGradYr)) GraduationYear, 
			RTrim(LTrim(d.DentSchool)) School, 
			RTrim(LTrim(d.DentLicense)) License, 
			RTrim(LTrim(d.DentGeoID)) GeoID, 
			Convert(varchar(10), d.DentContStart, 101) ContractStartDate, 
			Convert(varchar(10), d.DentContEnd, 101) ContractEndDate, 
			RTrim(LTrim(d.DentWebsite)) Website, 
			pz.Latitude, 
			pz.Longitude
			
			
FROM       tblDentist d
LEFT OUTER JOIN Prozip pz ON d.DentZip = pz.ZipCode
WHERE     (d.DentStatus = 'A')


GO
