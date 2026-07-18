/*
    Pizza Fabrikası Satın Alma Yönetimi - Büyük Demo Veri Seti

    Bu betik yalnızca eksik demo kayıtlarını ekler; mevcut kayıtları değiştirmez.
    Tekrar çalıştırıldığında KullaniciAdi, VergiNo, TalepNo, TeklifNo,
    SiparisNo ve bildirim mesajındaki LARGE kodları üzerinden aynı kayıtları
    yeniden eklemez.

    Demo kullanıcı parolaları ctassin kullanıcısının SifreHash/SifreSalt
    değerlerini kullanır. ctassin yoksa önce bu kullanıcı oluşturulmalıdır.
*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @HedefKullanici int = 30,
            @HedefTedarikci int = 30,
            @HedefTalep int = 150,
            @HedefTeklif int = 500,
            @HedefSiparis int = 50,
            @HedefBildirim int = 100;

    DECLARE @OrnekHash varbinary(64), @OrnekSalt varbinary(32);
    SELECT TOP (1) @OrnekHash = SifreHash, @OrnekSalt = SifreSalt
    FROM dbo.Kullanicilar
    WHERE KullaniciAdi = N'ctassin';

    IF @OrnekHash IS NULL OR @OrnekSalt IS NULL
        THROW 52000, N'Büyük örnek veri için önce ctassin kullanıcısı oluşturulmalıdır.', 1;

    IF (SELECT COUNT(*) FROM dbo.Roller WHERE RolAdi IN
        (N'Satın Alma Yöneticisi', N'Satın Alma Uzmanı', N'Talep Oluşturan Kullanıcı')) <> 3
        THROW 52001, N'Gerekli iç kullanıcı rolleri bulunamadı.', 1;

    /* Yalnızca üç iç kullanıcı rolünde, benzersiz demo kullanıcıları. */
    DECLARE @Sira int = 1, @Kod nvarchar(10), @RolID int,
            @KullaniciAdi nvarchar(50), @KullaniciEposta nvarchar(254);

    WHILE
    (
        SELECT COUNT(*)
        FROM dbo.Kullanicilar k
        INNER JOIN dbo.Roller r ON r.RolID = k.RolID
        WHERE r.RolAdi IN
            (N'Satın Alma Yöneticisi', N'Satın Alma Uzmanı', N'Talep Oluşturan Kullanıcı')
    ) < @HedefKullanici
    BEGIN
        IF @Sira > 9999 THROW 52002, N'Kullanıcı hedefi tamamlanamadı.', 1;
        SET @Kod = RIGHT(N'0000' + CONVERT(nvarchar(10), @Sira), 4);
        SET @KullaniciAdi = N'large.demo.' + @Kod;
        SET @KullaniciEposta = N'large.demo.' + @Kod + N'@pizza-fabrika.test';

        SELECT @RolID = RolID
        FROM dbo.Roller
        WHERE RolAdi = CASE @Sira % 3
            WHEN 1 THEN N'Talep Oluşturan Kullanıcı'
            WHEN 2 THEN N'Satın Alma Uzmanı'
            ELSE N'Satın Alma Yöneticisi' END;

        IF NOT EXISTS
        (
            SELECT 1 FROM dbo.Kullanicilar
            WHERE KullaniciAdi = @KullaniciAdi OR Eposta = @KullaniciEposta
        )
            INSERT dbo.Kullanicilar
                (RolID, AdSoyad, KullaniciAdi, SifreHash, SifreSalt, Eposta,
                 Durum, SonGirisTarihi, KayitTarihi)
            VALUES
                (@RolID, N'Büyük Demo Kullanıcı ' + @Kod, @KullaniciAdi,
                 @OrnekHash, @OrnekSalt, @KullaniciEposta, 1, NULL,
                 DATEADD(DAY, -(@Sira % 240), GETDATE()));

        SET @Sira += 1;
    END;

    /* Dış firma, tedarikçi ve firma yetkilisi kayıtları. */
    SET @Sira = 1;
    DECLARE @FirmaID int, @FirmaAdi nvarchar(150), @VergiNo nvarchar(20),
            @FirmaEposta nvarchar(254), @YetkiliEposta nvarchar(100);

    WHILE (SELECT COUNT(*) FROM dbo.Tedarikciler) < @HedefTedarikci
    BEGIN
        IF @Sira > 9999 THROW 52003, N'Tedarikçi hedefi tamamlanamadı.', 1;
        SET @Kod = RIGHT(N'0000' + CONVERT(nvarchar(10), @Sira), 4);
        SET @FirmaAdi = CASE @Sira % 5
            WHEN 1 THEN N'Anadolu Pizza Hammaddeleri '
            WHEN 2 THEN N'Marmara Ambalaj Sanayi '
            WHEN 3 THEN N'Ege Süt ve Gıda Ürünleri '
            WHEN 4 THEN N'Akdeniz Hijyen Çözümleri '
            ELSE N'Trakya Endüstriyel Tedarik ' END + @Kod;
        SET @VergiNo = N'97' + RIGHT(N'00000000' + CONVERT(nvarchar(10), @Sira), 8);
        SET @FirmaEposta = N'large.firma.' + @Kod + N'@pizza-tedarik.test';
        SET @FirmaID = NULL;

        SELECT TOP (1) @FirmaID = FirmaID
        FROM dbo.Firmalar
        WHERE VergiNo = @VergiNo OR FirmaAdi = @FirmaAdi;

        IF @FirmaID IS NULL
        BEGIN
            INSERT dbo.Firmalar (FirmaAdi, VergiNo, Telefon, Adres, Eposta)
            VALUES
            (
                @FirmaAdi, @VergiNo,
                N'0212 700 ' + RIGHT(N'0000' + CONVERT(nvarchar(10), @Sira), 4),
                N'Pizza Fabrikası Tedarikçiler Bölgesi No: '
                    + CONVERT(nvarchar(10), @Sira) + N', İstanbul',
                @FirmaEposta
            );
            SET @FirmaID = CONVERT(int, SCOPE_IDENTITY());
        END;

        IF NOT EXISTS (SELECT 1 FROM dbo.Tedarikciler WHERE FirmaID = @FirmaID)
            INSERT dbo.Tedarikciler (FirmaID, TedarikciDurumID, KayitTarihi)
            VALUES (@FirmaID, CASE WHEN @Sira % 10 = 0 THEN 0 ELSE 1 END,
                    DATEADD(DAY, -(@Sira % 365), SYSDATETIME()));

        SET @YetkiliEposta = N'large.yetkili.' + @Kod + N'@pizza-tedarik.test';
        IF NOT EXISTS (SELECT 1 FROM dbo.FirmaKullanicilari WHERE FirmaID = @FirmaID)
           AND NOT EXISTS (SELECT 1 FROM dbo.FirmaKullanicilari WHERE Eposta = @YetkiliEposta)
            INSERT dbo.FirmaKullanicilari (FirmaID, AdSoyad, Telefon, Eposta, Gorev)
            VALUES
            (
                @FirmaID, N'Tedarikçi Yetkilisi ' + @Kod,
                N'0532 700 ' + RIGHT(N'0000' + CONVERT(nvarchar(10), @Sira), 4),
                @YetkiliEposta, N'Kurumsal Satış Yetkilisi'
            );

        SET @Sira += 1;
    END;

    /* Yetkilisi bulunmayan mevcut tedarikçi firmalarına da bir yetkili eklenir. */
    INSERT dbo.FirmaKullanicilari (FirmaID, AdSoyad, Telefon, Eposta, Gorev)
    SELECT f.FirmaID,
           N'Firma Yetkilisi ' + CONVERT(nvarchar(10), f.FirmaID),
           N'0532 799 ' + RIGHT(N'0000' + CONVERT(nvarchar(10), f.FirmaID), 4),
           N'large.mevcut.yetkili.' + CONVERT(nvarchar(10), f.FirmaID) + N'@pizza-tedarik.test',
           N'Satış Yetkilisi'
    FROM dbo.Tedarikciler t
    INNER JOIN dbo.Firmalar f ON f.FirmaID = t.FirmaID
    WHERE NOT EXISTS (SELECT 1 FROM dbo.FirmaKullanicilari fk WHERE fk.FirmaID = f.FirmaID)
      AND NOT EXISTS
          (SELECT 1 FROM dbo.FirmaKullanicilari fk
           WHERE fk.Eposta = N'large.mevcut.yetkili.' + CONVERT(nvarchar(10), f.FirmaID) + N'@pizza-tedarik.test');

    /* Pizza fabrikasına uygun satın alma talepleri. */
    DECLARE @TalepEdenSayisi int =
    (
        SELECT COUNT(*) FROM dbo.Kullanicilar k
        INNER JOIN dbo.Roller r ON r.RolID = k.RolID
        WHERE k.Durum = 1
          AND r.RolAdi IN
              (N'Talep Oluşturan Kullanıcı', N'Satın Alma Uzmanı', N'Satın Alma Yöneticisi')
    );
    IF @TalepEdenSayisi = 0 THROW 52004, N'Talep oluşturabilecek kullanıcı bulunamadı.', 1;

    SET @Sira = 1;
    DECLARE @TalepNo nvarchar(20), @TalepEdenID int, @UrunAdi nvarchar(150),
            @Birim nvarchar(20), @Miktar decimal(10,2), @TalepTarihi datetime;

    WHILE (SELECT COUNT(*) FROM dbo.SatinAlmaTalepleri) < @HedefTalep
    BEGIN
        IF @Sira > 9999 THROW 52005, N'Talep hedefi tamamlanamadı.', 1;
        SET @TalepNo = N'ST' + RIGHT(N'0000' + CONVERT(nvarchar(10), @Sira), 4);

        IF NOT EXISTS (SELECT 1 FROM dbo.SatinAlmaTalepleri WHERE TalepNo = @TalepNo)
        BEGIN
            ;WITH TalepEdenler AS
            (
                SELECT k.KullaniciID, ROW_NUMBER() OVER (ORDER BY k.KullaniciID) rn
                FROM dbo.Kullanicilar k
                INNER JOIN dbo.Roller r ON r.RolID = k.RolID
                WHERE k.Durum = 1
                  AND r.RolAdi IN
                      (N'Talep Oluşturan Kullanıcı', N'Satın Alma Uzmanı', N'Satın Alma Yöneticisi')
            )
            SELECT @TalepEdenID = KullaniciID FROM TalepEdenler
            WHERE rn = ((@Sira - 1) % @TalepEdenSayisi) + 1;

            SET @UrunAdi = CASE ((@Sira - 1) % 20) + 1
                WHEN 1 THEN N'Pizza unu' WHEN 2 THEN N'Mozzarella peyniri'
                WHEN 3 THEN N'Domates sosu' WHEN 4 THEN N'Kuru maya'
                WHEN 5 THEN N'Siyah zeytin' WHEN 6 THEN N'Dana sucuk'
                WHEN 7 THEN N'Kültür mantarı' WHEN 8 THEN N'Yeşil biber'
                WHEN 9 THEN N'Pizza kutusu' WHEN 10 THEN N'Streç film'
                WHEN 11 THEN N'Gıda ambalajı' WHEN 12 THEN N'Temizlik deterjanı'
                WHEN 13 THEN N'Tek kullanımlık eldiven' WHEN 14 THEN N'Peçete'
                WHEN 15 THEN N'Mısır' WHEN 16 THEN N'Kaşar peyniri'
                WHEN 17 THEN N'Zeytinyağı' WHEN 18 THEN N'Kekik'
                WHEN 19 THEN N'Jalapeno biberi' ELSE N'Endüstriyel temizlik bezi' END;
            SET @Birim = CASE
                WHEN @UrunAdi IN (N'Pizza kutusu', N'Tek kullanımlık eldiven', N'Peçete') THEN N'Adet'
                WHEN @UrunAdi IN (N'Domates sosu', N'Temizlik deterjanı', N'Zeytinyağı') THEN N'Litre'
                WHEN @UrunAdi IN (N'Streç film', N'Gıda ambalajı') THEN N'Rulo'
                ELSE N'Kg' END;
            SET @Miktar = CASE @Birim
                WHEN N'Adet' THEN 1000 + (@Sira % 25) * 250
                WHEN N'Litre' THEN 200 + (@Sira % 18) * 25
                WHEN N'Rulo' THEN 80 + (@Sira % 12) * 20
                ELSE 300 + (@Sira % 24) * 50 END;
            SET @TalepTarihi = DATEADD(DAY, -(@Sira % 180), GETDATE());

            INSERT dbo.SatinAlmaTalepleri
                (TalepNo, TalepEdenKullaniciID, UrunAdi, Miktar, Birim,
                 TalepTarihi, TalepDurumID, Aciklama)
            VALUES
                (@TalepNo, @TalepEdenID, @UrunAdi, @Miktar, @Birim,
                 @TalepTarihi, @Sira % 4,
                 N'Pizza fabrikası büyük demo satın alma ihtiyacı.');
        END;
        SET @Sira += 1;
    END;

    /* Her talepte mümkün olduğunca 2-4 teklif olacak biçimde teklifler. */
    DECLARE @TeklifGirenSayisi int =
    (
        SELECT COUNT(*) FROM dbo.Kullanicilar k
        INNER JOIN dbo.Roller r ON r.RolID = k.RolID
        WHERE k.Durum = 1 AND r.RolAdi IN (N'Satın Alma Uzmanı', N'Satın Alma Yöneticisi')
    );
    IF @TeklifGirenSayisi = 0 THROW 52006, N'Teklif girebilecek kullanıcı bulunamadı.', 1;

    SET @Sira = 1;
    DECLARE @TeklifNo nvarchar(20), @TalepID int, @TedarikciID int,
            @TeklifGirenID int, @TeklifID int, @TeklifSayisi int,
            @TeklifTutari decimal(10,2), @BirimFiyat decimal(18,2),
            @ParaBirimi char(3), @TeklifDurumID int;

    WHILE (SELECT COUNT(*) FROM dbo.Teklifler) < @HedefTeklif
    BEGIN
        IF @Sira > 9999 THROW 52007, N'Teklif hedefi tamamlanamadı.', 1;
        SET @TeklifNo = N'TF' + RIGHT(N'0000' + CONVERT(nvarchar(10), @Sira), 4);

        IF NOT EXISTS (SELECT 1 FROM dbo.Teklifler WHERE TeklifNo = @TeklifNo)
        BEGIN
            SET @TalepID = NULL;
            SELECT TOP (1) @TalepID = sat.TalepID, @TalepNo = sat.TalepNo,
                           @UrunAdi = sat.UrunAdi, @Miktar = sat.Miktar,
                           @Birim = sat.Birim, @TalepTarihi = sat.TalepTarihi,
                           @TeklifSayisi = COUNT(t.TeklifID)
            FROM dbo.SatinAlmaTalepleri sat
            LEFT JOIN dbo.Teklifler t ON t.TalepID = sat.TalepID
            GROUP BY sat.TalepID, sat.TalepNo, sat.UrunAdi, sat.Miktar,
                     sat.Birim, sat.TalepTarihi
            HAVING COUNT(t.TeklifID) < 4
            ORDER BY COUNT(t.TeklifID), sat.TalepID;

            IF @TalepID IS NULL THROW 52008, N'2-4 teklif dağılımıyla teklif hedefi tamamlanamıyor.', 1;

            SELECT TOP (1) @TedarikciID = t.TedarikciID
            FROM dbo.Tedarikciler t
            WHERE t.TedarikciDurumID = 1
              AND NOT EXISTS
                  (SELECT 1 FROM dbo.Teklifler x
                   WHERE x.TalepID = @TalepID AND x.TedarikciID = t.TedarikciID)
            ORDER BY ABS(CHECKSUM(CONCAT(@Sira, N'-', t.TedarikciID)));
            IF @TedarikciID IS NULL THROW 52009, N'Teklif için uygun aktif tedarikçi bulunamadı.', 1;

            ;WITH TeklifGirenler AS
            (
                SELECT k.KullaniciID, ROW_NUMBER() OVER (ORDER BY k.KullaniciID) rn
                FROM dbo.Kullanicilar k
                INNER JOIN dbo.Roller r ON r.RolID = k.RolID
                WHERE k.Durum = 1
                  AND r.RolAdi IN (N'Satın Alma Uzmanı', N'Satın Alma Yöneticisi')
            )
            SELECT @TeklifGirenID = KullaniciID FROM TeklifGirenler
            WHERE rn = ((@Sira - 1) % @TeklifGirenSayisi) + 1;

            SET @BirimFiyat = CASE @Birim
                WHEN N'Adet' THEN 1.50 + (@Sira % 20) * 0.40
                WHEN N'Litre' THEN 35.00 + (@Sira % 18) * 4.25
                WHEN N'Rulo' THEN 55.00 + (@Sira % 15) * 5.50
                ELSE 45.00 + (@Sira % 22) * 7.25 END;
            SET @TeklifTutari = CONVERT(decimal(10,2), ROUND(@Miktar * @BirimFiyat, 2));
            SET @ParaBirimi = CASE WHEN @Sira % 20 = 0 THEN 'EUR'
                                   WHEN @Sira % 12 = 0 THEN 'USD' ELSE 'TRY' END;
            SET @TeklifDurumID = CASE
                WHEN @TeklifSayisi >= 1 AND @TalepID % 5 = 0
                     AND NOT EXISTS (SELECT 1 FROM dbo.Teklifler WHERE TalepID=@TalepID AND TeklifDurumID=1)
                    THEN 1
                WHEN EXISTS (SELECT 1 FROM dbo.Teklifler WHERE TalepID=@TalepID AND TeklifDurumID=1)
                    THEN 2
                WHEN @Sira % 7 = 0 THEN 2 ELSE 0 END;

            INSERT dbo.Teklifler
                (TeklifNo, TalepID, TedarikciID, TeklifGirenKullaniciID,
                 TeklifTutari, TeslimSuresiGun, SKT, TeklifTarihi,
                 GecerlilikTarihi, ParaBirimi, TeklifDurumID)
            VALUES
                (@TeklifNo, @TalepID, @TedarikciID, @TeklifGirenID,
                 @TeklifTutari, 2 + (@Sira % 14),
                 DATEADD(DAY, 120 + (@Sira % 240), CONVERT(date, GETDATE())),
                 DATEADD(DAY, 1 + (@Sira % 8), @TalepTarihi),
                 DATEADD(DAY, 1 + (@Sira % 30), CONVERT(date, GETDATE())),
                 @ParaBirimi, @TeklifDurumID);
            SET @TeklifID = CONVERT(int, SCOPE_IDENTITY());

            IF NOT EXISTS (SELECT 1 FROM dbo.TeklifKalemleri WHERE TeklifID = @TeklifID)
                INSERT dbo.TeklifKalemleri
                    (TeklifID, KalemAdi, KalemAciklamasi, Miktar, Birim,
                     BirimFiyat, ToplamTutar)
                VALUES
                    (@TeklifID, @UrunAdi, N'Büyük demo teklif kalemi', @Miktar,
                     @Birim, @BirimFiyat, @TeklifTutari);
        END;
        SET @Sira += 1;
    END;

    /* Seçilmiş tekliflerin bir bölümü için siparişler. */
    DECLARE @OnaylayanID int;
    SELECT TOP (1) @OnaylayanID = k.KullaniciID
    FROM dbo.Kullanicilar k
    INNER JOIN dbo.Roller r ON r.RolID = k.RolID
    WHERE k.Durum = 1 AND r.RolAdi = N'Satın Alma Yöneticisi'
    ORDER BY k.KullaniciID;
    IF @OnaylayanID IS NULL THROW 52010, N'Sipariş onaylayacak yönetici bulunamadı.', 1;

    SET @Sira = 1;
    DECLARE @SiparisNo nvarchar(20), @SiparisTeklifID int,
            @SiparisTalepID int;
    WHILE (SELECT COUNT(*) FROM dbo.SatinAlmaSiparisleri) < @HedefSiparis
    BEGIN
        SET @SiparisTeklifID = NULL;
        SELECT TOP (1) @SiparisTeklifID=t.TeklifID, @SiparisTalepID=t.TalepID
        FROM dbo.Teklifler t
        WHERE t.TeklifDurumID=1
          AND NOT EXISTS (SELECT 1 FROM dbo.SatinAlmaSiparisleri s WHERE s.TeklifID=t.TeklifID)
        ORDER BY t.TeklifID;
        IF @SiparisTeklifID IS NULL BREAK;

        WHILE EXISTS
            (SELECT 1 FROM dbo.SatinAlmaSiparisleri
             WHERE SiparisNo=N'SP'+RIGHT(N'0000'+CONVERT(nvarchar(10),@Sira),4))
            SET @Sira += 1;
        SET @SiparisNo=N'SP'+RIGHT(N'0000'+CONVERT(nvarchar(10),@Sira),4);

        IF NOT EXISTS (SELECT 1 FROM dbo.SatinAlmaSiparisleri WHERE SiparisNo=@SiparisNo)
            INSERT dbo.SatinAlmaSiparisleri
                (SiparisNo,TalepID,TeklifID,OnaylayanKullaniciID,SiparisTarihi,SiparisDurumID)
            VALUES
                (@SiparisNo,@SiparisTalepID,@SiparisTeklifID,@OnaylayanID,
                 DATEADD(DAY,-(@Sira%60),GETDATE()),@Sira%3);
        SET @Sira += 1;
    END;

    /* Gerçek satın alma senaryolarına dağıtılmış, tekrar üretilemeyen bildirimler. */
    DECLARE @BildirimKullaniciSayisi int =
    (
        SELECT COUNT(*) FROM dbo.Kullanicilar k
        INNER JOIN dbo.Roller r ON r.RolID=k.RolID
        WHERE k.Durum=1 AND r.RolAdi IN
            (N'Satın Alma Yöneticisi',N'Satın Alma Uzmanı',N'Talep Oluşturan Kullanıcı')
    );
    SET @Sira=1;
    DECLARE @BildirimKullaniciID int,@Baslik nvarchar(100),@Mesaj nvarchar(500),
            @OkunduMu bit,@OlusturmaTarihi datetime;
    WHILE (SELECT COUNT(*) FROM dbo.Bildirimler) < @HedefBildirim
    BEGIN
        ;WITH Alicilar AS
        (
            SELECT k.KullaniciID,ROW_NUMBER() OVER(ORDER BY k.KullaniciID) rn
            FROM dbo.Kullanicilar k
            INNER JOIN dbo.Roller r ON r.RolID=k.RolID
            WHERE k.Durum=1 AND r.RolAdi IN
                (N'Satın Alma Yöneticisi',N'Satın Alma Uzmanı',N'Talep Oluşturan Kullanıcı')
        )
        SELECT @BildirimKullaniciID=KullaniciID FROM Alicilar
        WHERE rn=((@Sira-1)%@BildirimKullaniciSayisi)+1;

        SET @Baslik=CASE @Sira%5
            WHEN 1 THEN N'Son teklif tarihine 3 gün kaldı'
            WHEN 2 THEN N'Teklif için bugün son gün'
            WHEN 3 THEN N'Uzun süredir teklif bekleyen talep'
            WHEN 4 THEN N'Onay bekleyen satın alma'
            ELSE N'Tamamlanmayan satın alma talebi' END;
        SET @Mesaj=NULL;
        IF @Sira%5 IN(1,2)
            SELECT TOP(1) @Mesaj=CONCAT(t.TeklifNo,
                CASE WHEN @Sira%5=1 THEN N' numaralı teklifin geçerlilik süresinin dolmasına 3 gün kaldı. Talep: '
                     ELSE N' numaralı teklifin son günü bugün. Talep: ' END,
                sat.TalepNo,N' - ',sat.UrunAdi,N'. Tedarikçi: ',f.FirmaAdi,
                N'. Tutar: ',FORMAT(t.TeklifTutari,N'N2',N'tr-TR'),N' ',RTRIM(t.ParaBirimi),
                N'. Geçerlilik Tarihi: ',CONVERT(nvarchar(10),t.GecerlilikTarihi,104),N'.')
            FROM dbo.Teklifler t
            INNER JOIN dbo.SatinAlmaTalepleri sat ON sat.TalepID=t.TalepID
            INNER JOIN dbo.Tedarikciler ted ON ted.TedarikciID=t.TedarikciID
            INNER JOIN dbo.Firmalar f ON f.FirmaID=ted.FirmaID
            ORDER BY ABS(CHECKSUM(CONCAT(@Sira,N'-',t.TeklifID)));
        ELSE IF @Sira%5=4
            SELECT TOP(1) @Mesaj=CONCAT(sat.TalepNo,N' numaralı talep için ',t.TeklifNo,
                N' numaralı teklif onay bekliyor. Ürün: ',sat.UrunAdi,N'. Tedarikçi: ',f.FirmaAdi,
                N'. Tutar: ',FORMAT(t.TeklifTutari,N'N2',N'tr-TR'),N' ',RTRIM(t.ParaBirimi),N'.')
            FROM dbo.Teklifler t
            INNER JOIN dbo.SatinAlmaTalepleri sat ON sat.TalepID=t.TalepID
            INNER JOIN dbo.Tedarikciler ted ON ted.TedarikciID=t.TedarikciID
            INNER JOIN dbo.Firmalar f ON f.FirmaID=ted.FirmaID
            ORDER BY ABS(CHECKSUM(CONCAT(@Sira,N'-',t.TeklifID)));
        ELSE
            SELECT TOP(1) @Mesaj=CONCAT(sat.TalepNo,
                CASE WHEN @Sira%5=3 THEN N' numaralı talep için uzun süredir teklif bekleniyor. Ürün: '
                     ELSE N' numaralı satın alma talebi henüz tamamlanmadı. Ürün: ' END,
                sat.UrunAdi,N'. Talep Eden: ',k.AdSoyad,N'. Talep Tarihi: ',
                CONVERT(nvarchar(10),sat.TalepTarihi,104),N'.')
            FROM dbo.SatinAlmaTalepleri sat
            INNER JOIN dbo.Kullanicilar k ON k.KullaniciID=sat.TalepEdenKullaniciID
            ORDER BY ABS(CHECKSUM(CONCAT(@Sira,N'-',sat.TalepID)));
        SET @OkunduMu=CASE WHEN @Sira%3=0 THEN 1 ELSE 0 END;
        SET @OlusturmaTarihi=DATEADD(HOUR,-(@Sira*3),GETDATE());

        IF @Mesaj IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Bildirimler WHERE Mesaj=@Mesaj)
            INSERT dbo.Bildirimler
                (KullaniciID,Baslik,Mesaj,OkunduMu,OlusturmaTarihi,OkunmaTarihi)
            VALUES
                (@BildirimKullaniciID,@Baslik,@Mesaj,@OkunduMu,@OlusturmaTarihi,
                 CASE WHEN @OkunduMu=1 THEN DATEADD(HOUR,1,@OlusturmaTarihi) ELSE NULL END);
        SET @Sira+=1;
    END;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;

/* Kontrol sorguları */
SELECT COUNT(*) AS KullaniciSayisi FROM dbo.Kullanicilar;
SELECT COUNT(*) AS TedarikciSayisi FROM dbo.Tedarikciler;
SELECT COUNT(*) AS TalepSayisi FROM dbo.SatinAlmaTalepleri;
SELECT COUNT(*) AS TeklifSayisi FROM dbo.Teklifler;
SELECT COUNT(*) AS SiparisSayisi FROM dbo.SatinAlmaSiparisleri;
SELECT COUNT(*) AS BildirimSayisi FROM dbo.Bildirimler;
