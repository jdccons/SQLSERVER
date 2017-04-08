CREATE TABLE [dbo].[tblGrp]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[GroupID] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GRName] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRGeoID] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRStreet1] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRStreet2] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRCity] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRState] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRZip] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRPhone1] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRPhone2] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRFax] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRMainCont] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRSrvCont] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRMarkDir] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRContBeg] [datetime] NULL,
[GRContEnd] [datetime] NULL,
[GRClassKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRAgent%] [decimal] (18, 2) NULL,
[GRNotes] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRClientSvcRepID] [int] NULL,
[GREE] [int] NULL,
[GRAnnvDate] [int] NULL,
[GRFirstInvAmt] [decimal] (18, 2) NULL,
[GRSubLabelsPrinted] [datetime] NULL,
[DateCreated] [datetime] NULL,
[DateUpdated] [datetime] NULL,
[GRCancelled] [bit] NOT NULL CONSTRAINT [DF_tblGrp_GRCancelled] DEFAULT ((0)),
[GRAcctMgr] [int] NULL CONSTRAINT [DF_tblGrp_GRAcctMgr] DEFAULT ((0)),
[GRCardStock] [bit] NOT NULL CONSTRAINT [DF_tblGrp_GRCardStock] DEFAULT ((0)),
[GRMailCard] [smallint] NULL,
[GRInvSort] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GREmail] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRMainContTitle] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRSrvConTitle] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GRInitialSubscr] [int] NULL,
[GRHold] [bit] NOT NULL CONSTRAINT [DF_tblGrp_GRHold] DEFAULT ((0)),
[GRCancelledDate] [datetime] NULL,
[GRReinstatedDate] [datetime] NULL,
[Ins] [bit] NOT NULL CONSTRAINT [DF_tblGrp_Ins] DEFAULT ((0)),
[GroupType] [smallint] NULL,
[InvoiceType] [smallint] NULL,
[OrthoCoverage] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrthoLifeTimeLimit] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WaitingPeriod] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecUserID] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecDate] [datetime] NULL,
[RecTime] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User01] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User02] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User03] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User04] [datetime] NULL,
[User05] [datetime] NULL,
[User06] [datetime] NULL,
[User07] [int] NULL,
[User08] [int] NULL,
[User09] [int] NULL,
[DateModified] [datetime] NULL CONSTRAINT [DF_tblGrp_DateModified] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblGrp] ADD CONSTRAINT [PK_tblGrp_1] PRIMARY KEY CLUSTERED  ([GroupID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblGrp] ADD CONSTRAINT [AK_tblGrp_GroupID] UNIQUE NONCLUSTERED  ([GroupID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_dta_index_tblGrp_8_2065442432__K2_K41_3_16_17_28_37] ON [dbo].[tblGrp] ([GroupID], [GroupType]) INCLUDE ([GRCancelled], [GRContBeg], [GRContEnd], [GRHold], [GRName]) ON [PRIMARY]
GO
CREATE STATISTICS [_dta_stat_2065442432_41_2] ON [dbo].[tblGrp] ([GroupType], [GroupID])
GO
ALTER TABLE [dbo].[tblGrp] ADD CONSTRAINT [FK_tblGrp_tblAcctMgr] FOREIGN KEY ([GRAcctMgr]) REFERENCES [dbo].[tblAcctMgr] ([AcctMgrID])
GO
ALTER TABLE [dbo].[tblGrp] ADD CONSTRAINT [FK_tblGrp_tblClientSvcRep] FOREIGN KEY ([GRClientSvcRepID]) REFERENCES [dbo].[tblClientSvcRep] ([ClientSvcRepID])
GO
EXEC sp_addextendedproperty N'Description', N'Information about qroups.', 'SCHEMA', N'dbo', 'TABLE', N'tblGrp', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', 'Information about groups.', 'SCHEMA', N'dbo', 'TABLE', N'tblGrp', NULL, NULL
GO
