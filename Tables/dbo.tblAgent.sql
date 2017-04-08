CREATE TABLE [dbo].[tblAgent]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AgentId] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Agency] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentSSN] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Agent_LUname] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentFirst] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentLast] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentMiddle] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentStreet1] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentStreet2] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentCity] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentState] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentZip] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentPhone] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentFax] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentCell] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentEmail] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentCommission] [float] NULL,
[AgentTaxID] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentGeoID] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentActive] [nchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_tblAgent_AgentActive] DEFAULT (N'A'),
[PayCommTo] [smallint] NOT NULL CONSTRAINT [DF_tblAgent_PayCommTo] DEFAULT ((1)),
[AgentNotes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentCLIC] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentNGL] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User01] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User02] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User03] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User04] [datetime] NULL,
[User05] [datetime] NULL,
[User06] [datetime] NULL,
[User07] [int] NULL,
[User08] [int] NULL,
[User09] [int] NULL,
[DateModified] [datetime] NULL CONSTRAINT [df_tblAgent_DateModified] DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[trg_tblAgent_DateModified] ON [dbo].[tblAgent]
FOR INSERT, UPDATE
AS
BEGIN
	/* update date modified */
    UPDATE  a
    SET     a.DateModified = GETDATE(), a.User06 = i.DateModified,
            a.Agent_LUname = UPPER(CAST(RTRIM(COALESCE(NULLIF(RTRIM(i.AgentLast), N'') + ', ', N'') + COALESCE(NULLIF(RTRIM(i.AgentFirst), N'') + ' ', N'') + COALESCE(i.AgentMiddle, N'')) AS NVARCHAR(50))),
            a.AgentFirst = UPPER(i.AgentFirst),
            a.AgentLast = UPPER(i.AgentLast),
            a.AgentMiddle = UPPER(i.AgentMiddle),
            a.AgentStreet1 = UPPER(i.AgentStreet1),
            a.AgentStreet2 = UPPER(i.AgentStreet2),
            a.AgentCity = UPPER(i.AgentCity),
            a.AgentState = UPPER(i.AgentState)
    FROM    dbo.tblAgent a
            INNER JOIN inserted i ON a.ID = i.ID
END;
GO
ALTER TABLE [dbo].[tblAgent] ADD CONSTRAINT [PK_tblAgent] PRIMARY KEY CLUSTERED  ([AgentId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Information about third parties who sell business for company.', 'SCHEMA', N'dbo', 'TABLE', N'tblAgent', NULL, NULL
GO
