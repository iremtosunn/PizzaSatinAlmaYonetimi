USE PizzaSatinAlmaDB;
GO

/* =========================================================
   1. Yeni talep oluşturulduğunda bildirim üretir
   Bildirim alıcıları:
   - Talebi oluşturan kullanıcı
   - Satın Alma Yöneticisi
   - Satın Alma Uzmanı
   ========================================================= */

CREATE OR ALTER PROCEDURE dbo.sp_TalepEkle
    @TalepEdenKullaniciID INT,
    @UrunAdi NVARCHAR(150),
    @Miktar DECIMAL(18,2),
    @Birim NVARCHAR(30),
    @Aciklama NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @YeniTalepID INT;
    DECLARE @YeniTalepNo NVARCHAR(20);

    BEGIN TRANSACTION;

    BEGIN TRY

        INSERT INTO dbo.SatinAlmaTalepleri
        (
            TalepNo,
            TalepEdenKullaniciID,
            UrunAdi,
            Miktar,
            Birim,
            TalepTarihi,
            TalepDurumID,
            Aciklama
        )
        VALUES
        (
            N'GEÇİCİ',
            @TalepEdenKullaniciID,
            @UrunAdi,
            @Miktar,
            @Birim,
            GETDATE(),
            0,
            @Aciklama
        );

        SET @YeniTalepID = SCOPE_IDENTITY();

        SET @YeniTalepNo =
            CONCAT
            (
                N'ST',
                RIGHT
                (
                    N'0000' + CAST(@YeniTalepID AS NVARCHAR(10)),
                    4
                )
            );

        UPDATE dbo.SatinAlmaTalepleri
        SET TalepNo = @YeniTalepNo
        WHERE TalepID = @YeniTalepID;

        ;WITH Alicilar AS
        (
            SELECT K.KullaniciID
            FROM dbo.Kullanicilar K
            INNER JOIN dbo.Roller R ON R.RolID = K.RolID
            WHERE K.Durum = 1
              AND R.RolAdi IN (N'Satın Alma Yöneticisi', N'Satın Alma Uzmanı')

            UNION

            SELECT K.KullaniciID
            FROM dbo.Kullanicilar K
            WHERE K.KullaniciID = @TalepEdenKullaniciID
              AND K.Durum = 1
        )
        INSERT INTO dbo.Bildirimler
        (
            KullaniciID,
            Baslik,
            Mesaj,
            OkunduMu,
            OlusturmaTarihi,
            OkunmaTarihi
        )
        SELECT
            A.KullaniciID,
            N'Yeni Talep Oluşturuldu',
            CONCAT(@YeniTalepNo, N' numaralı yeni satın alma talebi oluşturuldu.'),
            0,
            GETDATE(),
            NULL
        FROM Alicilar A;

        COMMIT TRANSACTION;

        SELECT
            @YeniTalepID AS TalepID,
            @YeniTalepNo AS TalepNo;

    END TRY
    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO


/* =========================================================
   2. Yeni teklif girildiğinde bildirim üretir
   Bildirim alıcıları:
   - Talebi oluşturan kullanıcı
   - Satın Alma Yöneticisi
   - Satın Alma Uzmanı
   ========================================================= */

