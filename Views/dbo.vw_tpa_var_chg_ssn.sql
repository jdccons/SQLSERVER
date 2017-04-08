SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_tpa_var_chg_ssn]
AS
/* =============================================
	Object:			vw_tpa_var_chg_ssn
	Author:			John Criswell
	Create date:	10/10/2015 
	Description:	
				
					
								
							
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
	ON ISNULL(s.SubID, '') = ISNULL(r.SUB_ID, '')
WHERE (
		(ISNULL(s.SubSSN, '') <> ISNULL(r.SSN, ''))
		AND (s.SubGroupID NOT LIKE 'INDV%')
		);

GO
