CREATE TABLE [dbo].[tblAcctMgr]
(
[AcctMgrID] [int] NOT NULL IDENTITY(1, 1),
[AcctMgrName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [datetime] NULL CONSTRAINT [DF_tblAcctMgr_DateModified] DEFAULT (getdate())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_AcctMgr_DateModified] ON [dbo].[tblAcctMgr]
    FOR UPDATE
AS
    BEGIN
	/* update date modified */
        UPDATE  am
        SET     DateModified = GETDATE()
        FROM    dbo.tblAcctMgr am
                INNER JOIN Inserted i ON am.AcctMgrID = i.AcctMgrID;	
    END;

GO
ALTER TABLE [dbo].[tblAcctMgr] ADD CONSTRAINT [PK_tblAcctMgr_1] PRIMARY KEY CLUSTERED  ([AcctMgrID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Account managers for groups.', 'SCHEMA', N'dbo', 'TABLE', N'tblAcctMgr', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique key for account manager.', 'SCHEMA', N'dbo', 'TABLE', N'tblAcctMgr', 'COLUMN', N'AcctMgrID'
GO
