CREATE TABLE [dbo].[QCDStandardSubscriber]
(
[SubSSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SubFirst] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubMI] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubLast] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubAddr] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubAddr2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubCity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubState] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubZip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubHomePh] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubWorkPh] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubGroupID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubRate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubDOB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubNoDep] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubEffDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubTypeCov] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubGender] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QCDStandardSubscriber] ADD CONSTRAINT [PK_QCDStandardSubscriber] PRIMARY KEY CLUSTERED  ([TID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used to process text files from QCD Only group subscribers using standard QCD import file layout.', 'SCHEMA', N'dbo', 'TABLE', N'QCDStandardSubscriber', NULL, NULL
GO
