CREATE TABLE [dbo].[QCDStandardDependent]
(
[DepSSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubSSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepFirstName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepLastName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepMI] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepDOB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepGender] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepRelation] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QCDStandardDependent] ADD CONSTRAINT [PK_QCDStandardDependent] PRIMARY KEY CLUSTERED  ([TID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used to process text files from QCD Only group dependents using standard QCD import file layout.', 'SCHEMA', N'dbo', 'TABLE', N'QCDStandardDependent', NULL, NULL
GO
