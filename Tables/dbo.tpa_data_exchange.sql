CREATE TABLE [dbo].[tpa_data_exchange]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[GRP_TYPE] [int] NULL,
[RCD_TYPE] [nchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSN] [nchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MBR_ID] [nchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUB_ID] [nchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DEP_SSN] [nchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FIRST_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MI] [nchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL,
[GRP_ID] [nchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PLAN] [int] NOT NULL,
[COV] [int] NOT NULL,
[EFF_DT] [datetime] NOT NULL,
[PREX_DT] [datetime] NULL,
[GENDER] [nchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ADDR1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ADDR2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[STATE] [nchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMAIL] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHONE_HOME] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHONE_WORK] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NO_DEP] [int] NOT NULL,
[REL] [int] NULL,
[CARD_PRT] [int] NULL,
[CARD_PRT_DT] [datetime] NULL,
[MBR_ST] [int] NOT NULL,
[TERM_DT] [datetime] NULL,
[DT_UPDT] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tpa_data_exchange] WITH NOCHECK ADD CONSTRAINT [chk_covID] CHECK (([COV]>=(0) AND [COV]<=(4)))
GO
ALTER TABLE [dbo].[tpa_data_exchange] WITH NOCHECK ADD CONSTRAINT [chk_planID] CHECK (([PLAN]>=(1) AND [PLAN]<=(5)))
GO
ALTER TABLE [dbo].[tpa_data_exchange] ADD CONSTRAINT [PK_tpa_data_exchange_ID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tpa_data_exchange_GRP_ID] ON [dbo].[tpa_data_exchange] ([GRP_ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tpa_data_exchange_SSN] ON [dbo].[tpa_data_exchange] ([SSN]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tpa_data_exchange_SUB_ID] ON [dbo].[tpa_data_exchange] ([SUB_ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used to process import data from tpa.', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'1=Yes;0=No', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange', 'COLUMN', N'CARD_PRT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date last card printed.', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange', 'COLUMN', N'CARD_PRT_DT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1=Employee Only;2=Employee Plus One Adult;3=Employee Plus Child(ren);4=Family', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange', 'COLUMN', N'COV'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Effective date of coverage.', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange', 'COLUMN', N'EFF_DT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'F=Female;M=Male', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange', 'COLUMN', N'GENDER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1=QCD; 4=All American; 9=Individual', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange', 'COLUMN', N'GRP_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SSN plus suffix; 01=Subscriber:02=Spouse or eldest child;03-99=Subsequent children or other relations.', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange', 'COLUMN', N'MBR_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1=Added to Group;2=Updated record attributes;3=Dropped from Group.', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange', 'COLUMN', N'MBR_ST'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 for subscribers with no dependents; otherwise number of dependent records for subscriber.', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange', 'COLUMN', N'NO_DEP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1=Red;2=White;3=Blue;4=Red Plus;5=QCD Only', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange', 'COLUMN', N'PLAN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Pre-existing date for prior coverage under different carrier''s plan; must precede effective date of coverage; depdendents may after a different date than the subscriber.', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange', 'COLUMN', N'PREX_DT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'S=Subscriber;D=Dependent', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange', 'COLUMN', N'RCD_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0=Subscriber;1=Spouse;2=Child;3=Other', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange', 'COLUMN', N'REL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Eight digit unique number for each subscriber.', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange', 'COLUMN', N'SUB_ID'
GO
