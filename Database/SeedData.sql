/*
    Pizza Satın Alma Yönetimi - Örnek Veri Senaryosu

    Bu dosyada doğrudan DELETE veya UPDATE bulunmaz. Yalnızca hedef kayıt
    sayılarına ulaşmak için eksik örnek veriler eklenir. Talep, teklif, seçim ve
    sipariş işlemlerinde ana şemadaki prosedürlerin kendi durum geçişleri çalışır.
    Tüm akış tek transaction içindedir; hata halinde işlemler geri alınır.

    Örnek kullanıcıların parola değerleri, düz metin parola içermeyen rastgele
    test hash/salt değerleridir. Bu hesaplar uygulamada oturum açma amacı taşımaz.
*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @HedefKullanici int = 20,
            @HedefTedarikci int = 30,
            @HedefTalep int = 100,
            @HedefTeklif int = 300,
            @HedefSiparis int = 40,
            @HedefBildirim int = 120;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Roller
        WHERE RolAdi IN
        (
            N'Satın Alma Yöneticisi',
            N'Satın Alma Uzmanı',
            N'Talep Oluşturan Kullanıcı',
            N'Tedarikçi'
        )
    )
        THROW 51000, N'Örnek veri için gerekli roller veritabanında bulunamadı.', 1;

    /* Kullanıcılar: mevcut sayı 20'nin altındaysa eksik kadar eklenir. */
    DECLARE @Sira int = 1,
            @Kod nvarchar(20),
            @RolID int,
            @KullaniciAdi nvarchar(50),
            @Eposta nvarchar(254),
            @Salt varbinary(32),
            @Hash varbinary(64);

    WHILE (SELECT COUNT(*) FROM dbo.Kullanicilar) < @HedefKullanici
    BEGIN
        SET @Kod = RIGHT(N'000' + CONVERT(nvarchar(10), @Sira), 3);
        SET @KullaniciAdi = N'seed.kullanici.' + @Kod;
        SET @Eposta = N'seed.kullanici.' + @Kod + N'@ornek.local';

        IF NOT EXISTS (SELECT 1 FROM dbo.Kullanicilar WHERE KullaniciAdi = @KullaniciAdi OR Eposta = @Eposta)
        BEGIN
            SELECT @RolID = RolID
            FROM dbo.Roller
            WHERE RolAdi = CASE @Sira % 4
                WHEN 1 THEN N'Satın Alma Yöneticisi'
                WHEN 2 THEN N'Satın Alma Uzmanı'
                WHEN 3 THEN N'Talep Oluşturan Kullanıcı'
                ELSE N'Tedarikçi'
            END;

            SET @Salt = HASHBYTES('SHA2_256', CONVERT(varbinary(max), NEWID()));
            SET @Hash = HASHBYTES('SHA2_512', @Salt + CONVERT(varbinary(max), NEWID()));

            INSERT dbo.Kullanicilar
                (RolID, AdSoyad, KullaniciAdi, SifreHash, SifreSalt, Eposta, Durum, SonGirisTarihi, KayitTarihi)
            VALUES
                (@RolID, N'Örnek Kullanıcı ' + @Kod, @KullaniciAdi, @Hash, @Salt,
                 @Eposta, 1, NULL, DATEADD(DAY, -(@Sira % 180), GETDATE()));
        END;

        SET @Sira += 1;
    END;

    /* Firmalar, tedarikçiler ve firma kullanıcıları. */
    SET @Sira = 1;
    DECLARE @FirmaID int,
            @FirmaAdi nvarchar(150),
            @VergiNo nvarchar(20),
            @FirmaEposta nvarchar(254);

    WHILE (SELECT COUNT(*) FROM dbo.Tedarikciler) < @HedefTedarikci
    BEGIN
        SET @Kod = RIGHT(N'000' + CONVERT(nvarchar(10), @Sira), 3);
        SET @FirmaAdi = CASE @Sira % 4
            WHEN 1 THEN N'Seed Anadolu Gıda Tedarik '
            WHEN 2 THEN N'Seed Marmara Ambalaj Çözümleri '
            WHEN 3 THEN N'Seed Ege Hijyen Ürünleri '
            ELSE N'Seed Trakya Lojistik ve Dağıtım '
        END + @Kod + N' Ltd. Şti.';
        SET @VergiNo = N'95' + RIGHT(N'00000000' + CONVERT(nvarchar(10), @Sira), 8);
        SET @FirmaEposta = N'seed.firma.' + @Kod + N'@ornek.local';

        IF NOT EXISTS (SELECT 1 FROM dbo.Firmalar WHERE FirmaAdi = @FirmaAdi OR VergiNo = @VergiNo)
        BEGIN
            INSERT dbo.Firmalar (FirmaAdi, VergiNo, Telefon, Adres, Eposta)
            VALUES
            (
                @FirmaAdi, @VergiNo,
                N'0212 555 ' + RIGHT(N'0000' + CONVERT(nvarchar(10), @Sira), 4),
                N'Örnek Sanayi Bölgesi No: ' + CONVERT(nvarchar(10), @Sira) + N', İstanbul',
                @FirmaEposta
            );
            SET @FirmaID = CONVERT(int, SCOPE_IDENTITY());
        END
        ELSE
            SELECT TOP (1) @FirmaID = FirmaID
            FROM dbo.Firmalar
            WHERE FirmaAdi = @FirmaAdi OR VergiNo = @VergiNo
            ORDER BY FirmaID;

        IF NOT EXISTS (SELECT 1 FROM dbo.Tedarikciler WHERE FirmaID = @FirmaID)
            INSERT dbo.Tedarikciler (FirmaID, TedarikciDurumID, KayitTarihi)
            VALUES (@FirmaID, CASE WHEN @Sira % 10 = 0 THEN 0 ELSE 1 END, DATEADD(DAY, -(@Sira % 365), GETDATE()));

        IF NOT EXISTS (SELECT 1 FROM dbo.FirmaKullanicilari WHERE FirmaID = @FirmaID)
           AND NOT EXISTS (SELECT 1 FROM dbo.FirmaKullanicilari WHERE Eposta = N'seed.firma.kullanici.' + @Kod + N'@ornek.local')
            INSERT dbo.FirmaKullanicilari (FirmaID, AdSoyad, Telefon, Eposta, Gorev)
            VALUES
            (
                @FirmaID, N'Örnek Firma Yetkilisi ' + @Kod,
                N'0532 555 ' + RIGHT(N'0000' + CONVERT(nvarchar(10), @Sira), 4),
                N'seed.firma.kullanici.' + @Kod + N'@ornek.local', N'Satış Yetkilisi'
            );

        SET @Sira += 1;
    END;

    DECLARE @TalepEdenSayisi int =
    (
        SELECT COUNT(*)
        FROM dbo.Kullanicilar k
        INNER JOIN dbo.Roller r ON r.RolID = k.RolID
        WHERE k.Durum = 1
          AND r.RolAdi IN (N'Talep Oluşturan Kullanıcı', N'Satın Alma Uzmanı', N'Satın Alma Yöneticisi')
    );

    IF @TalepEdenSayisi = 0
        THROW 51001, N'Talep oluşturabilecek aktif kullanıcı bulunamadı.', 1;

    /* Satın alma talepleri: pizza fabrikasına uygun 20 ürün döngüsel kullanılır. */
    SET @Sira = 1;
    DECLARE @TalepNo nvarchar(20),
            @TalepEdenID int,
            @UrunAdi nvarchar(150),
            @Birim nvarchar(20),
            @Miktar decimal(10,2),
            @TalepTarihi datetime;

    WHILE (SELECT COUNT(*) FROM dbo.SatinAlmaTalepleri) < @HedefTalep
    BEGIN
        ;WITH TalepEdenler AS
            (
                SELECT k.KullaniciID, ROW_NUMBER() OVER (ORDER BY k.KullaniciID) AS rn
                FROM dbo.Kullanicilar k
                INNER JOIN dbo.Roller r ON r.RolID = k.RolID
                WHERE k.Durum = 1
                  AND r.RolAdi IN (N'Talep Oluşturan Kullanıcı', N'Satın Alma Uzmanı', N'Satın Alma Yöneticisi')
            )
            SELECT @TalepEdenID = KullaniciID
            FROM TalepEdenler
            WHERE rn = ((@Sira - 1) % @TalepEdenSayisi) + 1;

            SET @UrunAdi = CASE ((@Sira - 1) % 20) + 1
                WHEN 1 THEN N'Mozzarella peyniri' WHEN 2 THEN N'Kaşar peyniri'
                WHEN 3 THEN N'Domates sosu' WHEN 4 THEN N'Un' WHEN 5 THEN N'Maya'
                WHEN 6 THEN N'Zeytin' WHEN 7 THEN N'Mantar' WHEN 8 THEN N'Sucuk'
                WHEN 9 THEN N'Salam' WHEN 10 THEN N'Biber' WHEN 11 THEN N'Mısır'
                WHEN 12 THEN N'Pizza kutusu' WHEN 13 THEN N'Ambalaj malzemesi'
                WHEN 14 THEN N'Eldiven' WHEN 15 THEN N'Bone'
                WHEN 16 THEN N'Temizlik malzemesi' WHEN 17 THEN N'Streç film'
                WHEN 18 THEN N'Peçete' WHEN 19 THEN N'Ketçap' ELSE N'Mayonez' END;
            SET @Birim = CASE
                WHEN @UrunAdi IN (N'Pizza kutusu', N'Eldiven', N'Bone', N'Peçete') THEN N'Adet'
                WHEN @UrunAdi IN (N'Domates sosu', N'Ketçap', N'Mayonez', N'Temizlik malzemesi') THEN N'Litre'
                WHEN @UrunAdi IN (N'Ambalaj malzemesi', N'Streç film') THEN N'Rulo'
                ELSE N'Kg' END;
            SET @Miktar = CASE @Birim
                WHEN N'Adet' THEN 2000 + (@Sira % 20) * 500
                WHEN N'Litre' THEN 300 + (@Sira % 15) * 50
                WHEN N'Rulo' THEN 100 + (@Sira % 10) * 25
                ELSE 500 + (@Sira % 20) * 100 END;
        EXEC dbo.sp_TalepEkle
            @TalepEdenKullaniciID = @TalepEdenID,
            @UrunAdi = @UrunAdi,
            @Miktar = @Miktar,
            @Birim = @Birim,
            @Aciklama = N'Pizza üretim fabrikası örnek satın alma ihtiyacı.';

        SET @Sira += 1;
    END;

    DECLARE @TedarikciSayisi int = (SELECT COUNT(*) FROM dbo.Tedarikciler WHERE TedarikciDurumID = 1),
            @TalepSayisi int = (SELECT COUNT(*) FROM dbo.SatinAlmaTalepleri),
            @TeklifGirenID int;

    SELECT TOP (1) @TeklifGirenID = k.KullaniciID
    FROM dbo.Kullanicilar k
    INNER JOIN dbo.Roller r ON r.RolID = k.RolID
    WHERE k.Durum = 1 AND r.RolAdi IN (N'Satın Alma Uzmanı', N'Satın Alma Yöneticisi')
    ORDER BY CASE r.RolAdi WHEN N'Satın Alma Uzmanı' THEN 0 ELSE 1 END, k.KullaniciID;

    IF @TedarikciSayisi = 0 OR @TalepSayisi = 0 OR @TeklifGirenID IS NULL
        THROW 51002, N'Teklif örnekleri için aktif tedarikçi, talep veya satın alma kullanıcısı bulunamadı.', 1;

    /* Teklifler ve her teklif için şemadaki gerçek kalem yapısına uygun tek kalem. */
    SET @Sira = 1;
    DECLARE @TalepID int,
            @TedarikciID int,
            @FirmaAdiSecilen nvarchar(150),
            @TeklifID int,
            @TeklifTarihi datetime,
            @BirimFiyat decimal(18,2),
            @Toplam decimal(18,2),
            @TeklifDurumID int,
            @SeedSKT date,
            @SeedGecerlilikTarihi date,
            @SeedTeslimSuresi int;

    WHILE (SELECT COUNT(*) FROM dbo.Teklifler) < @HedefTeklif
    BEGIN
        ;WITH Talepler AS
            (
                SELECT TalepID, TalepNo, UrunAdi, Miktar, Birim, TalepTarihi,
                       ROW_NUMBER() OVER (ORDER BY TalepID) rn
                FROM dbo.SatinAlmaTalepleri
            )
            SELECT @TalepID = TalepID, @TalepNo = TalepNo, @UrunAdi = UrunAdi,
                   @Miktar = Miktar, @Birim = Birim, @TalepTarihi = TalepTarihi
            FROM Talepler WHERE rn = ((@Sira - 1) % @TalepSayisi) + 1;

            ;WITH TedarikciSirasi AS
            (
                SELECT t.TedarikciID, f.FirmaAdi, ROW_NUMBER() OVER (ORDER BY t.TedarikciID) rn
                FROM dbo.Tedarikciler t
                INNER JOIN dbo.Firmalar f ON f.FirmaID = t.FirmaID
                WHERE t.TedarikciDurumID = 1
            )
            SELECT @TedarikciID = TedarikciID, @FirmaAdiSecilen = FirmaAdi
            FROM TedarikciSirasi
            WHERE rn = (((@Sira - 1) + ((@Sira - 1) / @TalepSayisi) * 7) % @TedarikciSayisi) + 1;

            SET @TeklifTarihi = DATEADD(DAY, 1 + (@Sira % 7), @TalepTarihi);
            IF @TeklifTarihi > GETDATE() SET @TeklifTarihi = GETDATE();
            SET @BirimFiyat = CASE @Birim
                WHEN N'Adet' THEN 1.25 + (@Sira % 12) * 0.35
                WHEN N'Litre' THEN 28.00 + (@Sira % 14) * 3.25
                WHEN N'Rulo' THEN 42.00 + (@Sira % 15) * 4.50
                ELSE 35.00 + (@Sira % 18) * 6.75 END;
            SET @Toplam = ROUND(@Miktar * @BirimFiyat, 2);
            SET @SeedTeslimSuresi = 2 + (@Sira % 13);
            SET @SeedSKT = CASE WHEN @UrunAdi IN
                (N'Pizza kutusu', N'Ambalaj malzemesi', N'Eldiven', N'Bone', N'Temizlik malzemesi', N'Streç film', N'Peçete')
                THEN NULL ELSE DATEADD(DAY, 90 + (@Sira % 10) * 30, CONVERT(date, GETDATE())) END;
            SET @SeedGecerlilikTarihi = DATEADD(DAY, 15 + (@Sira % 31), CONVERT(date, GETDATE()));

            SET @TeklifDurumID = CASE ((@Sira - 1) / @TalepSayisi) % 3
                WHEN 0 THEN 0 WHEN 1 THEN 1 ELSE 2 END;
            IF @TeklifDurumID = 1
               AND EXISTS (SELECT 1 FROM dbo.Teklifler WHERE TalepID = @TalepID AND TeklifDurumID = 1)
                SET @TeklifDurumID = 2;

            EXEC dbo.sp_TeklifEkle
                @TalepNo = @TalepNo,
                @FirmaAdi = @FirmaAdiSecilen,
                @TeklifGirenKullaniciID = @TeklifGirenID,
                @BirimFiyat = @BirimFiyat,
                @TeslimSuresiGun = @SeedTeslimSuresi,
                @SKT = @SeedSKT,
                @GecerlilikTarihi = @SeedGecerlilikTarihi,
                @ParaBirimi = 'TRY';
        SET @Sira += 1;
    END;

    /* Teklif durumları, uygulamadaki seçim iş kuralı üzerinden oluşturulur. */
    DECLARE @DurumSira int = 0,
            @SecilecekTeklifNo nvarchar(20);

    WHILE @DurumSira < 25
    BEGIN
        SET @SecilecekTeklifNo = NULL;

        SELECT TOP (1) @SecilecekTeklifNo = t.TeklifNo
        FROM dbo.Teklifler t
        WHERE t.TeklifDurumID = 0
          AND NOT EXISTS
              (SELECT 1 FROM dbo.Teklifler x WHERE x.TalepID = t.TalepID AND x.TeklifDurumID = 1)
          AND (SELECT COUNT(*) FROM dbo.Teklifler x WHERE x.TalepID = t.TalepID AND x.TeklifDurumID = 0) >= 2
        ORDER BY t.TalepID, t.TeklifTutari, t.TeklifID;

        IF @SecilecekTeklifNo IS NULL BREAK;
        EXEC dbo.sp_TeklifSec @TeklifNo = @SecilecekTeklifNo;
        SET @DurumSira += 1;
    END;

    /* Seçilmiş ve henüz siparişe bağlanmamış teklifler üzerinden siparişler. */
    DECLARE @OnaylayanID int;
    SELECT TOP (1) @OnaylayanID = k.KullaniciID
    FROM dbo.Kullanicilar k
    INNER JOIN dbo.Roller r ON r.RolID = k.RolID
    WHERE k.Durum = 1 AND r.RolAdi = N'Satın Alma Yöneticisi'
    ORDER BY k.KullaniciID;

    IF @OnaylayanID IS NOT NULL
    BEGIN
        DECLARE @SiparisTeklifID int,
                @YeniSiparisNo nvarchar(20),
                @YeniSiparisDurum int;

        WHILE (SELECT COUNT(*) FROM dbo.SatinAlmaSiparisleri) < @HedefSiparis
        BEGIN
            SELECT TOP (1) @SiparisTeklifID = t.TeklifID
            FROM dbo.Teklifler t
            WHERE t.TeklifDurumID = 1
              AND NOT EXISTS (SELECT 1 FROM dbo.SatinAlmaSiparisleri s WHERE s.TeklifID = t.TeklifID)
            ORDER BY t.TeklifID;

            IF @SiparisTeklifID IS NULL BREAK;
            EXEC dbo.sp_SiparisOlustur
                @TeklifID = @SiparisTeklifID,
                @OnaylayanKullaniciID = @OnaylayanID;

            SELECT @YeniSiparisNo = SiparisNo
            FROM dbo.SatinAlmaSiparisleri
            WHERE TeklifID = @SiparisTeklifID;
            SET @YeniSiparisDurum = (SELECT COUNT(*) FROM dbo.SatinAlmaSiparisleri) % 3;
            IF @YeniSiparisDurum <> 0
                EXEC dbo.sp_SiparisDurumuGuncelle
                    @SiparisNo = @YeniSiparisNo,
                    @YeniDurum = @YeniSiparisDurum;

            SET @SiparisTeklifID = NULL;
        END;
    END;

    /* Kullanıcılara süreç adımlarını temsil eden bildirimler. */
    SET @Sira = 1;
    DECLARE @KullaniciSayisi int = (SELECT COUNT(*) FROM dbo.Kullanicilar),
            @BildirimKullaniciID int,
            @Baslik nvarchar(100),
            @Mesaj nvarchar(500),
            @OkunduMu bit,
            @OlusturmaTarihi datetime;

    WHILE (SELECT COUNT(*) FROM dbo.Bildirimler) < @HedefBildirim
    BEGIN
        ;WITH KullaniciSirasi AS
        (
            SELECT KullaniciID, ROW_NUMBER() OVER (ORDER BY KullaniciID) rn
            FROM dbo.Kullanicilar
        )
        SELECT @BildirimKullaniciID = KullaniciID
        FROM KullaniciSirasi
        WHERE rn = ((@Sira - 1) % @KullaniciSayisi) + 1;

        SELECT @Baslik = CASE @Sira % 7
                WHEN 1 THEN N'Yeni talep oluşturuldu' WHEN 2 THEN N'Teklif girildi'
                WHEN 3 THEN N'Teklif seçildi' WHEN 4 THEN N'Teklif reddedildi'
                WHEN 5 THEN N'Sipariş oluşturuldu' WHEN 6 THEN N'Onay bekleyen satın alma'
                ELSE N'Yaklaşan teklif geçerlilik tarihi' END,
               @Mesaj = CASE @Sira % 7
                WHEN 1 THEN N'Yeni bir satın alma talebi incelemeniz için oluşturuldu.'
                WHEN 2 THEN N'Bir satın alma talebine yeni tedarikçi teklifi girildi.'
                WHEN 3 THEN N'Talebe ait teklifler arasından uygun teklif seçildi.'
                WHEN 4 THEN N'Değerlendirme sonucunda bir tedarikçi teklifi reddedildi.'
                WHEN 5 THEN N'Seçilen teklif üzerinden satın alma siparişi oluşturuldu.'
                WHEN 6 THEN N'Onayınızı bekleyen bir satın alma işlemi bulunuyor.'
                ELSE N'Bir teklifin geçerlilik tarihi yaklaşıyor.' END;

        SET @OkunduMu = CASE WHEN @Sira % 3 = 0 THEN 1 ELSE 0 END;
        SET @OlusturmaTarihi = DATEADD(HOUR, -(@Sira * 5), GETDATE());

        INSERT dbo.Bildirimler
            (KullaniciID, Baslik, Mesaj, OkunduMu, OlusturmaTarihi, OkunmaTarihi)
        VALUES
            (@BildirimKullaniciID, @Baslik, @Mesaj, @OkunduMu, @OlusturmaTarihi,
             CASE WHEN @OkunduMu = 1 THEN DATEADD(HOUR, 2, @OlusturmaTarihi) ELSE NULL END);

        SET @Sira += 1;
    END;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;
