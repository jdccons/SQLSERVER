CREATE TABLE [dbo].[tblIndivAgt]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AgentId] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SubSSN] [nchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscrId] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PltCustKey] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary] [bit] NULL CONSTRAINT [DF_tblIndivAgt_Primary] DEFAULT ((0)),
[AgentRate] [decimal] (18, 2) NULL,
[CommOwed] [decimal] (18, 2) NULL,
[Sort] [int] NULL,
[DateModified] [datetime] NOT NULL CONSTRAINT [DF_tblIndivAgt_DateModified] DEFAULT (getdate())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_tblIndivAgt_DateModified] ON [dbo].[tblIndivAgt]
FOR UPDATE
AS
BEGIN
	/* update date modified and lookup name */
	UPDATE ia
	SET DateModified = GETDATE()
	FROM dbo.tblIndivAgt ia
	INNER JOIN inserted i
		ON ia.id = i.id
END
GO
ALTER TABLE [dbo].[tblIndivAgt] ADD CONSTRAINT [PK_tblIndivAgt] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_dta_index_tblIndivAgt_AgentID_SubscrID_Rate] ON [dbo].[tblIndivAgt] ([AgentId], [SubscrId]) INCLUDE ([AgentRate]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblIndivAgt] ADD CONSTRAINT [FK_tblIndivAgt_tblAgent] FOREIGN KEY ([AgentId]) REFERENCES [dbo].[tblAgent] ([AgentId]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[tblIndivAgt] ADD CONSTRAINT [FK_tblIndivAgt_tblSubscr] FOREIGN KEY ([SubscrId]) REFERENCES [dbo].[tblSubscr] ([SubID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', 'Intermediate table to connect individuals to their agents.', 'SCHEMA', N'dbo', 'TABLE', N'tblIndivAgt', NULL, NULL
GO
