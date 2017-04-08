CREATE TABLE [dbo].[tblDependent_temp]
(
[DepID] [int] NOT NULL IDENTITY(1, 1),
[SubSSN] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EIMBRID] [nvarchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepSSN] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleInitial] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL,
[Age] [int] NULL,
[Relationship] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffDate] [datetime] NULL,
[PreexistingDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblDependent_temp] ADD CONSTRAINT [PK_tblDependent_temp] PRIMARY KEY CLUSTERED  ([DepID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblDependent_temp] ADD CONSTRAINT [FK_tblDependent_temp_tblSubscriber_temp] FOREIGN KEY ([SubSSN]) REFERENCES [dbo].[tblSubscriber_temp] ([SSN]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', 'Temp table used for downloading dependent maintenance data from the website.', 'SCHEMA', N'dbo', 'TABLE', N'tblDependent_temp', NULL, NULL
GO
