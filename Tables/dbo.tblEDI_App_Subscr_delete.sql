CREATE TABLE [dbo].[tblEDI_App_Subscr_delete]
(
[Subssn] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SubID] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EIMBRID] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubStatus] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubGroupID] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PltCustKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanID] [int] NULL,
[CoverID] [int] NULL,
[RateID] [int] NULL,
[SubCancelled] [int] NULL,
[Sub_LUname] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubLastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubFirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubMiddleName] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubStreet1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubStreet2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubCity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubState] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubZip] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubPhoneWork] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubPhoneHome] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subdob] [datetime] NULL,
[DepCnt] [int] NULL,
[SubGender] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubAge] [int] NULL,
[SubMaritalStatus] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubEffDate] [datetime] NULL,
[SubExpDate] [datetime] NULL,
[SubClassKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreexistingDate] [datetime] NULL,
[SubCardPrt] [bit] NULL,
[SubCardPrtDte] [datetime] NULL,
[SubNotes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionType] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubContBeg] [datetime] NULL,
[SubContEnd] [datetime] NULL,
[SubPymtFreq] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubGeoID] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubBankDraftNo] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[DateUpdated] [datetime] NULL,
[DateDeleted] [datetime] NULL,
[SubFlyerPrtDte] [datetime] NULL,
[Flag] [bit] NULL,
[SubCOBRA] [bit] NULL,
[SubLOA] [bit] NULL,
[Submissing] [bit] NULL,
[Subrate] [float] NULL,
[SubEmail] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL,
[ModifyDate] [datetime] NULL,
[wSubID] [int] NULL,
[wUpt] [int] NULL,
[AmtPaid] [money] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblEDI_App_Subscr_delete] ADD CONSTRAINT [PK_tblEDI_App_Subscr_delete] PRIMARY KEY CLUSTERED  ([Subssn]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Temp table used to process deletions for subscriber EDI data..', 'SCHEMA', N'dbo', 'TABLE', N'tblEDI_App_Subscr_delete', NULL, NULL
GO