CREATE TABLE [dbo].[tlkpProvRelsRep]
(
[ProvRelsRepID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [date] NULL CONSTRAINT [DF_tlkpProvRelsRep_DateModified] DEFAULT (getdate())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_tlkpProvRelsRep_DateModified] ON [dbo].[tlkpProvRelsRep]
FOR UPDATE
AS
BEGIN
	

	/* update date modified */
	UPDATE prr
	SET DateModified = GETDATE()
	from tlkpProvRelsRep prr
	INNER JOIN inserted i
		ON prr.ProvRelsRepID = i.ProvRelsRepID;
END
GO
ALTER TABLE [dbo].[tlkpProvRelsRep] ADD CONSTRAINT [PK_tlkpProvRelsRep] PRIMARY KEY CLUSTERED  ([ProvRelsRepID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Lookup table of employees who recruit providers into the network.', 'SCHEMA', N'dbo', 'TABLE', N'tlkpProvRelsRep', NULL, NULL
GO
