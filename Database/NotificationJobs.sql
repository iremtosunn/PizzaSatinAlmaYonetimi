/*
    Pizza Satın Alma Yönetimi - Bildirim Job Sorguları

    Kullanım:
    - Bu dosyanın BEGIN TRY ile END CATCH arasındaki gövdesi, SQL Server Agent
      içerisinde günlük veya ihtiyaca göre daha sık çalışan bir T-SQL job adımı
      olarak kullanılabilir.
    - Yeni tablo, kolon veya stored procedure oluşturmaz.
    - Aynı kullanıcı ve olay için aynı gün ikinci bildirim oluşturmaz.
    - Yalnızca aktif kullanıcılara bildirim üretir.
*/

USE [PizzaSatinAlmaDB];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @Bugun date = CONVERT(date, GETDATE());
DECLARE @UzunTalepGunSayisi int = 7;

BEGIN TRY
    BEGIN TRANSACTION;

    /*
       Senaryo 1: Geçerlilik tarihine tam 3 gün kalan, hâlâ incelenen teklifler.
       Satın Alma Yöneticileri ile teklifi sisteme giren ilgili kullanıcı uyarılır.
    */
    ;WITH Olaylar AS
    (
        SELECT T.TeklifID, T.TeklifNo, SAT.TalepNo, T.TeklifGirenKullaniciID
        FROM dbo.Teklifler T
        INNER JOIN dbo.SatinAlmaTalepleri SAT ON SAT.TalepID = T.TalepID
        WHERE T.TeklifDurumID = 0
          AND T.GecerlilikTarihi = DATEADD(DAY, 3, @Bugun)
    ),
    Alicilar AS
    (
        SELECT O.TeklifID, O.TeklifNo, O.TalepNo, K.KullaniciID
        FROM Olaylar O
        INNER JOIN dbo.Kullanicilar K ON K.KullaniciID = O.TeklifGirenKullaniciID AND K.Durum = 1
        UNION
        SELECT O.TeklifID, O.TeklifNo, O.TalepNo, K.KullaniciID
        FROM Olaylar O
        CROSS JOIN dbo.Kullanicilar K
        INNER JOIN dbo.Roller R ON R.RolID = K.RolID
        WHERE K.Durum = 1 AND R.RolAdi = N'Satın Alma Yöneticisi'
    )
    INSERT dbo.Bildirimler (KullaniciID, Baslik, Mesaj, OkunduMu, OlusturmaTarihi, OkunmaTarihi)
    SELECT A.KullaniciID, N'Teklif geçerlilik tarihi yaklaşıyor',
           CONCAT(A.TeklifNo, N' numaralı teklifin geçerlilik süresinin dolmasına 3 gün kaldı. Talep: ', A.TalepNo, N'.'),
           0, GETDATE(), NULL
    FROM Alicilar A
    WHERE NOT EXISTS
    (
        SELECT 1 FROM dbo.Bildirimler B WITH (UPDLOCK, HOLDLOCK)
        WHERE B.KullaniciID = A.KullaniciID
          AND B.Baslik = N'Teklif geçerlilik tarihi yaklaşıyor'
          AND B.Mesaj = CONCAT(A.TeklifNo, N' numaralı teklifin geçerlilik süresinin dolmasına 3 gün kaldı. Talep: ', A.TalepNo, N'.')
          AND B.OlusturmaTarihi >= @Bugun AND B.OlusturmaTarihi < DATEADD(DAY, 1, @Bugun)
    );

    /*
       Senaryo 2: Geçerlilik süresi bugün dolacak, hâlâ incelenen teklifler.
       Satın Alma Yöneticileri ile teklifi sisteme giren ilgili kullanıcı uyarılır.
    */
    ;WITH Olaylar AS
    (
        SELECT T.TeklifID, T.TeklifNo, SAT.TalepNo, T.TeklifGirenKullaniciID
        FROM dbo.Teklifler T
        INNER JOIN dbo.SatinAlmaTalepleri SAT ON SAT.TalepID = T.TalepID
        WHERE T.TeklifDurumID = 0 AND T.GecerlilikTarihi = @Bugun
    ),
    Alicilar AS
    (
        SELECT O.TeklifID, O.TeklifNo, O.TalepNo, K.KullaniciID
        FROM Olaylar O
        INNER JOIN dbo.Kullanicilar K ON K.KullaniciID = O.TeklifGirenKullaniciID AND K.Durum = 1
        UNION
        SELECT O.TeklifID, O.TeklifNo, O.TalepNo, K.KullaniciID
        FROM Olaylar O
        CROSS JOIN dbo.Kullanicilar K
        INNER JOIN dbo.Roller R ON R.RolID = K.RolID
        WHERE K.Durum = 1 AND R.RolAdi = N'Satın Alma Yöneticisi'
    )
    INSERT dbo.Bildirimler (KullaniciID, Baslik, Mesaj, OkunduMu, OlusturmaTarihi, OkunmaTarihi)
    SELECT A.KullaniciID, N'Teklifin son geçerlilik günü',
           CONCAT(A.TeklifNo, N' numaralı teklifin geçerlilik süresi bugün doluyor. Talep: ', A.TalepNo, N'.'),
           0, GETDATE(), NULL
    FROM Alicilar A
    WHERE NOT EXISTS
    (
        SELECT 1 FROM dbo.Bildirimler B WITH (UPDLOCK, HOLDLOCK)
        WHERE B.KullaniciID = A.KullaniciID
          AND B.Baslik = N'Teklifin son geçerlilik günü'
          AND B.Mesaj = CONCAT(A.TeklifNo, N' numaralı teklifin geçerlilik süresi bugün doluyor. Talep: ', A.TalepNo, N'.')
          AND B.OlusturmaTarihi >= @Bugun AND B.OlusturmaTarihi < DATEADD(DAY, 1, @Bugun)
    );

    /*
       Senaryo 3: Seçilmiş fakat henüz siparişi oluşturulmamış teklifler.
       Satın Alma Yöneticileri ve talebi oluşturan ilgili kullanıcı bilgilendirilir.
    */
    ;WITH Olaylar AS
    (
        SELECT T.TeklifID, T.TeklifNo, SAT.TalepNo, SAT.TalepEdenKullaniciID
        FROM dbo.Teklifler T
        INNER JOIN dbo.SatinAlmaTalepleri SAT ON SAT.TalepID = T.TalepID
        LEFT JOIN dbo.SatinAlmaSiparisleri S ON S.TeklifID = T.TeklifID
        WHERE T.TeklifDurumID = 1 AND S.SiparisID IS NULL
    ),
    Alicilar AS
    (
        SELECT O.TeklifID, O.TeklifNo, O.TalepNo, K.KullaniciID
        FROM Olaylar O
        INNER JOIN dbo.Kullanicilar K ON K.KullaniciID = O.TalepEdenKullaniciID AND K.Durum = 1
        UNION
        SELECT O.TeklifID, O.TeklifNo, O.TalepNo, K.KullaniciID
        FROM Olaylar O
        CROSS JOIN dbo.Kullanicilar K
        INNER JOIN dbo.Roller R ON R.RolID = K.RolID
        WHERE K.Durum = 1 AND R.RolAdi = N'Satın Alma Yöneticisi'
    )
    INSERT dbo.Bildirimler (KullaniciID, Baslik, Mesaj, OkunduMu, OlusturmaTarihi, OkunmaTarihi)
    SELECT A.KullaniciID, N'Onay bekleyen satın alma',
           CONCAT(A.TeklifNo, N' numaralı seçilmiş teklif için sipariş oluşturulması bekleniyor. Talep: ', A.TalepNo, N'.'),
           0, GETDATE(), NULL
    FROM Alicilar A
    WHERE NOT EXISTS
    (
        SELECT 1 FROM dbo.Bildirimler B WITH (UPDLOCK, HOLDLOCK)
        WHERE B.KullaniciID = A.KullaniciID
          AND B.Baslik = N'Onay bekleyen satın alma'
          AND B.Mesaj = CONCAT(A.TeklifNo, N' numaralı seçilmiş teklif için sipariş oluşturulması bekleniyor. Talep: ', A.TalepNo, N'.')
          AND B.OlusturmaTarihi >= @Bugun AND B.OlusturmaTarihi < DATEADD(DAY, 1, @Bugun)
    );

    /*
       Senaryo 4: En az @UzunTalepGunSayisi gündür tamamlanmayan talepler.
       Durum 0 (İnceleniyor) ve 1 (Teklifler Alındı) süreçleri tamamlanmamış sayılır.
       Satın Alma Yöneticileri ile talebi oluşturan ilgili kullanıcı uyarılır.
    */
    ;WITH Olaylar AS
    (
        SELECT SAT.TalepID, SAT.TalepNo, SAT.TalepEdenKullaniciID,
               DATEDIFF(DAY, CONVERT(date, SAT.TalepTarihi), @Bugun) AS BeklemeGunSayisi
        FROM dbo.SatinAlmaTalepleri SAT
        WHERE SAT.TalepDurumID IN (0, 1)
          AND SAT.TalepTarihi < DATEADD(DAY, -@UzunTalepGunSayisi, @Bugun)
    ),
    Alicilar AS
    (
        SELECT O.TalepID, O.TalepNo, O.BeklemeGunSayisi, K.KullaniciID
        FROM Olaylar O
        INNER JOIN dbo.Kullanicilar K ON K.KullaniciID = O.TalepEdenKullaniciID AND K.Durum = 1
        UNION
        SELECT O.TalepID, O.TalepNo, O.BeklemeGunSayisi, K.KullaniciID
        FROM Olaylar O
        CROSS JOIN dbo.Kullanicilar K
        INNER JOIN dbo.Roller R ON R.RolID = K.RolID
        WHERE K.Durum = 1 AND R.RolAdi = N'Satın Alma Yöneticisi'
    )
    INSERT dbo.Bildirimler (KullaniciID, Baslik, Mesaj, OkunduMu, OlusturmaTarihi, OkunmaTarihi)
    SELECT A.KullaniciID, N'Tamamlanmayan satın alma talebi',
           CONCAT(A.TalepNo, N' numaralı talep ', A.BeklemeGunSayisi, N' gündür tamamlanmadı.'),
           0, GETDATE(), NULL
    FROM Alicilar A
    WHERE NOT EXISTS
    (
        SELECT 1 FROM dbo.Bildirimler B WITH (UPDLOCK, HOLDLOCK)
        WHERE B.KullaniciID = A.KullaniciID
          AND B.Baslik = N'Tamamlanmayan satın alma talebi'
          AND B.Mesaj = CONCAT(A.TalepNo, N' numaralı talep ', A.BeklemeGunSayisi, N' gündür tamamlanmadı.')
          AND B.OlusturmaTarihi >= @Bugun AND B.OlusturmaTarihi < DATEADD(DAY, 1, @Bugun)
    );

    /*
       Senaryo 5: Teklif alınmış fakat hiçbir teklifi seçilmemiş talepler.
       Satın Alma Yöneticileri ve talebi oluşturan ilgili kullanıcı uyarılır.
    */
    ;WITH Olaylar AS
    (
        SELECT SAT.TalepID, SAT.TalepNo, SAT.TalepEdenKullaniciID
        FROM dbo.SatinAlmaTalepleri SAT
        WHERE SAT.TalepDurumID = 1
          AND EXISTS (SELECT 1 FROM dbo.Teklifler T WHERE T.TalepID = SAT.TalepID AND T.TeklifDurumID = 0)
          AND NOT EXISTS (SELECT 1 FROM dbo.Teklifler T WHERE T.TalepID = SAT.TalepID AND T.TeklifDurumID = 1)
    ),
    Alicilar AS
    (
        SELECT O.TalepID, O.TalepNo, K.KullaniciID
        FROM Olaylar O
        INNER JOIN dbo.Kullanicilar K ON K.KullaniciID = O.TalepEdenKullaniciID AND K.Durum = 1
        UNION
        SELECT O.TalepID, O.TalepNo, K.KullaniciID
        FROM Olaylar O
        CROSS JOIN dbo.Kullanicilar K
        INNER JOIN dbo.Roller R ON R.RolID = K.RolID
        WHERE K.Durum = 1 AND R.RolAdi = N'Satın Alma Yöneticisi'
    )
    INSERT dbo.Bildirimler (KullaniciID, Baslik, Mesaj, OkunduMu, OlusturmaTarihi, OkunmaTarihi)
    SELECT A.KullaniciID, N'Teklif seçimi bekleniyor',
           CONCAT(A.TalepNo, N' numaralı talebe teklifler girildi ancak henüz bir teklif seçilmedi.'),
           0, GETDATE(), NULL
    FROM Alicilar A
    WHERE NOT EXISTS
    (
        SELECT 1 FROM dbo.Bildirimler B WITH (UPDLOCK, HOLDLOCK)
        WHERE B.KullaniciID = A.KullaniciID
          AND B.Baslik = N'Teklif seçimi bekleniyor'
          AND B.Mesaj = CONCAT(A.TalepNo, N' numaralı talebe teklifler girildi ancak henüz bir teklif seçilmedi.')
          AND B.OlusturmaTarihi >= @Bugun AND B.OlusturmaTarihi < DATEADD(DAY, 1, @Bugun)
    );

    /*
       Senaryo 6: Oluşturulmuş (durum 0) fakat tamamlanmamış siparişler.
       Onaylayan kullanıcı, talep sahibi ve Satın Alma Yöneticileri uyarılır.
       İptal edilmiş siparişler (durum 2) bu senaryoya dahil edilmez.
    */
    ;WITH Olaylar AS
    (
        SELECT S.SiparisID, S.SiparisNo, SAT.TalepNo,
               S.OnaylayanKullaniciID, SAT.TalepEdenKullaniciID
        FROM dbo.SatinAlmaSiparisleri S
        INNER JOIN dbo.SatinAlmaTalepleri SAT ON SAT.TalepID = S.TalepID
        WHERE S.SiparisDurumID = 0
    ),
    Alicilar AS
    (
        SELECT O.SiparisID, O.SiparisNo, O.TalepNo, K.KullaniciID
        FROM Olaylar O
        INNER JOIN dbo.Kullanicilar K
            ON K.KullaniciID IN (O.OnaylayanKullaniciID, O.TalepEdenKullaniciID) AND K.Durum = 1
        UNION
        SELECT O.SiparisID, O.SiparisNo, O.TalepNo, K.KullaniciID
        FROM Olaylar O
        CROSS JOIN dbo.Kullanicilar K
        INNER JOIN dbo.Roller R ON R.RolID = K.RolID
        WHERE K.Durum = 1 AND R.RolAdi = N'Satın Alma Yöneticisi'
    )
    INSERT dbo.Bildirimler (KullaniciID, Baslik, Mesaj, OkunduMu, OlusturmaTarihi, OkunmaTarihi)
    SELECT A.KullaniciID, N'Tamamlanmayan satın alma siparişi',
           CONCAT(A.SiparisNo, N' numaralı sipariş oluşturuldu ancak henüz tamamlanmadı. Talep: ', A.TalepNo, N'.'),
           0, GETDATE(), NULL
    FROM Alicilar A
    WHERE NOT EXISTS
    (
        SELECT 1 FROM dbo.Bildirimler B WITH (UPDLOCK, HOLDLOCK)
        WHERE B.KullaniciID = A.KullaniciID
          AND B.Baslik = N'Tamamlanmayan satın alma siparişi'
          AND B.Mesaj = CONCAT(A.SiparisNo, N' numaralı sipariş oluşturuldu ancak henüz tamamlanmadı. Talep: ', A.TalepNo, N'.')
          AND B.OlusturmaTarihi >= @Bugun AND B.OlusturmaTarihi < DATEADD(DAY, 1, @Bugun)
    );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
