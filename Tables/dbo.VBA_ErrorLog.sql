CREATE TABLE [dbo].[VBA_ErrorLog]
(
[ErrorLogID] [int] NOT NULL IDENTITY(1, 1),
[ErrNumber] [int] NULL,
[ErrDescription] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrDate] [datetime] NULL CONSTRAINT [DF_VBA_ErrorLog_ErrDate] DEFAULT (getdate()),
[CallingProc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShowUser] [bit] NULL,
[Parameters] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VBA_ErrorLog] ADD CONSTRAINT [PK_VBA_ErrorLog] PRIMARY KEY CLUSTERED  ([ErrorLogID]) ON [PRIMARY]
GO
