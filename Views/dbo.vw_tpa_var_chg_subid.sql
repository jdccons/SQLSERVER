SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_tpa_var_chg_subid]
AS
/* =============================================
	Object:			vw_tpa_var_chg_subid
	Author:			John Criswell
	Create date:	10/10/2015 
	Description:	Lists all subscribers whose SubID
					was changed where the SSN remains the same
							
	Change Log:
	--------------------------------------------
	Change Date	Version		Changed by		Reason
	2015-10-10	1.0			J Criswell		Created
	
	
============================================= */

SELECT ISNULL(r.SSN, '') SSN,
	ISNULL(r.SUB_ID, '') SUB_ID,
	ISNULL(r.GRP_ID, '') GRP_ID,
	ISNULL(s.SubSSN, '') SubSSN,
	ISNULL(s.SubID, '') SubID,
	ISNULL(s.SubGroupID, '') AS GrpID,
	ISNULL(s.SubFirstName, '')  SubFirstName,
	ISNULL(s.SubLastName, '') SubLastName,	
	r.DT_UPDT AS RptDate
FROM tpa_data_exchange_sub r
JOIN tblSubscr s
	ON ISNULL(s.SubSSN, '') = ISNULL(r.SSN, '')
INNER JOIN tblGrp g
	ON s.SubGroupID = g.GroupID
WHERE (
		(ISNULL(s.SubID, '') <> ISNULL(r.SUB_ID, ''))
		AND (g.GroupType IN (4))
		);

GO
