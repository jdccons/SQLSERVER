SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

-- =============================================
-- Created by:  John Criswell
-- Created date: 01/03/2011
-- Purpose:	Counts the number of dependents in
--          tblEDI_App_Dep after a new group
--          has been imported into the table
-- Modifications:
-- <Date> <Programmer> <Change>
-- =============================================

CREATE PROCEDURE [dbo].[uspCntEDIDeps]
@SubGroupID varchar(5)

AS
BEGIN

SELECT     COUNT(d.DepSubID) AS ImpDCnt
FROM       tblEDI_App_Dep AS d 
		   INNER JOIN tblEDI_App_Subscr s
		   ON d.DepSubID = s.SubSSN
WHERE	   s.SubGroupID = @SubGroupID

END
GO
