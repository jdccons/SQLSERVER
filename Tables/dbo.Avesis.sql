CREATE TABLE [dbo].[Avesis]
(
[Avesis_Key] [numeric] (19, 0) NOT NULL IDENTITY(1, 1),
[Record_Type] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Action_Code] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Carrier_Number] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Group_Number] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Group_Name] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Plan_Number] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Member_Number] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID_Suffix] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Coverage_Code] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_Name] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[First_Name] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Middle_Initial] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_1] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_2] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Birth_Date] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Effective_Date] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Term_Date] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sub_Group_ID] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Time_stmp] [timestamp] NULL,
[SUBssn] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoDEPS] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Avesis] ADD CONSTRAINT [PK_Avesis] PRIMARY KEY CLUSTERED  ([Avesis_Key]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Avesis] ON [dbo].[Avesis] ([Member_Number], [ID_Suffix]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Information about vision plan.', 'SCHEMA', N'dbo', 'TABLE', N'Avesis', NULL, NULL
GO