CREATE OR ALTER PROCEDURE dbo.sp_TeklifEkle
    @TalepNo NVARCHAR(20),
    @FirmaAdi NVARCHAR(150),
    @TeklifGirenKullaniciID INT,
    @BirimFiyat DECIMAL(18,2),
    @TeslimSuresiGun INT,
    @SKT DATE = NULL,
    @GecerlilikTarihi DATE,
    @ParaBirimi CHAR(3)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @YeniTeklifID INT;
    DECLARE @YeniTeklifNo NVARCHAR(20);
    DECLARE @Miktar DECIMAL(18,2);
    DECLARE @ToplamTutar DECIMAL(18,2);
    DECLARE @TalepID INT;
    DECLARE @TalepEdenKullaniciID INT;

    BEGIN TRANSACTION;

    BEGIN TRY

        SELECT
            @TalepID = SAT.TalepID,
            @Miktar = SAT.Miktar,
            @TalepEdenKullaniciID = SAT.TalepEdenKullaniciID
        FROM dbo.SatinAlmaTalepleri SAT
        WHERE SAT.TalepNo = @TalepNo;

        IF @Miktar IS NULL
        BEGIN
            THROW 50001, N'Belirtilen talep bulunamadı.', 1;
        END;

        SET @ToplamTutar = @Miktar * @BirimFiyat;

        INSERT INTO dbo.Teklifler
        (
            TeklifNo,
            TalepID,
            TedarikciID,
            TeklifGirenKullaniciID,
            TeklifTutari,
            TeslimSuresiGun,
            SKT,
            TeklifTarihi,
            GecerlilikTarihi,
            ParaBirimi,
            TeklifDurumID
        )
        SELECT
            N'GEÇİCİ',
            SAT.TalepID,
            TED.TedarikciID,
            @TeklifGirenKullaniciID,
            @ToplamTutar,
            @TeslimSuresiGun,
            @SKT,
            GETDATE(),
            @GecerlilikTarihi,
            @ParaBirimi,
            0
        FROM dbo.SatinAlmaTalepleri SAT
        INNER JOIN dbo.Firmalar F
            ON F.FirmaAdi = @FirmaAdi
        INNER JOIN dbo.Tedarikciler TED
            ON TED.FirmaID = F.FirmaID
        WHERE SAT.TalepNo = @TalepNo;

        SET @YeniTeklifID = SCOPE_IDENTITY();

        IF @YeniTeklifID IS NULL
        BEGIN
            THROW 50002, N'Firma veya tedarikçi bulunamadı.', 1;
        END;

        SET @YeniTeklifNo =
            CONCAT
            (
                N'TK',
                RIGHT
                (
                    N'0000' + CAST(@YeniTeklifID AS NVARCHAR(10)),
                    4
                )
            );

        UPDATE dbo.Teklifler
        SET TeklifNo = @YeniTeklifNo
        WHERE TeklifID = @YeniTeklifID;

        INSERT INTO dbo.TeklifKalemleri
        (
            TeklifID,
            KalemAdi,
            KalemAciklamasi,
            Miktar,
            Birim,
            BirimFiyat,
            ToplamTutar
        )
        SELECT
            @YeniTeklifID,
            SAT.UrunAdi,
            SAT.Aciklama,
            SAT.Miktar,
            SAT.Birim,
            @BirimFiyat,
            @ToplamTutar
        FROM dbo.SatinAlmaTalepleri SAT
        WHERE SAT.TalepNo = @TalepNo;

        UPDATE dbo.SatinAlmaTalepleri
        SET TalepDurumID = 1
        WHERE TalepNo = @TalepNo;

        ;WITH Alicilar AS
        (
            SELECT K.KullaniciID
            FROM dbo.Kullanicilar K
            WHERE K.KullaniciID = @TalepEdenKullaniciID
              AND K.Durum = 1

            UNION

            SELECT K.KullaniciID
            FROM dbo.Kullanicilar K
            INNER JOIN dbo.Roller R ON R.RolID = K.RolID
            WHERE K.Durum = 1
              AND R.RolAdi IN (N'Satın Alma Yöneticisi', N'Satın Alma Uzmanı')
        )
        INSERT INTO dbo.Bildirimler
        (
            KullaniciID,
            Baslik,
            Mesaj,
            OkunduMu,
            OlusturmaTarihi,
            OkunmaTarihi
        )
        SELECT
            A.KullaniciID,
            N'Yeni Teklif Girildi',
            CONCAT(@TalepNo, N' numaralı talep için ', @YeniTeklifNo, N' numaralı yeni teklif girildi.'),
            0,
            GETDATE(),
            NULL
        FROM Alicilar A;

        COMMIT TRANSACTION;

        SELECT
            @YeniTeklifID AS TeklifID,
            @YeniTeklifNo AS TeklifNo,
            @Miktar AS Miktar,
            @BirimFiyat AS BirimFiyat,
            @ToplamTutar AS ToplamTutar,
            N'Teklifler Alındı' AS TalepDurumu;

    END TRY
    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO


/* =========================================================
   3. Talep reddedildiğinde bildirim üretir
   Bildirim alıcısı:
   - Sadece ilgili talebi oluşturan kullanıcı
   ========================================================= */

CREATE OR ALTER PROCEDURE dbo.sp_TalebiReddet
    @TalepNo NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @TalepID INT;
    DECLARE @TalepEdenKullaniciID INT;

    SELECT
        @TalepID = SAT.TalepID,
        @TalepEdenKullaniciID = SAT.TalepEdenKullaniciID
    FROM dbo.SatinAlmaTalepleri SAT
    WHERE SAT.TalepNo = @TalepNo;

    IF @TalepID IS NULL
    BEGIN
        THROW 50001, N'Belirtilen talep bulunamadı.', 1;
    END;

    BEGIN TRANSACTION;

    BEGIN TRY

        UPDATE dbo.SatinAlmaTalepleri
        SET TalepDurumID = 3
        WHERE TalepID = @TalepID;

        UPDATE dbo.Teklifler
        SET TeklifDurumID = 2
        WHERE TalepID = @TalepID;

        INSERT INTO dbo.Bildirimler
        (
            KullaniciID,
            Baslik,
            Mesaj,
            OkunduMu,
            OlusturmaTarihi,
            OkunmaTarihi
        )
        SELECT
            @TalepEdenKullaniciID,
            N'Talebiniz Reddedildi',
            CONCAT(@TalepNo, N' numaralı satın alma talebiniz reddedildi.'),
            0,
            GETDATE(),
            NULL
        WHERE @TalepEdenKullaniciID IS NOT NULL;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO


