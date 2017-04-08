IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'QCD\srv_sql')
CREATE LOGIN [QCD\srv_sql] FROM WINDOWS
GO
CREATE USER [QCD\srv_sql] FOR LOGIN [QCD\srv_sql]
GO
