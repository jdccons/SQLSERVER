IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'QCD\ImportUser')
CREATE LOGIN [QCD\ImportUser] FROM WINDOWS
GO
CREATE USER [QCD\ImportUser] FOR LOGIN [QCD\ImportUser] WITH DEFAULT_SCHEMA=[QCD\ImportUser]
GO
REVOKE CONNECT TO [QCD\ImportUser]