/* =========================================================
   4. Sipariş oluşturulduğunda bildirim üretir
   Bildirim alıcıları:
   - Satın Alma Yöneticisi: tüm sipariş bildirimleri
   - Satın Alma Uzmanı: tüm sipariş bildirimleri
   - Talep Oluşturan Kullanıcı: sadece kendi talebinden oluşan sipariş bildirimi
   ========================================================= */

CREATE OR ALTER PROCEDURE dbo.sp_SiparisOlustur
    @TeklifID INT,
    @OnaylayanKullaniciID INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @OlusanSiparis TABLE
    (
        SiparisID INT,
        SiparisNo NVARCHAR(20),
        TalepID INT,
        TeklifID INT,
        TalepNo NVARCHAR(20),
        TalepEdenKullaniciID INT
    );

    BEGIN TRANSACTION;

    BEGIN TRY

        INSERT INTO dbo.SatinAlmaSiparisleri
        (
            SiparisNo,
            TalepID,
            TeklifID,
            OnaylayanKullaniciID,
            SiparisTarihi,
            SiparisDurumID
        )
        OUTPUT
            INSERTED.SiparisID,
            INSERTED.SiparisNo,
            INSERTED.TalepID,
            INSERTED.TeklifID,
            NULL,
            NULL
        INTO @OlusanSiparis
        SELECT
            CONCAT
            (
                N'SP',
                RIGHT(N'0000' + CAST(T.TeklifID AS NVARCHAR(10)), 4)
            ),
            T.TalepID,
            T.TeklifID,
            @OnaylayanKullaniciID,
            GETDATE(),
            0
        FROM dbo.Teklifler T
        WHERE T.TeklifID = @TeklifID
          AND T.TeklifDurumID = 1
          AND NOT EXISTS
          (
              SELECT 1
              FROM dbo.SatinAlmaSiparisleri S
              WHERE S.TeklifID = T.TeklifID
          );

        UPDATE OS
        SET
            OS.TalepNo = SAT.TalepNo,
            OS.TalepEdenKullaniciID = SAT.TalepEdenKullaniciID
        FROM @OlusanSiparis OS
        INNER JOIN dbo.SatinAlmaTalepleri SAT 
            ON SAT.TalepID = OS.TalepID;

        ;WITH Alicilar AS
        (
            SELECT 
                OS.SiparisNo,
                OS.TalepNo,
                K.KullaniciID
            FROM @OlusanSiparis OS
            CROSS JOIN dbo.Kullanicilar K
            INNER JOIN dbo.Roller R 
                ON R.RolID = K.RolID
            WHERE K.Durum = 1
              AND R.RolAdi IN (N'Satın Alma Yöneticisi', N'Satın Alma Uzmanı')

            UNION

            SELECT
                OS.SiparisNo,
                OS.TalepNo,
                K.KullaniciID
            FROM @OlusanSiparis OS
            INNER JOIN dbo.Kullanicilar K 
                ON K.KullaniciID = OS.TalepEdenKullaniciID
            WHERE K.Durum = 1
        )
        INSERT INTO dbo.Bildirimler
        (
            KullaniciID,
            Baslik,
            Mesaj,
            OkunduMu,
            OlusturmaTarihi,
            OkunmaTarihi
        )
        SELECT
            A.KullaniciID,
            N'Sipariş Oluşturuldu',
            CONCAT(A.TalepNo, N' numaralı talep için ', A.SiparisNo, N' numaralı satın alma siparişi oluşturuldu.'),
            0,
            GETDATE(),
            NULL
        FROM Alicilar A;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO


/* =========================================================
   NOT:
   Günlük kontrol bildirimleri için ayrıca sp_BildirimGunlukKontrol
   procedure’ü hazırlanabilir.

   Örnek günlük kontrol bildirimleri:
   - Son teklif tarihine 3 gün kaldı
   - Teklif için bugün son gün
   - Uzun süredir teklif bekleyen talep
   - Onay bekleyen satın alma
   - Tamamlanmayan satın alma talebi

   Bu procedure SQL Server Agent veya uygulama tarafındaki
   zamanlanmış servis ile çalıştırılabilir.
   ========================================================= */