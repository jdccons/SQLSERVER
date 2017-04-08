CREATE TABLE [dbo].[tblInvHdr]
(
[CUST KEY] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUST NAME] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS 1] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS 2] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS 3] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP CODE] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COUNTRY] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATTENTION] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRANS NO] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[APPLY-TO] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEL STATUS] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INV DATE] [datetime] NULL,
[RECR CYCLE] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUYER] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUST PO] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CHECK NO] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CHECK AMTR] [nvarchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMM OVRD] [nvarchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOCATION  KEY] [float] NULL,
[TERRITORY KEY] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SALESP    KEY] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TERMS] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FOB] [float] NULL,
[SHIP VIA] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMMENT KEY] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUST CLASS] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FREIGHT] [float] NULL,
[DISCOUNT MULT] [float] NULL,
[CR MEMO FLAG] [smallint] NULL,
[INVOICE NO] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPARE] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPARE2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPARE3] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INVOICETOTAL] [float] NULL,
[SYSDOCID] [int] NULL,
[RecUserID] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecDate] [datetime] NULL,
[RecTime] [datetime] NULL,
[upsize_ts] [binary] (8) NULL,
[DateModified] [datetime] NULL CONSTRAINT [df_tblInvHdr_DateModified] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblInvHdr] ADD CONSTRAINT [PK_tblInvHdr] PRIMARY KEY CLUSTERED  ([TRANS NO]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblInvHdr_CustKey] ON [dbo].[tblInvHdr] ([CUST KEY]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used in the invoicing process.', 'SCHEMA', N'dbo', 'TABLE', N'tblInvHdr', NULL, NULL
GO
