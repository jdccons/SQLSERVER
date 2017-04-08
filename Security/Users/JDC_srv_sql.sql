IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'JDC\srv_sql')
CREATE LOGIN [JDC\srv_sql] FROM WINDOWS
GO
CREATE USER [JDC\srv_sql] FOR LOGIN [JDC\srv_sql]
GO
