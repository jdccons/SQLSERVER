CREATE TABLE [dbo].[tpa_data_exchange_dep]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[FK_ID] [int] NULL,
[GRP_TYPE] [int] NOT NULL,
[RCD_TYPE] [nchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSN] [nchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MBR_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUB_ID] [nchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DEP_SSN] [nchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FIRST_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MI] [nchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL,
[GRP_ID] [nchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PLAN] [int] NULL,
[COV] [int] NULL,
[EFF_DT] [datetime] NULL,
[PREX_DT] [datetime] NULL,
[GENDER] [nchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDR1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDR2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [nchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMAIL] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHONE_HOME] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHONE_WORK] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NO_DEP] [int] NULL,
[REL] [int] NULL,
[CARD_PRT] [int] NULL,
[CARD_PRT_DT] [datetime] NULL,
[MBR_ST] [tinyint] NULL,
[DT_UPDT] [datetime] NULL,
[TERM_DT] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tpa_data_exchange_dep] ADD CONSTRAINT [PK_tpa_data_exchange_dep] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tpa_data_exchange_dep] ADD CONSTRAINT [FK_tpa_data_exchange_dep_tpa_data_exchange_sub] FOREIGN KEY ([FK_ID]) REFERENCES [dbo].[tpa_data_exchange_sub] ([ID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used to process import data from tpa.', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange_dep', NULL, NULL
GO
