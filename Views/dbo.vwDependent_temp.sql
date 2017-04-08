SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  View dbo.vwDependent_temp    Script Date: 4/22/2009 7:34:16 PM ******/
CREATE VIEW [dbo].[vwDependent_temp]
AS
SELECT     SubSSN, EIMBRID, DepSSN, FirstName, MiddleInitial, LastName, DOB, Age, Relationship, Gender, EffDate, PreexistingDate
FROM         dbo.tblDependent_temp

GO
