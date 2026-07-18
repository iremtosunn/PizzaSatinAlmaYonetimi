/* Pizza Satın Alma Yönetimi - Bildirim üretim prosedürleri ve günlük job örneği */
USE [PizzaSatinAlmaDB];
GO

CREATE OR ALTER PROCEDURE dbo.sp_KullaniciBildirimleri
    @KullaniciID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT BildirimID,Baslik,Mesaj,
           CASE OkunduMu WHEN 0 THEN N'Okunmadı' ELSE N'Okundu' END AS OkunmaDurumu,
           OlusturmaTarihi,OkunmaTarihi
    FROM dbo.Bildirimler
    WHERE KullaniciID=@KullaniciID
    ORDER BY OlusturmaTarihi DESC,BildirimID DESC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_BildirimYaklasanTeklifler
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Bugun date=CONVERT(date,GETDATE());
    ;WITH Olay AS
    (
        SELECT t.TeklifID,t.TeklifNo,t.TeklifGirenKullaniciID,t.GecerlilikTarihi,
               sat.TalepNo,sat.UrunAdi,f.FirmaAdi
        FROM dbo.Teklifler t
        INNER JOIN dbo.SatinAlmaTalepleri sat ON sat.TalepID=t.TalepID
        INNER JOIN dbo.Tedarikciler ted ON ted.TedarikciID=t.TedarikciID
        INNER JOIN dbo.Firmalar f ON f.FirmaID=ted.FirmaID
        WHERE t.TeklifDurumID=0 AND t.GecerlilikTarihi=DATEADD(DAY,3,@Bugun)
    ), Alici AS
    (
        SELECT o.*,k.KullaniciID FROM Olay o
        INNER JOIN dbo.Kullanicilar k ON k.KullaniciID=o.TeklifGirenKullaniciID AND k.Durum=1
        UNION
        SELECT o.*,k.KullaniciID FROM Olay o CROSS JOIN dbo.Kullanicilar k
        INNER JOIN dbo.Roller r ON r.RolID=k.RolID
        WHERE k.Durum=1 AND r.RolAdi=N'Satın Alma Yöneticisi'
    )
    INSERT dbo.Bildirimler(KullaniciID,Baslik,Mesaj,OkunduMu,OlusturmaTarihi,OkunmaTarihi)
    SELECT a.KullaniciID,N'Yaklaşan Teklif Geçerlilik Tarihi',
           CONCAT(a.TeklifNo,N' numaralı teklifin geçerlilik süresinin dolmasına 3 gün kaldı. Talep: ',a.TalepNo,N' - ',a.UrunAdi,N'. Tedarikçi: ',a.FirmaAdi,N'.'),
           0,GETDATE(),NULL
    FROM Alici a
    WHERE NOT EXISTS
    (
        SELECT 1 FROM dbo.Bildirimler b WITH(UPDLOCK,HOLDLOCK)
        WHERE b.KullaniciID=a.KullaniciID AND b.Baslik=N'Yaklaşan Teklif Geçerlilik Tarihi'
          AND b.Mesaj LIKE a.TeklifNo+N' numaralı teklif%'
          AND b.OlusturmaTarihi>=@Bugun AND b.OlusturmaTarihi<DATEADD(DAY,1,@Bugun)
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_BildirimBugunSonGunuOlanTeklifler
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Bugun date=CONVERT(date,GETDATE());
    ;WITH Olay AS
    (
        SELECT t.TeklifID,t.TeklifNo,t.TeklifGirenKullaniciID,t.GecerlilikTarihi,
               sat.TalepNo,sat.UrunAdi,f.FirmaAdi
        FROM dbo.Teklifler t
        INNER JOIN dbo.SatinAlmaTalepleri sat ON sat.TalepID=t.TalepID
        INNER JOIN dbo.Tedarikciler ted ON ted.TedarikciID=t.TedarikciID
        INNER JOIN dbo.Firmalar f ON f.FirmaID=ted.FirmaID
        WHERE t.TeklifDurumID=0 AND t.GecerlilikTarihi=@Bugun
    ), Alici AS
    (
        SELECT o.*,k.KullaniciID FROM Olay o
        INNER JOIN dbo.Kullanicilar k ON k.KullaniciID=o.TeklifGirenKullaniciID AND k.Durum=1
        UNION
        SELECT o.*,k.KullaniciID FROM Olay o CROSS JOIN dbo.Kullanicilar k
        INNER JOIN dbo.Roller r ON r.RolID=k.RolID
        WHERE k.Durum=1 AND r.RolAdi=N'Satın Alma Yöneticisi'
    )
    INSERT dbo.Bildirimler(KullaniciID,Baslik,Mesaj,OkunduMu,OlusturmaTarihi,OkunmaTarihi)
    SELECT a.KullaniciID,N'Teklif İçin Bugün Son Gün',
           CONCAT(a.TeklifNo,N' numaralı teklifin son günü bugün. Talep: ',a.TalepNo,N' - ',a.UrunAdi,N'. Tedarikçi: ',a.FirmaAdi,N'. Geçerlilik Tarihi: ',CONVERT(nvarchar(10),a.GecerlilikTarihi,104),N'.'),
           0,GETDATE(),NULL
    FROM Alici a
    WHERE NOT EXISTS
    (
        SELECT 1 FROM dbo.Bildirimler b WITH(UPDLOCK,HOLDLOCK)
        WHERE b.KullaniciID=a.KullaniciID AND b.Baslik=N'Teklif İçin Bugün Son Gün'
          AND b.Mesaj LIKE a.TeklifNo+N' numaralı teklif%'
          AND b.OlusturmaTarihi>=@Bugun AND b.OlusturmaTarihi<DATEADD(DAY,1,@Bugun)
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_BildirimTeklifBekleyenTalepler
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Bugun date=CONVERT(date,GETDATE());
    ;WITH Olay AS
    (
        SELECT sat.TalepID,sat.TalepNo,sat.UrunAdi,sat.TalepEdenKullaniciID,k.AdSoyad
        FROM dbo.SatinAlmaTalepleri sat
        INNER JOIN dbo.Kullanicilar k ON k.KullaniciID=sat.TalepEdenKullaniciID
        WHERE sat.TalepDurumID=0 AND sat.TalepTarihi<DATEADD(DAY,-7,@Bugun)
          AND NOT EXISTS(SELECT 1 FROM dbo.Teklifler t WHERE t.TalepID=sat.TalepID)
    ), Alici AS
    (
        SELECT o.*,k.KullaniciID FROM Olay o
        INNER JOIN dbo.Kullanicilar k ON k.KullaniciID=o.TalepEdenKullaniciID AND k.Durum=1
        UNION
        SELECT o.*,k.KullaniciID FROM Olay o CROSS JOIN dbo.Kullanicilar k
        INNER JOIN dbo.Roller r ON r.RolID=k.RolID
        WHERE k.Durum=1 AND r.RolAdi IN(N'Satın Alma Yöneticisi',N'Satın Alma Uzmanı')
    )
    INSERT dbo.Bildirimler(KullaniciID,Baslik,Mesaj,OkunduMu,OlusturmaTarihi,OkunmaTarihi)
    SELECT a.KullaniciID,N'Teklif Bekleyen Talep',
           CONCAT(a.TalepNo,N' numaralı talep için uzun süredir teklif bekleniyor. Ürün: ',a.UrunAdi,N'. Talep Eden: ',a.AdSoyad,N'.'),
           0,GETDATE(),NULL
    FROM Alici a
    WHERE NOT EXISTS
    (
        SELECT 1 FROM dbo.Bildirimler b WITH(UPDLOCK,HOLDLOCK)
        WHERE b.KullaniciID=a.KullaniciID AND b.Baslik=N'Teklif Bekleyen Talep'
          AND b.Mesaj LIKE a.TalepNo+N' numaralı talep%'
          AND b.OlusturmaTarihi>=@Bugun AND b.OlusturmaTarihi<DATEADD(DAY,1,@Bugun)
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_BildirimOnayBekleyenSatinAlmalar
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Bugun date=CONVERT(date,GETDATE());
    ;WITH Olay AS
    (
        SELECT t.TeklifID,t.TeklifNo,t.TeklifTutari,t.ParaBirimi,
               sat.TalepNo,sat.UrunAdi,f.FirmaAdi
        FROM dbo.Teklifler t
        INNER JOIN dbo.SatinAlmaTalepleri sat ON sat.TalepID=t.TalepID
        INNER JOIN dbo.Tedarikciler ted ON ted.TedarikciID=t.TedarikciID
        INNER JOIN dbo.Firmalar f ON f.FirmaID=ted.FirmaID
        WHERE t.TeklifDurumID=1
          AND NOT EXISTS(SELECT 1 FROM dbo.SatinAlmaSiparisleri s WHERE s.TeklifID=t.TeklifID)
    ), Alici AS
    (
        SELECT o.*,k.KullaniciID FROM Olay o CROSS JOIN dbo.Kullanicilar k
        INNER JOIN dbo.Roller r ON r.RolID=k.RolID
        WHERE k.Durum=1 AND r.RolAdi=N'Satın Alma Yöneticisi'
    )
    INSERT dbo.Bildirimler(KullaniciID,Baslik,Mesaj,OkunduMu,OlusturmaTarihi,OkunmaTarihi)
    SELECT a.KullaniciID,N'Onay Bekleyen Satın Alma',
           CONCAT(a.TalepNo,N' numaralı talep için ',a.TeklifNo,N' numaralı teklif onay bekliyor. Ürün: ',a.UrunAdi,N'. Tedarikçi: ',a.FirmaAdi,N'. Tutar: ',FORMAT(a.TeklifTutari,N'N2',N'tr-TR'),N' ',RTRIM(a.ParaBirimi),N'.'),
           0,GETDATE(),NULL
    FROM Alici a
    WHERE NOT EXISTS
    (
        SELECT 1 FROM dbo.Bildirimler b WITH(UPDLOCK,HOLDLOCK)
        WHERE b.KullaniciID=a.KullaniciID AND b.Baslik=N'Onay Bekleyen Satın Alma'
          AND b.Mesaj LIKE a.TalepNo+N' numaralı talep için '+a.TeklifNo+N' numaralı teklif%'
          AND b.OlusturmaTarihi>=@Bugun AND b.OlusturmaTarihi<DATEADD(DAY,1,@Bugun)
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_BildirimTamamlanmayanTalepler
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Bugun date=CONVERT(date,GETDATE());
    ;WITH Olay AS
    (
        SELECT sat.TalepID,sat.TalepNo,sat.UrunAdi,sat.TalepEdenKullaniciID,k.AdSoyad
        FROM dbo.SatinAlmaTalepleri sat
        INNER JOIN dbo.Kullanicilar k ON k.KullaniciID=sat.TalepEdenKullaniciID
        WHERE sat.TalepDurumID IN(0,1) AND sat.TalepTarihi<DATEADD(DAY,-14,@Bugun)
    ), Alici AS
    (
        SELECT o.*,k.KullaniciID FROM Olay o
        INNER JOIN dbo.Kullanicilar k ON k.KullaniciID=o.TalepEdenKullaniciID AND k.Durum=1
        UNION
        SELECT o.*,k.KullaniciID FROM Olay o CROSS JOIN dbo.Kullanicilar k
        INNER JOIN dbo.Roller r ON r.RolID=k.RolID
        WHERE k.Durum=1 AND r.RolAdi IN(N'Satın Alma Yöneticisi',N'Satın Alma Uzmanı')
    )
    INSERT dbo.Bildirimler(KullaniciID,Baslik,Mesaj,OkunduMu,OlusturmaTarihi,OkunmaTarihi)
    SELECT a.KullaniciID,N'Tamamlanmayan Satın Alma Talebi',
           CONCAT(a.TalepNo,N' numaralı satın alma talebi henüz tamamlanmadı. Ürün: ',a.UrunAdi,N'. Talep Eden: ',a.AdSoyad,N'.'),
           0,GETDATE(),NULL
    FROM Alici a
    WHERE NOT EXISTS
    (
        SELECT 1 FROM dbo.Bildirimler b WITH(UPDLOCK,HOLDLOCK)
        WHERE b.KullaniciID=a.KullaniciID AND b.Baslik=N'Tamamlanmayan Satın Alma Talebi'
          AND b.Mesaj LIKE a.TalepNo+N' numaralı satın alma talebi%'
          AND b.OlusturmaTarihi>=@Bugun AND b.OlusturmaTarihi<DATEADD(DAY,1,@Bugun)
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_BildirimSiparisDurumlari
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Bugun date=CONVERT(date,GETDATE());
    ;WITH Olay AS
    (
        SELECT s.SiparisID,s.SiparisNo,s.SiparisDurumID,s.OnaylayanKullaniciID,
               t.TeklifNo,t.TeklifTutari,t.ParaBirimi,sat.TalepNo,sat.UrunAdi,
               sat.TalepEdenKullaniciID,k.AdSoyad AS TalepEden,f.FirmaAdi
        FROM dbo.SatinAlmaSiparisleri s
        INNER JOIN dbo.Teklifler t ON t.TeklifID=s.TeklifID
        INNER JOIN dbo.SatinAlmaTalepleri sat ON sat.TalepID=s.TalepID
        INNER JOIN dbo.Kullanicilar k ON k.KullaniciID=sat.TalepEdenKullaniciID
        INNER JOIN dbo.Tedarikciler ted ON ted.TedarikciID=t.TedarikciID
        INNER JOIN dbo.Firmalar f ON f.FirmaID=ted.FirmaID
    ), Alici AS
    (
        SELECT o.*,k.KullaniciID FROM Olay o
        INNER JOIN dbo.Kullanicilar k ON k.KullaniciID IN(o.OnaylayanKullaniciID,o.TalepEdenKullaniciID) AND k.Durum=1
        UNION
        SELECT o.*,k.KullaniciID FROM Olay o CROSS JOIN dbo.Kullanicilar k
        INNER JOIN dbo.Roller r ON r.RolID=k.RolID
        WHERE k.Durum=1 AND r.RolAdi=N'Satın Alma Yöneticisi'
    )
    INSERT dbo.Bildirimler(KullaniciID,Baslik,Mesaj,OkunduMu,OlusturmaTarihi,OkunmaTarihi)
    SELECT a.KullaniciID,
           CASE a.SiparisDurumID WHEN 0 THEN N'Sipariş Oluşturuldu' WHEN 1 THEN N'Sipariş Tamamlandı' ELSE N'Sipariş İptal Edildi' END,
           CONCAT(a.SiparisNo,N' numaralı satın alma siparişi ',CASE a.SiparisDurumID WHEN 0 THEN N'oluşturuldu' WHEN 1 THEN N'tamamlandı' ELSE N'iptal edildi' END,N'. Talep: ',a.TalepNo,N' - ',a.UrunAdi,N'. Teklif: ',a.TeklifNo,N'. Tedarikçi: ',a.FirmaAdi,N'. Tutar: ',FORMAT(a.TeklifTutari,N'N2',N'tr-TR'),N' ',RTRIM(a.ParaBirimi),N'. Talep Eden: ',a.TalepEden,N'.'),
           0,GETDATE(),NULL
    FROM Alici a
    WHERE NOT EXISTS
    (
        SELECT 1 FROM dbo.Bildirimler b WITH(UPDLOCK,HOLDLOCK)
        WHERE b.KullaniciID=a.KullaniciID
          AND b.Baslik=CASE a.SiparisDurumID WHEN 0 THEN N'Sipariş Oluşturuldu' WHEN 1 THEN N'Sipariş Tamamlandı' ELSE N'Sipariş İptal Edildi' END
          AND b.Mesaj LIKE a.SiparisNo+N' numaralı satın alma siparişi%'
          AND b.OlusturmaTarihi>=@Bugun AND b.OlusturmaTarihi<DATEADD(DAY,1,@Bugun)
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_BildirimGunlukKontrol
AS
BEGIN
    SET NOCOUNT ON;
    EXEC dbo.sp_BildirimYaklasanTeklifler;
    EXEC dbo.sp_BildirimBugunSonGunuOlanTeklifler;
    EXEC dbo.sp_BildirimTeklifBekleyenTalepler;
    EXEC dbo.sp_BildirimOnayBekleyenSatinAlmalar;
    EXEC dbo.sp_BildirimTamamlanmayanTalepler;
    EXEC dbo.sp_BildirimSiparisDurumlari;
END;
GO

/* SQL Server Agent: her gün 09:00. Aynı isimli job/schedule varsa yeniden oluşturmaz. */
BEGIN TRY
    IF DB_ID(N'msdb') IS NOT NULL
    BEGIN
        DECLARE @JobId uniqueidentifier;
        SELECT @JobId=job_id FROM msdb.dbo.sysjobs WHERE name=N'Pizza Satın Alma Günlük Bildirim Kontrolü';
        IF @JobId IS NULL
        BEGIN
            EXEC msdb.dbo.sp_add_job @job_name=N'Pizza Satın Alma Günlük Bildirim Kontrolü',@enabled=1,@job_id=@JobId OUTPUT;
            EXEC msdb.dbo.sp_add_jobstep @job_id=@JobId,@step_name=N'Bildirimleri üret',@subsystem=N'TSQL',
                 @database_name=N'PizzaSatinAlmaDB',@command=N'EXEC dbo.sp_BildirimGunlukKontrol;',@on_success_action=1,@on_fail_action=2;
            IF NOT EXISTS(SELECT 1 FROM msdb.dbo.sysschedules WHERE name=N'Pizza Satın Alma Her Gün 09:00')
                EXEC msdb.dbo.sp_add_schedule @schedule_name=N'Pizza Satın Alma Her Gün 09:00',@freq_type=4,@freq_interval=1,@active_start_time=090000;
            EXEC msdb.dbo.sp_attach_schedule @job_id=@JobId,@schedule_name=N'Pizza Satın Alma Her Gün 09:00';
            EXEC msdb.dbo.sp_add_jobserver @job_id=@JobId;
        END;
    END;
END TRY
BEGIN CATCH
    PRINT N'SQL Server Agent job oluşturulamadı. Prosedürü el ile veya harici zamanlayıcıyla çalıştırın: '+ERROR_MESSAGE();
END CATCH;
GO

/* SQL Server Agent bulunmayan ortamlarda manuel çalıştırma: */
EXEC dbo.sp_BildirimGunlukKontrol;
GO
