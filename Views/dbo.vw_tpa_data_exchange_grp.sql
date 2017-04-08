SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_tpa_data_exchange_grp]
AS
    SELECT 
	   g.GroupID [GRP_ID]
      ,g.GRName [NAME]
      ,g.GRGeoID [GEO_ID]
      ,g.GRStreet1 [ADDR1]
      ,g.GRStreet2 [ADDR2]
      ,g.GRCity [CITY]
      ,g.GRState [STATE]
      ,g.GRZip [ZIP]
      ,g.GRPhone1 [PHONE1]
      ,g.GRPhone2 [PHONE2]
      ,g.GREmail [EMAIL]
      ,g.GRContBeg[CTR_BEG_DT]
      ,g.GRContEnd[CTR_END_DT]
      ,coalesce(g.GRMainCont, g.GRSrvCont, g.GRMarkDir, 'na') [BIL_CON]
      ,coalesce(g.GRPhone1, g.GRPhone2, '0000000000') [BIL_PHONE]
      ,g.GRNotes [NOTES]
      ,g.GRCancelled [CANCELLED]
      ,g.GRCancelledDate [CANCELLED_DT]
      ,g.GroupType [GRP_TYPE]
      ,t.TierCnt [TIER_TYPE]
      ,GetDate() [MODIFIED_DT]
  FROM [tblGrp] g
  INNER JOIN dbo.vw_Group_Coverage_Tiers t
	on g.GroupID = t.GroupID
  WHERE GRCancelled = 0;
GO
