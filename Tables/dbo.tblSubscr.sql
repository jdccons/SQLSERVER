CREATE TABLE [dbo].[tblSubscr]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SubSSN] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubID] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EIMBRID] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubStatus] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubGroupID] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PltCustKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanID] [int] NOT NULL,
[CoverID] [int] NOT NULL,
[RateID] [int] NULL,
[SubCancelled] [int] NULL CONSTRAINT [DF_tblSubscr_SUBcancelled] DEFAULT ((1)),
[Sub_LUName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubLastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubFirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubMiddleName] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubStreet1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubStreet2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubCity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubState] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubZip] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubPhoneWork] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubPhoneHome] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubEmail] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubDOB] [datetime] NULL,
[DepCnt] [int] NULL,
[SubGender] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubAge] [int] NULL,
[SubMaritalStatus] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubEffDate] [datetime] NULL,
[SubExpDate] [datetime] NULL,
[SubClassKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreexistingDate] [datetime] NULL,
[SubCardPrt] [bit] NOT NULL CONSTRAINT [DF_tblSubscr_SubCardPrt] DEFAULT ((0)),
[SubCardPrtDte] [datetime] NULL,
[SubNotes] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionType] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubContBeg] [datetime] NULL,
[SubContEnd] [datetime] NULL,
[SubPymtFreq] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubGeoID] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubBankDraftNo] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Flag] [bit] NULL CONSTRAINT [DF_tblSubscr_Flag] DEFAULT ((0)),
[UserName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[DateUpdated] [datetime] NULL,
[DateDeleted] [datetime] NULL,
[SubFlyerPrtDte] [datetime] NULL,
[SubRate] [float] NULL,
[SubCOBRA] [bit] NOT NULL CONSTRAINT [DF_tblSubscr_SubCobra] DEFAULT ((0)),
[SubLOA] [bit] NOT NULL CONSTRAINT [DF_tblSubscr_SubLOA] DEFAULT ((0)),
[SubMissing] [bit] NOT NULL CONSTRAINT [DF_tblSubscr_SubMissing] DEFAULT ((0)),
[CreateDate] [datetime] NULL,
[ModifyDate] [datetime] NULL,
[AmtPaid] [money] NULL,
[wSubID] [int] NULL,
[User01] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User02] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User03] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User04] [datetime] NULL,
[User05] [datetime] NULL,
[User06] [datetime] NULL,
[User07] [int] NULL,
[User08] [int] NULL,
[User09] [int] NULL,
[Email] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [datetime] NULL CONSTRAINT [DF_tblSubscr_DateModified] DEFAULT (getdate()),
[TimeStamp] [timestamp] NOT NULL,
[GUID] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_SubCancelled] ON [dbo].[tblSubscr]
    AFTER UPDATE
AS
    IF UPDATE(SubCancelled)
    BEGIN
        UPDATE d
            SET DepCancelled = i.SubCancelled
        FROM dbo.tblDependent AS d
          JOIN inserted AS i
            ON i.SubSSN = d.DepSubID     -- use the appropriate column for joining
    END ;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[trg_tblSubscr_DateModified_SubLUName] ON [dbo].[tblSubscr]
FOR UPDATE
AS
BEGIN
	/* update date modified and lookup name */
	UPDATE s
	SET DateModified = GETDATE(), 
		Sub_LUName = UPPER(CAST(RTRIM(COALESCE(NULLIF(RTRIM(s.SubLastName), N'') + ', ', N'') 
						+ COALESCE(NULLIF(RTRIM(s.SubFirstName), N'') + ' ', N'') 
						+ COALESCE(s.SubMiddleName, N'')) AS NVARCHAR(50))
		)
	FROM dbo.tblSubscr s
	INNER JOIN inserted i
		ON s.id = i.id
END

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE TRIGGER [dbo].[trg_tblSubscr_SubscrAudit] ON [dbo].[tblSubscr]
AFTER DELETE
AS
BEGIN
	INSERT INTO tblSubscr_Audit (
		ID_FK, SubSSN, SubID, EIMBRID, SubStatus, SubGroupID, 
		PltCustKey, PlanID, CoverID, RateID, SubCancelled, Sub_LUName, 
		SubLastName, SubFirstName, SubMiddleName, SubStreet1, 
		SubStreet2, SubCity, SubState, SubZip, SubPhoneWork, 
		SubPhoneHome, SubEmail, SubDOB, DepCnt, SubGender, SubAge, 
		SubMaritalStatus, SubEffDate, SubExpDate, SubClassKey, 
		PreexistingDate, SubCardPrt, SubCardPrtDte, SubNotes, 
		TransactionType, SubContBeg, SubContEnd, SubPymtFreq, 
		SubGeoID, SubBankDraftNo, Flag, UserName, DateCreated, 
		DateUpdated, DateDeleted, SubFlyerPrtDte, SubRate, SubCOBRA, 
		SubLOA, SubMissing, CreateDate, ModifyDate, AmtPaid, wSubID, 
		User01, User02, User03, User04, User05, User06, User07, User08, 
		User09, Email, DateModified, GUID
		)
	SELECT ID, SubSSN, SubID, EIMBRID, SubStatus, SubGroupID, PltCustKey
		, PlanID, CoverID, RateID, SubCancelled, Sub_LUName, 
		SubLastName, SubFirstName, SubMiddleName, SubStreet1, 
		SubStreet2, SubCity, SubState, SubZip, SubPhoneWork, 
		SubPhoneHome, SubEmail, SubDOB, DepCnt, SubGender, SubAge, 
		SubMaritalStatus, SubEffDate, SubExpDate, SubClassKey, 
		PreexistingDate, SubCardPrt, SubCardPrtDte, SubNotes, 
		TransactionType, SubContBeg, SubContEnd, SubPymtFreq, 
		SubGeoID, SubBankDraftNo, Flag, UserName, DateCreated, 
		DateUpdated, DateDeleted, SubFlyerPrtDte, SubRate, SubCOBRA, 
		SubLOA, SubMissing, CreateDate, ModifyDate, AmtPaid, wSubID, 
		User01, User02, User03, User04, User05, User06, User07, User08, 
		User09, Email, DateModified, GUID
	FROM deleted
