using Microsoft.Data.SqlClient;
using PizzaSatinAlmaYonetimi.Web.Data;
namespace PizzaSatinAlmaYonetimi.Web.Services;
public sealed class OperasyonBildirimService(ISqlConnectionFactory factory):IOperasyonBildirimService
{
 private const string Sql="""
 /* 1. Öncelikli talep: yöneticiler */
 INSERT dbo.Bildirimler(KullaniciID,Baslik,Mesaj,OkunduMu,OlusturmaTarihi,HedefUrl)
 SELECT K.KullaniciID,N'Öncelikli Talep Bekliyor',
        CONCAT(SAT.TalepNo,N' numaralı ',SAT.UrunAdi,N' talebi uzman tarafından öncelikli olarak değerlendirildi.'),
        0,GETDATE(),CONCAT(N'/SatinAlmaTalepleri?AramaMetni=',SAT.TalepNo)
 FROM dbo.SatinAlmaTalepleri SAT CROSS JOIN dbo.Kullanicilar K
 WHERE K.RolID=1 AND K.Durum=1 AND SAT.ErtelenebilirMi=0 AND SAT.TalepDurumID IN(0,1)
 AND NOT EXISTS(SELECT 1 FROM dbo.Bildirimler B WHERE B.KullaniciID=K.KullaniciID AND B.Baslik=N'Öncelikli Talep Bekliyor' AND B.HedefUrl=CONCAT(N'/SatinAlmaTalepleri?AramaMetni=',SAT.TalepNo));

 /* 2. En az üç teklif karşılaştırmaya hazır: yöneticiler */
 INSERT dbo.Bildirimler(KullaniciID,Baslik,Mesaj,OkunduMu,OlusturmaTarihi,HedefUrl)
 SELECT K.KullaniciID,N'Teklifler Karşılaştırmaya Hazır',
        CONCAT(SAT.TalepNo,N' numaralı talep için ',COUNT(T.TeklifID),N' teklif karşılaştırmaya hazır.'),
        0,GETDATE(),CONCAT(N'/TeklifKarsilastirma?talepNo=',SAT.TalepNo)
 FROM dbo.SatinAlmaTalepleri SAT JOIN dbo.Teklifler T ON T.TalepID=SAT.TalepID
 CROSS JOIN dbo.Kullanicilar K
 WHERE K.RolID=1 AND K.Durum=1 AND T.TeklifDurumID=0
 GROUP BY K.KullaniciID,SAT.TalepNo
 HAVING COUNT(T.TeklifID)>=3
 AND NOT EXISTS(SELECT 1 FROM dbo.Bildirimler B WHERE B.KullaniciID=K.KullaniciID AND B.Baslik=N'Teklifler Karşılaştırmaya Hazır' AND B.HedefUrl=CONCAT(N'/TeklifKarsilastirma?talepNo=',SAT.TalepNo));

 /* 3. Seçilmiş teklif sipariş onayı bekliyor: yöneticiler */
 INSERT dbo.Bildirimler(KullaniciID,Baslik,Mesaj,OkunduMu,OlusturmaTarihi,HedefUrl)
 SELECT K.KullaniciID,N'Seçilen Teklif Onay Bekliyor',
        CONCAT(T.TeklifNo,N' numaralı teklif seçildi ve satın alma onayı bekliyor.'),
        0,GETDATE(),N'/SatinAlmaOnayi'
 FROM dbo.Teklifler T CROSS JOIN dbo.Kullanicilar K
 WHERE K.RolID=1 AND K.Durum=1 AND T.TeklifDurumID=1
 AND NOT EXISTS(SELECT 1 FROM dbo.SatinAlmaSiparisleri S WHERE S.TeklifID=T.TeklifID)
 AND NOT EXISTS(SELECT 1 FROM dbo.Bildirimler B WHERE B.KullaniciID=K.KullaniciID AND B.Baslik=N'Seçilen Teklif Onay Bekliyor' AND B.Mesaj=CONCAT(T.TeklifNo,N' numaralı teklif seçildi ve satın alma onayı bekliyor.'));

 /* 4a. Teslimata üç gün kaldı: yönetici ve uzman */
 INSERT dbo.Bildirimler(KullaniciID,Baslik,Mesaj,OkunduMu,OlusturmaTarihi,HedefUrl)
 SELECT K.KullaniciID,N'Teslimata 3 Gün Kaldı',
        CONCAT(S.SiparisNo,N' numaralı siparişin beklenen teslimatına 3 gün kaldı.'),
        0,GETDATE(),CONCAT(N'/TeslimatTakibi?siparisId=',S.SiparisID)
 FROM dbo.SatinAlmaSiparisleri S JOIN dbo.Teklifler T ON T.TeklifID=S.TeklifID
 CROSS JOIN dbo.Kullanicilar K
 WHERE K.RolID IN(1,2) AND K.Durum=1 AND S.SiparisDurumID<>2
 AND NOT EXISTS(SELECT 1 FROM dbo.TeslimatKayitlari TK WHERE TK.SiparisID=S.SiparisID)
 AND DATEDIFF(DAY,CAST(GETDATE() AS date),CAST(DATEADD(DAY,T.TeslimSuresiGun,S.SiparisTarihi) AS date))=3
 AND NOT EXISTS(SELECT 1 FROM dbo.Bildirimler B WHERE B.KullaniciID=K.KullaniciID AND B.Baslik=N'Teslimata 3 Gün Kaldı' AND B.HedefUrl=CONCAT(N'/TeslimatTakibi?siparisId=',S.SiparisID));

 /* 4b. Teslimat gecikti: yönetici ve uzman */
 INSERT dbo.Bildirimler(KullaniciID,Baslik,Mesaj,OkunduMu,OlusturmaTarihi,HedefUrl)
 SELECT K.KullaniciID,N'Teslimat Gecikti',
        CONCAT(S.SiparisNo,N' numaralı siparişin beklenen teslimat tarihi geçti.'),
        0,GETDATE(),CONCAT(N'/TeslimatTakibi?siparisId=',S.SiparisID)
 FROM dbo.SatinAlmaSiparisleri S JOIN dbo.Teklifler T ON T.TeklifID=S.TeklifID
 CROSS JOIN dbo.Kullanicilar K
 WHERE K.RolID IN(1,2) AND K.Durum=1 AND S.SiparisDurumID<>2
 AND NOT EXISTS(SELECT 1 FROM dbo.TeslimatKayitlari TK WHERE TK.SiparisID=S.SiparisID)
 AND CAST(DATEADD(DAY,T.TeslimSuresiGun,S.SiparisTarihi) AS date)<CAST(GETDATE() AS date)
 AND NOT EXISTS(SELECT 1 FROM dbo.Bildirimler B WHERE B.KullaniciID=K.KullaniciID AND B.Baslik=N'Teslimat Gecikti' AND B.HedefUrl=CONCAT(N'/TeslimatTakibi?siparisId=',S.SiparisID));

 /* 5. Kusur oranı yüzde 3 veya üstü: yönetici ve uzman */
 INSERT dbo.Bildirimler(KullaniciID,Baslik,Mesaj,OkunduMu,OlusturmaTarihi,HedefUrl)
 SELECT K.KullaniciID,N'Yüksek Kusur Oranı',
        CONCAT(S.SiparisNo,N' numaralı teslimatta kusur oranı %',
               CONVERT(varchar(20),CAST(100.0*TK.KusurluMiktar/TK.TeslimEdilenMiktar AS decimal(5,2))),N' olarak kaydedildi.'),
        0,GETDATE(),CONCAT(N'/TeslimatTakibi?siparisId=',S.SiparisID)
 FROM dbo.TeslimatKayitlari TK JOIN dbo.SatinAlmaSiparisleri S ON S.SiparisID=TK.SiparisID
 CROSS JOIN dbo.Kullanicilar K
 WHERE K.RolID IN(1,2) AND K.Durum=1 AND TK.TeslimEdilenMiktar>0
 AND TK.KusurluMiktar/TK.TeslimEdilenMiktar>=.03
 AND NOT EXISTS(SELECT 1 FROM dbo.Bildirimler B WHERE B.KullaniciID=K.KullaniciID AND B.Baslik=N'Yüksek Kusur Oranı' AND B.HedefUrl=CONCAT(N'/TeslimatTakibi?siparisId=',S.SiparisID));
 """;
 public async Task BildirimleriOlusturAsync(CancellationToken ct){await using var c=factory.CreateConnection();await c.OpenAsync(ct);await using var cmd=new SqlCommand(Sql,c);cmd.CommandTimeout=60;await cmd.ExecuteNonQueryAsync(ct);}
}
