CREATE TABLE [dbo].[tblGrpAgt]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AgentId] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GroupId] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Primary] [bit] NOT NULL CONSTRAINT [DF_tblGrpAgt_Primary] DEFAULT ((0)),
[AgentRate] [decimal] (18, 2) NULL,
[CommOwed] [decimal] (18, 2) NULL,
[Sort] [int] NULL,
[DateModified] [datetime] NULL CONSTRAINT [df_tblGrpAgt_DateModified] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblGrpAgt] ADD CONSTRAINT [PK_tblGrpAgt] PRIMARY KEY CLUSTERED  ([AgentId], [GroupId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_dta_IX_tblGrpAgt_AgentID_GroupID] ON [dbo].[tblGrpAgt] ([AgentId], [GroupId]) INCLUDE ([AgentRate]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblGrpAgt] ADD CONSTRAINT [FK_tblGrpAgt_tblAgent] FOREIGN KEY ([AgentId]) REFERENCES [dbo].[tblAgent] ([AgentId]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[tblGrpAgt] ADD CONSTRAINT [FK_tblGrpAgt_tblGrp] FOREIGN KEY ([GroupId]) REFERENCES [dbo].[tblGrp] ([GroupID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', 'Agents who sold a groups business.', 'SCHEMA', N'dbo', 'TABLE', N'tblGrpAgt', NULL, NULL
GO
