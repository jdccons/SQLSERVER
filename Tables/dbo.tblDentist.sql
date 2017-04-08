CREATE TABLE [dbo].[tblDentist]
(
[DentKeyID] [int] NOT NULL IDENTITY(1, 1),
[ProvRelsRepID] [int] NULL,
[DentFirst] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentMiddleInit] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentLast] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentStreet1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentStreet2] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentCity] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentState] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentZip] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentAttn] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentPhoneHome] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentPhoneOffice] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentFax] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Dent_LUName] [nvarchar] (61) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentClass] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentSpecialty] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentAffilDate] [datetime] NULL,
[DentGradYr] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentSchool] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentLicense] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentStatus] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentComments] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentGeoID] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentContStart] [datetime] NULL,
[DentContEnd] [datetime] NULL,
[DentInaDte] [datetime] NULL,
[DentAgree] [bit] NOT NULL CONSTRAINT [DF_tblDentist_DentAgree] DEFAULT ((0)),
[DentStCert] [bit] NOT NULL CONSTRAINT [DF_tblDentist_DentStCert] DEFAULT ((0)),
[DentIns] [bit] NOT NULL CONSTRAINT [DF_tblDentist_DentIns] DEFAULT ((0)),
[DentSubCert] [bit] NOT NULL CONSTRAINT [DF_tblDentist_DentSubCert] DEFAULT ((0)),
[DentCloseMyOff] [bit] NOT NULL CONSTRAINT [DF_tblDentist_DentCloseMyOff] DEFAULT ((0)),
[DentSpecialPrice] [bit] NULL,
[DentBilingual] [bit] NULL,
[DentWebsite] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentSelect] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentLastMailing] [datetime] NULL,
[DentMail] [bit] NOT NULL CONSTRAINT [DF_tblDentist_DentMail] DEFAULT ((0)),
[DentRefer] [bit] NOT NULL CONSTRAINT [DF_tblDentist_DentRefer] DEFAULT ((0)),
[TimeStmp] [timestamp] NULL,
[RTNCODE] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LATITUDE] [float] NULL,
[LONGITUDE] [float] NULL,
[EIN] [nchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NPI] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [datetime] NULL CONSTRAINT [DF_tblDentist_DateModified] DEFAULT (getdate()),
[DentEmail] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User01] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User02] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User03] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User04] [datetime] NULL,
[User05] [datetime] NULL,
[User06] [datetime] NULL,
[User07] [int] NULL,
[User08] [int] NULL,
[User09] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_tblDentist_DateModified] ON [dbo].[tblDentist]
FOR UPDATE
AS
BEGIN
	

	/* update date modified */
	UPDATE d
	SET DateModified = GETDATE()
	FROM tblDentist d
	INNER JOIN inserted i
		ON d.DentKeyID = i.DentKeyID
END
GO
ALTER TABLE [dbo].[tblDentist] ADD CONSTRAINT [PK_tblDentist] PRIMARY KEY CLUSTERED  ([DentKeyID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NCIX_LUName] ON [dbo].[tblDentist] ([Dent_LUName]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NIX_Dentist_Specialty] ON [dbo].[tblDentist] ([DentGeoID], [DentStatus], [ProvRelsRepID], [DentSpecialty], [DentLast]) INCLUDE ([DateModified], [Dent_LUName], [DentAffilDate], [DentAgree], [DentAttn], [DentBilingual], [DentCity], [DentClass], [DentCloseMyOff], [DentComments], [DentContEnd], [DentContStart], [DentFax], [DentFirst], [DentGradYr], [DentInaDte], [DentIns], [DentKeyID], [DentLastMailing], [DentLicense], [DentMail], [DentMiddleInit], [DentPhoneHome], [DentPhoneOffice], [DentRefer], [DentSchool], [DentSelect], [DentSpecialPrice], [DentState], [DentStCert], [DentStreet1], [DentStreet2], [DentSubCert], [DentWebsite], [DentZip], [EIN], [LATITUDE], [LONGITUDE], [NPI], [RTNCODE], [TimeStmp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NCIX_ZipCode] ON [dbo].[tblDentist] ([DentZip]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblDentist] ADD CONSTRAINT [FK_tblDentist_tlkpProvRelsRep] FOREIGN KEY ([ProvRelsRepID]) REFERENCES [dbo].[tlkpProvRelsRep] ([ProvRelsRepID])
GO
EXEC sp_addextendedproperty N'MS_Description', 'Information about dentists in network.', 'SCHEMA', N'dbo', 'TABLE', N'tblDentist', NULL, NULL
GO
