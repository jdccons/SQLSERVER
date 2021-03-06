CREATE TABLE [dbo].[tblSubscr_Delete]
(
[SubSSN] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SubID] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EIMBRID] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubStatus] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubGroupID] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PltCustKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanID] [int] NULL,
[CoverID] [int] NULL,
[RateID] [int] NULL,
[SubCancelled] [int] NULL CONSTRAINT [DF_tblSubscr_delete_SUBcancelled] DEFAULT ((1)),
[SUB_LUname] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubLastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubFirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubMiddleName] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubStreet1] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubStreet2] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubCity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubState] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubZip] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubPhoneWork] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubPhoneHome] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUBdob] [datetime] NULL,
[DepCnt] [int] NULL,
[SubGender] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubAge] [int] NULL,
[SubMaritalStatus] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubEffDate] [datetime] NULL,
[SubExpDate] [datetime] NULL,
[SubClassKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreexistingDate] [datetime] NULL,
[SubCardPrt] [bit] NULL CONSTRAINT [DF_tblSubscr_delete_SUBcardPRT] DEFAULT ((0)),
[SubCardPrtDte] [datetime] NULL,
[SubNotes] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionType] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubContBeg] [datetime] NULL,
[SubContEnd] [datetime] NULL,
[SubPymtFreq] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubGeoID] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUBbankDraftNo] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Flag] [bit] NULL CONSTRAINT [DF_tblSubscr_delete_Flag] DEFAULT ((0)),
[UserName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[DateUpdated] [datetime] NULL,
[DateDeleted] [datetime] NULL,
[SUBemployeeName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUBflyerPRTdte] [datetime] NULL,
[SUBplanIDgr] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUBplanIDin] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUBcoverage] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUBrate] [int] NULL,
[SUBCOBRA] [bit] NULL CONSTRAINT [DF_tblSubscr_delete_SUBCOBRA] DEFAULT ((0)),
[SUBLOA] [bit] NULL CONSTRAINT [DF_tblSubscr_delete_SUBLOA] DEFAULT ((0)),
[SUBmissing] [bit] NULL CONSTRAINT [DF_tblSubscr_delete_SUBmissing] DEFAULT ((0)),
[SUBagentID1] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUBagentRATE1] [float] NULL,
[SUBagentID2] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUBagentRATE2] [float] NULL,
[GRExecSalesDirID] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRExecSalesDirRate] [float] NULL,
[FOCType] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblSubscr_Delete] ADD CONSTRAINT [PK_tblSubscr_delete] PRIMARY KEY CLUSTERED  ([SubSSN]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Temp table used to identify group maintenance subscribers to delete.', 'SCHEMA', N'dbo', 'TABLE', N'tblSubscr_Delete', NULL, NULL
GO
