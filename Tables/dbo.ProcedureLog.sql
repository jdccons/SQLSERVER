CREATE TABLE [dbo].[ProcedureLog]
(
[LogDate] [datetime] NOT NULL CONSTRAINT [DF__Procedure__LogDa__59511E61] DEFAULT (getdate()),
[DatabaseID] [int] NULL,
[ObjectID] [int] NULL,
[ProcedureName] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorLine] [int] NULL,
[ErrorMessage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalInfo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProcedureLog] ADD CONSTRAINT [PK_ProcedureLog] PRIMARY KEY NONCLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [UIX_LogDate] ON [dbo].[ProcedureLog] ([LogDate]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Error log for stored procedures.', 'SCHEMA', N'dbo', 'TABLE', N'ProcedureLog', NULL, NULL
GO
