IF OBJECT_ID(N'dbo.TeslimatKayitlari',N'U') IS NULL
BEGIN
 CREATE TABLE dbo.TeslimatKayitlari(TeslimatID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_TeslimatKayitlari PRIMARY KEY,SiparisID int NOT NULL CONSTRAINT UQ_TeslimatKayitlari_Siparis UNIQUE,GercekTeslimTarihi date NOT NULL,TeslimEdilenMiktar decimal(18,2) NOT NULL,KusurluMiktar decimal(18,2) NOT NULL CONSTRAINT DF_TeslimatKayitlari_Kusurlu DEFAULT(0),KaydedenKullaniciID int NOT NULL,KayitTarihi datetime2 NOT NULL CONSTRAINT DF_TeslimatKayitlari_Kayit DEFAULT(SYSDATETIME()),CONSTRAINT FK_TeslimatKayitlari_Siparis FOREIGN KEY(SiparisID) REFERENCES dbo.SatinAlmaSiparisleri(SiparisID),CONSTRAINT FK_TeslimatKayitlari_Kullanici FOREIGN KEY(KaydedenKullaniciID) REFERENCES dbo.Kullanicilar(KullaniciID),CONSTRAINT CK_TeslimatKayitlari_Miktar CHECK(TeslimEdilenMiktar>0 AND KusurluMiktar>=0 AND KusurluMiktar<=TeslimEdilenMiktar));
END;
GO
