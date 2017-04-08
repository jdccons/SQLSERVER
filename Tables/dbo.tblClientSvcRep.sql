CREATE TABLE [dbo].[tblClientSvcRep]
(
[ClientSvcRepID] [int] NOT NULL IDENTITY(1, 1),
[ClientSvcRepName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_ClientSvcRep_DateModified] ON [dbo].[tblClientSvcRep]
    FOR UPDATE
AS
    BEGIN
		/* update date modified */
        UPDATE  csr
        SET     DateModified = GETDATE()
        FROM    dbo.tblClientSvcRep csr
                INNER JOIN Inserted i ON csr.ClientSvcRepID = i.ClientSvcRepID;	
    END;

GO
ALTER TABLE [dbo].[tblClientSvcRep] ADD CONSTRAINT [PK_tblClientSvcRep_1] PRIMARY KEY CLUSTERED  ([ClientSvcRepID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Lookup table with employees who are assigned to provide customer service to groups.', 'SCHEMA', N'dbo', 'TABLE', N'tblClientSvcRep', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique key for client service rep.', 'SCHEMA', N'dbo', 'TABLE', N'tblClientSvcRep', 'COLUMN', N'ClientSvcRepID'
GO
