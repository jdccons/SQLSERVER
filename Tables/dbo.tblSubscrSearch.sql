CREATE TABLE [dbo].[tblSubscrSearch]
(
[SearchID] [int] NOT NULL IDENTITY(1, 1),
[SubSSN] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubStatus] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubID] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EIMBRID] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubGroupID] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GrContEndDate] [datetime] NULL,
[GrName] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubFirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubMiddleName] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubLastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubStreet1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubStreet2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubCity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubState] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubZip] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubPhoneHome] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubPhoneWork] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubDOB] [datetime] NULL,
[SubAge] [int] NULL,
[SubGender] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanDesc] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoverDescr] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rate] [float] NULL,
[DepCnt] [int] NULL,
[SubEffDate] [datetime] NULL,
[SubContBeg] [datetime] NULL,
[SubContEnd] [datetime] NULL,
[SubCardPrt] [bit] NULL,
[SubCardPrDate] [datetime] NULL,
[PreexistingDate] [datetime] NULL,
[SubNotes] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GrHold] [bit] NULL,
[GrCancelled] [bit] NULL,
[SubCancelled] [int] NULL,
[IndivSubStatus] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrthoCoverage] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrthoLifetimeLimit] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WaitingPeriod] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[DateDeleted] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblSubscrSearch] ADD CONSTRAINT [PK_tblSubscrSearch] PRIMARY KEY CLUSTERED  ([SearchID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Temp table for quick search results.', 'SCHEMA', N'dbo', 'TABLE', N'tblSubscrSearch', NULL, NULL
GO