END

GO
ALTER TABLE [dbo].[tblSubscr] ADD CONSTRAINT [CK_tblSubscr_SubCancelled] CHECK (([SubCancelled]>=(1) AND [SubCancelled]<=(3)))
GO
ALTER TABLE [dbo].[tblSubscr] ADD CONSTRAINT [CK_tblSubscr_SubID] CHECK (([SubID]>='00000000' AND [SubID]<='99999999'))
GO
ALTER TABLE [dbo].[tblSubscr] ADD CONSTRAINT [PK_tblSubscr_ID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblSubscr_GroupID] ON [dbo].[tblSubscr] ([SubGroupID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_dta_index_tblSubscr_8_1115203073__K6_K8_K9_K13_1_2_3_4_5_7_10_11_12_14_15_16_17_18_19_20_21_22_23_24_25_26_27_28_29_30_31_32_] ON [dbo].[tblSubscr] ([SubGroupID], [PlanID], [CoverID], [SubLastName]) INCLUDE ([DateCreated], [DateDeleted], [DepCnt], [EIMBRID], [ID], [PltCustKey], [PreexistingDate], [RateID], [Sub_LUName], [SubAge], [SubCancelled], [SubCardPrt], [SubCardPrtDte], [SubCity], [SubClassKey], [SubCOBRA], [SubContBeg], [SubContEnd], [SubDOB], [SubEffDate], [SubEmail], [SubExpDate], [SubFirstName], [SubFlyerPrtDte], [SubGender], [SubID], [SubLOA], [SubMaritalStatus], [SubMiddleName], [SubMissing], [SubNotes], [SubPhoneHome], [SubPhoneWork], [SubSSN], [SubState], [SubStatus], [SubStreet1], [SubStreet2], [SubZip], [TransactionType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblSubscr_GrpID_SSN_SubID] ON [dbo].[tblSubscr] ([SubGroupID], [SubSSN], [SubID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_tblSubscr_SubID] ON [dbo].[tblSubscr] ([SubID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_tblSubscr_SubSSN] ON [dbo].[tblSubscr] ([SubSSN]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblSubscr_SubStatus] ON [dbo].[tblSubscr] ([SubStatus]) INCLUDE ([Email], [PltCustKey], [Sub_LUName], [SubCancelled], [SubCity], [SubEmail], [SubFirstName], [SubGeoID], [SubGroupID], [SubID], [SubLastName], [SubMiddleName], [SubPhoneHome], [SubSSN], [SubState], [SubStreet1], [SubStreet2], [SubZip]) ON [PRIMARY]
GO
CREATE STATISTICS [_dta_stat_1115203073_9_6_8_13] ON [dbo].[tblSubscr] ([CoverID], [SubGroupID], [PlanID], [SubLastName])
GO
ALTER TABLE [dbo].[tblSubscr] ADD CONSTRAINT [FK_tblSubscr_tblGrp] FOREIGN KEY ([SubGroupID]) REFERENCES [dbo].[tblGrp] ([GroupID])
GO
ALTER TABLE [dbo].[tblSubscr] WITH NOCHECK ADD CONSTRAINT [FK_tblSubscr_tblRates] FOREIGN KEY ([RateID]) REFERENCES [dbo].[tblRates] ([RateID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[tblSubscr] ADD CONSTRAINT [FK_tblSubscr_tblRates_GrpID_PlanID_CoverID] FOREIGN KEY ([SubGroupID], [PlanID], [CoverID]) REFERENCES [dbo].[tblRates] ([GroupID], [PlanID], [CoverID])
GO
EXEC sp_addextendedproperty N'Description', N'Information about subscribers.', 'SCHEMA', N'dbo', 'TABLE', N'tblSubscr', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', 'Information about group and individual subscribers.', 'SCHEMA', N'dbo', 'TABLE', N'tblSubscr', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DESCRIPTION', 'Indicates active status of subscriber. 1=active, 2=pending, 3=inactive', 'SCHEMA', N'dbo', 'TABLE', N'tblSubscr', 'COLUMN', N'SubCancelled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check SubID for nulls', 'SCHEMA', N'dbo', 'TABLE', N'tblSubscr', 'CONSTRAINT', N'CK_tblSubscr_SubID'
GO
