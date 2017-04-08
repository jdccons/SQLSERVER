IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'JDC\John Criswell')
CREATE LOGIN [JDC\John Criswell] FROM WINDOWS
GO
CREATE USER [JDC\John Criswell] FOR LOGIN [JDC\John Criswell]
GO
