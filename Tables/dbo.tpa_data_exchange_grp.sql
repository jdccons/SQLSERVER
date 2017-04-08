CREATE TABLE [dbo].[tpa_data_exchange_grp]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[GRP_ID] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GEO_ID] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDR1] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDR2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHONE1] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHONE2] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMAIL] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CTR_BEG_DT] [datetime] NULL,
[CTR_END_DT] [datetime] NULL,
[BIL_CON] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BIL_PHONE] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NOTES] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CANCELLED] [bit] NOT NULL,
[CANCELLED_DT] [datetime] NULL,
[GRP_TYPE] [smallint] NULL,
[TIER_TYPE] [smallint] NULL,
[MODIFIED_DT] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tpa_data_exchange_grp] ADD CONSTRAINT [PK_tpa_data_exchange_grp] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used to process import data from tpa.', 'SCHEMA', N'dbo', 'TABLE', N'tpa_data_exchange_grp', NULL, NULL
GO
