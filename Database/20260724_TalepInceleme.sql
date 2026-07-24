SET XACT_ABORT ON;
BEGIN TRANSACTION;
IF COL_LENGTH(N'dbo.SatinAlmaTalepleri',N'MevcutStokMiktari') IS NULL ALTER TABLE dbo.SatinAlmaTalepleri ADD MevcutStokMiktari DECIMAL(18,2) NULL;
IF COL_LENGTH(N'dbo.SatinAlmaTalepleri',N'StokYeterlilikSuresiGun') IS NULL ALTER TABLE dbo.SatinAlmaTalepleri ADD StokYeterlilikSuresiGun INT NULL;
IF COL_LENGTH(N'dbo.SatinAlmaTalepleri',N'ErtelenebilirMi') IS NULL ALTER TABLE dbo.SatinAlmaTalepleri ADD ErtelenebilirMi BIT NULL;
IF COL_LENGTH(N'dbo.SatinAlmaTalepleri',N'InceleyenKullaniciID') IS NULL ALTER TABLE dbo.SatinAlmaTalepleri ADD InceleyenKullaniciID INT NULL;
IF COL_LENGTH(N'dbo.SatinAlmaTalepleri',N'IncelemeTarihi') IS NULL ALTER TABLE dbo.SatinAlmaTalepleri ADD IncelemeTarihi DATETIME2 NULL;
GO
IF NOT EXISTS(SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_SatinAlmaTalepleri_InceleyenKullanici') ALTER TABLE dbo.SatinAlmaTalepleri WITH CHECK ADD CONSTRAINT FK_SatinAlmaTalepleri_InceleyenKullanici FOREIGN KEY(InceleyenKullaniciID) REFERENCES dbo.Kullanicilar(KullaniciID);
IF NOT EXISTS(SELECT 1 FROM sys.check_constraints WHERE name=N'CK_SatinAlmaTalepleri_MevcutStokMiktari') ALTER TABLE dbo.SatinAlmaTalepleri ADD CONSTRAINT CK_SatinAlmaTalepleri_MevcutStokMiktari CHECK(MevcutStokMiktari IS NULL OR MevcutStokMiktari>=0);
IF NOT EXISTS(SELECT 1 FROM sys.check_constraints WHERE name=N'CK_SatinAlmaTalepleri_StokYeterlilikSuresiGun') ALTER TABLE dbo.SatinAlmaTalepleri ADD CONSTRAINT CK_SatinAlmaTalepleri_StokYeterlilikSuresiGun CHECK(StokYeterlilikSuresiGun IS NULL OR StokYeterlilikSuresiGun>=0);
COMMIT;
GO
CREATE OR ALTER PROCEDURE dbo.sp_TalepIncele @TalepID INT,@MevcutStokMiktari DECIMAL(18,2),@StokYeterlilikSuresiGun INT,@ErtelenebilirMi BIT,@InceleyenKullaniciID INT AS
BEGIN
 SET NOCOUNT ON; SET XACT_ABORT ON;
 IF @MevcutStokMiktari IS NULL OR @MevcutStokMiktari<0 THROW 50001,N'Depodaki mevcut miktar sıfır veya daha büyük olmalıdır.',1;
 IF @StokYeterlilikSuresiGun IS NULL OR @StokYeterlilikSuresiGun<0 THROW 50002,N'Stok yeterlilik süresi sıfır veya daha büyük olmalıdır.',1;
 IF @ErtelenebilirMi IS NULL THROW 50003,N'Ertelenebilir mi seçimi zorunludur.',1;
 IF NOT EXISTS(SELECT 1 FROM dbo.Kullanicilar WHERE KullaniciID=@InceleyenKullaniciID) THROW 50004,N'İnceleyen kullanıcı bulunamadı.',1;
 IF NOT EXISTS(SELECT 1 FROM dbo.SatinAlmaTalepleri WHERE TalepID=@TalepID) THROW 50005,N'Talep bulunamadı.',1;
 UPDATE dbo.SatinAlmaTalepleri WITH(UPDLOCK,ROWLOCK) SET MevcutStokMiktari=@MevcutStokMiktari,StokYeterlilikSuresiGun=@StokYeterlilikSuresiGun,ErtelenebilirMi=@ErtelenebilirMi,InceleyenKullaniciID=@InceleyenKullaniciID,IncelemeTarihi=SYSDATETIME(),TalepDurumID=1 WHERE TalepID=@TalepID AND TalepDurumID=0;
 IF @@ROWCOUNT=0 THROW 50006,N'Talep daha önce işlenmiş veya artık incelenebilir durumda değil.',1;
END;
GO
