/*
  Yalnızca yerel/demo veritabanı içindir.
  Mevcut siparişleri silmez; belirli siparişlere idempotent teslimat geçmişi ekler.
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

DECLARE @DemoBugun date='2026-07-24';
DECLARE @UzmanKullaniciID int=
(
    SELECT TOP(1) KullaniciID
    FROM dbo.Kullanicilar
    WHERE RolID=2
    ORDER BY KullaniciID
);

IF @UzmanKullaniciID IS NULL
    THROW 50001,N'Demo teslimatlarını kaydedecek Satın Alma Uzmanı bulunamadı.',1;

/* Boş uzman görüşlerini raporları dolduracak dengeli demo değerleriyle tamamla. */
UPDATE dbo.SatinAlmaTalepleri
SET ErtelenebilirMi=CASE WHEN TalepID%4=0 THEN 1 ELSE 0 END
WHERE ErtelenebilirMi IS NULL;

/* İptal olmayan siparişleri sabit bir sıraya koy. */
IF OBJECT_ID('tempdb..#DemoSiparisler') IS NOT NULL DROP TABLE #DemoSiparisler;
SELECT ROW_NUMBER() OVER(ORDER BY S.SiparisID) Sira,
       S.SiparisID,S.SiparisTarihi,T.TeslimSuresiGun,SAT.Miktar
INTO #DemoSiparisler
FROM dbo.SatinAlmaSiparisleri S
JOIN dbo.Teklifler T ON T.TeklifID=S.TeklifID
JOIN dbo.SatinAlmaTalepleri SAT ON SAT.TalepID=S.TalepID
WHERE S.SiparisDurumID<>2;

/* İlk 26 siparişte: zamanında/geç, tam/eksik ve farklı kusur oranları. */
INSERT dbo.TeslimatKayitlari
    (SiparisID,GercekTeslimTarihi,TeslimEdilenMiktar,KusurluMiktar,KaydedenKullaniciID,KayitTarihi)
SELECT D.SiparisID,
       DATEADD(DAY,D.TeslimSuresiGun+
           CASE WHEN D.Sira%5=0 THEN 3 WHEN D.Sira%3=0 THEN 1 ELSE -1 END,
           CAST(D.SiparisTarihi AS date)),
       CAST(ROUND(D.Miktar*CASE WHEN D.Sira%7=0 THEN .95 ELSE 1 END,2) AS decimal(18,2)),
       CAST(ROUND(D.Miktar*CASE WHEN D.Sira%6=0 THEN .03 WHEN D.Sira%4=0 THEN .01 ELSE 0 END,2) AS decimal(18,2)),
       @UzmanKullaniciID,
       DATEADD(HOUR,10,CAST(@DemoBugun AS datetime2))
FROM #DemoSiparisler D
WHERE D.Sira<=26
  AND NOT EXISTS(SELECT 1 FROM dbo.TeslimatKayitlari TK WHERE TK.SiparisID=D.SiparisID);

UPDATE S SET SiparisDurumID=1
FROM dbo.SatinAlmaSiparisleri S
JOIN #DemoSiparisler D ON D.SiparisID=S.SiparisID
WHERE D.Sira<=26 AND EXISTS(SELECT 1 FROM dbo.TeslimatKayitlari TK WHERE TK.SiparisID=S.SiparisID);

/* Sonraki altı sipariş gecikmiş, kalan açık siparişler henüz süresi dolmamış olsun. */
UPDATE S
SET SiparisTarihi=DATEADD(DAY,-(D.TeslimSuresiGun+4),CAST(@DemoBugun AS datetime))
FROM dbo.SatinAlmaSiparisleri S
JOIN #DemoSiparisler D ON D.SiparisID=S.SiparisID
WHERE D.Sira BETWEEN 27 AND 28
  AND NOT EXISTS(SELECT 1 FROM dbo.TeslimatKayitlari TK WHERE TK.SiparisID=S.SiparisID);

UPDATE S
SET SiparisTarihi=DATEADD(DAY,-1,CAST(@DemoBugun AS datetime))
FROM dbo.SatinAlmaSiparisleri S
JOIN #DemoSiparisler D ON D.SiparisID=S.SiparisID
WHERE D.Sira>28
  AND NOT EXISTS(SELECT 1 FROM dbo.TeslimatKayitlari TK WHERE TK.SiparisID=S.SiparisID);

COMMIT TRANSACTION;
GO

SELECT
    (SELECT COUNT(*) FROM dbo.SatinAlmaSiparisleri) ToplamSiparis,
    (SELECT COUNT(*) FROM dbo.TeslimatKayitlari) TamamlananTeslimat,
    (SELECT COUNT(*) FROM dbo.SatinAlmaSiparisleri S JOIN dbo.Teklifler T ON T.TeklifID=S.TeklifID
      WHERE S.SiparisDurumID<>2 AND NOT EXISTS(SELECT 1 FROM dbo.TeslimatKayitlari TK WHERE TK.SiparisID=S.SiparisID)
        AND DATEADD(DAY,T.TeslimSuresiGun,S.SiparisTarihi)<GETDATE()) GecikenSiparis,
    (SELECT COUNT(*) FROM dbo.SatinAlmaSiparisleri S JOIN dbo.Teklifler T ON T.TeklifID=S.TeklifID
      WHERE S.SiparisDurumID<>2 AND NOT EXISTS(SELECT 1 FROM dbo.TeslimatKayitlari TK WHERE TK.SiparisID=S.SiparisID)
        AND DATEADD(DAY,T.TeslimSuresiGun,S.SiparisTarihi)>=GETDATE()) BekleyenSiparis;
GO
