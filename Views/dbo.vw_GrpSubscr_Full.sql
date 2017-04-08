SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vw_GrpSubscr_Full]
AS
SELECT
  s.SubSSN,
  s.SubID,
  s.EIMBRID,
  s.SubStatus,
  s.SubGroupID,
  s.PltCustKey,
  s.PlanID,
  s.CoverID,
  s.RateID,
  s.SubCancelled,
  s.SUB_LUname,
  s.SubLastName,
  s.SubFirstName,
  s.SubMiddleName,
  s.SubStreet1,
  s.SubStreet2,
  s.SubCity,
  s.SubState,
  s.SubZip,
  s.SubPhoneWork,
  s.SubPhoneHome,
  s.SubEmail,
  s.SubDOB,
  s.DepCnt,
  s.SubGender,
  s.SubAge,
  s.SubMaritalStatus,
  s.SubEffDate,
  s.SubExpDate,
  s.SubClassKey,
  s.PreexistingDate,
  s.SubCardPrt,
  s.SubCardPrtDte,
  s.SubNotes,
  s.TransactionType,
  s.SubContBeg,
  s.SubContEnd,
  s.SubPymtFreq,
  s.SubGeoID,
  s.SUBbankDraftNo,
  s.Flag,
  s.UserName,
  s.DateCreated,
  s.DateUpdated,
  s.DateDeleted,
  s.SubRate,
  s.SUBCOBRA,
  s.SUBLOA,
  s.SUBmissing,
  s.CreateDate,
  s.ModifyDate,
  s.AmtPaid,
  s.wSubID,
  s.User01,
  s.User02,
  s.User03,
  s.User04,
  s.User05,
  s.User06,
  s.User07,
  s.User08,
  s.User09,
  s.Email,
  g.GRContBeg,
  g.GRContEnd,
  g.GRName,
  g.GRCancelled,
  g.GRHold,
  g.GroupType,
  p.PlanDesc,
  c.CoverDescr,
  c.CoverCode,
  r.Rate
FROM tblSubscr AS s
LEFT OUTER JOIN tblGrp AS g
  ON s.SubGroupID = g.GroupID
LEFT OUTER JOIN tblPlans p
	ON s.PlanID = p.PlanID
LEFT OUTER JOIN tblCoverage AS c
  ON s.CoverID = c.CoverID
LEFT OUTER JOIN tblRates AS r
  ON s.RateID = r.RateID
  
WHERE (s.SubStatus = 'GRSUB');
GO
