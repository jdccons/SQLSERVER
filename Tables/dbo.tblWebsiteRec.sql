CREATE TABLE [dbo].[tblWebsiteRec]
(
[Description] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupID] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip_r] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip_l] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepCnt_r] [int] NULL,
[DepCnt_l] [int] NULL,
[Cov_r] [int] NULL,
[Cov_l] [int] NULL,
[Plan_r] [int] NULL,
[Plan_l] [int] NULL,
[MembershipStatus] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NULL,
[DateChanged] [datetime] NULL,
[DateDeleted] [datetime] NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblWebsiteRec] ADD CONSTRAINT [PK_tblWebsiteRec_ID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used to hold data for a reconciliaiton report between the on-premise and website databases.', 'SCHEMA', N'dbo', 'TABLE', N'tblWebsiteRec', NULL, NULL
GO
