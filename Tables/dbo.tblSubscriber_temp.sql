CREATE TABLE [dbo].[tblSubscriber_temp]
(
[SSN] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EIMBRID] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberID] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupID] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanID] [int] NULL,
[CoverID] [int] NULL,
[LastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleInitial] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneWork] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneHome] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL,
[DepCnt] [int] NULL,
[Gender] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Age] [int] NULL,
[EffectiveDate] [datetime] NULL,
[PreexistingDate] [datetime] NULL,
[EmploymentDate] [datetime] NULL,
[EmploymentStatus] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Occupation_Title] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaritalStatus] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardPrinted] [tinyint] NULL,
[CardPrintedDate] [datetime] NULL,
[MembershipStatus] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[DateChanged] [datetime] NULL,
[DateDeleted] [datetime] NULL,
[Download] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DownloadDate] [datetime] NULL,
[wSubID] [int] NULL,
[AmtPaid] [money] NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblSubscriber_temp] ADD CONSTRAINT [PK_tblSubscriber_temp_ID] PRIMARY KEY CLUSTERED  ([SSN]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Temp table used for downloading subscriber maintenance data from the website.', 'SCHEMA', N'dbo', 'TABLE', N'tblSubscriber_temp', NULL, NULL
GO
