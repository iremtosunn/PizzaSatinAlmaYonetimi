IF COL_LENGTH(N'dbo.Bildirimler',N'HedefUrl') IS NULL
    ALTER TABLE dbo.Bildirimler ADD HedefUrl nvarchar(500) NULL;
GO
