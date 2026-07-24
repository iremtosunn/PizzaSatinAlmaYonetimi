using System.Data;
using System.Globalization;
using Microsoft.Data.SqlClient;
using PizzaSatinAlmaYonetimi.Web.Data;
using PizzaSatinAlmaYonetimi.Web.Models;
namespace PizzaSatinAlmaYonetimi.Web.Services;
public sealed class RaporlarService(ISqlConnectionFactory factory):IRaporlarService
{
 private static readonly IReadOnlyDictionary<string,string> Prosedurler=new Dictionary<string,string>{{RaporTurleri.AylikTalep,"dbo.sp_RaporAylikTalep"},{RaporTurleri.AylikTeklif,"dbo.sp_RaporAylikTeklif"},{RaporTurleri.EnCokTeklifVerenFirmalar,"dbo.sp_RaporEnCokTeklifVerenFirmalar"},{RaporTurleri.EnCokSatinAlmaYapilanFirmalar,"dbo.sp_RaporEnCokSatinAlmaYapilanFirmalar"},{RaporTurleri.YaklasanTeklifler,"dbo.sp_RaporYaklasanTeklifler"},{RaporTurleri.KullaniciTalepSayisi,"dbo.sp_RaporKullaniciTalepSayisi"},{RaporTurleri.AylikSatinAlmaTutari,"dbo.sp_RaporAylikSatinAlmaTutari"},{RaporTurleri.TalepDurumlari,"dbo.sp_RaporTalepDurumlari"},{RaporTurleri.TeklifDurumlari,"dbo.sp_RaporTeklifDurumlari"},{RaporTurleri.SiparisDurumlari,"dbo.sp_RaporSiparisDurumlari"}};
 public async Task<RaporlarViewModel>GetirAsync(string? tur,CancellationToken ct)
 {
  var secim=Prosedurler.ContainsKey(tur??"")?tur!:RaporTurleri.AylikTalep;await using var c=factory.CreateConnection();await c.OpenAsync(ct);
  var sutunlar=Array.Empty<string>();var satirlar=new List<IReadOnlyList<string>>();
  await using(var cmd=new SqlCommand(Prosedurler[secim],c){CommandType=CommandType.StoredProcedure})await using(var r=await cmd.ExecuteReaderAsync(ct)){sutunlar=Enumerable.Range(0,r.FieldCount).Select(r.GetName).ToArray();while(await r.ReadAsync(ct)){var row=new string[r.FieldCount];for(var i=0;i<r.FieldCount;i++)row[i]=Metin(r.GetValue(i));satirlar.Add(row);}}
  var model=new RaporlarViewModel{RaporTuru=secim,Sutunlar=sutunlar,Satirlar=satirlar};
  const string sql="""
  SELECT (SELECT COUNT(*) FROM dbo.SatinAlmaTalepleri) ToplamTalep,(SELECT COUNT(*) FROM dbo.Teklifler) ToplamTeklif,(SELECT COUNT(*) FROM dbo.SatinAlmaSiparisleri) ToplamSiparis,(SELECT COUNT(*) FROM dbo.Tedarikciler WHERE TedarikciDurumID=1) AktifTedarikci,COALESCE((SELECT SUM(T.TeklifTutari) FROM dbo.SatinAlmaSiparisleri S JOIN dbo.Teklifler T ON T.TeklifID=S.TeklifID),0) ToplamHarcama,(SELECT COUNT(*) FROM dbo.SatinAlmaTalepleri WHERE ErtelenebilirMi=0) OncelikliTalep;
  SELECT FORMAT(S.SiparisTarihi,'yyyy-MM') Ay,SUM(T.TeklifTutari) Tutar FROM dbo.SatinAlmaSiparisleri S JOIN dbo.Teklifler T ON T.TeklifID=S.TeklifID GROUP BY FORMAT(S.SiparisTarihi,'yyyy-MM') ORDER BY Ay;
  SELECT CASE TalepDurumID WHEN 0 THEN N'İnceleniyor' WHEN 1 THEN N'Teklif Sürecinde' WHEN 2 THEN N'Onaylandı' WHEN 3 THEN N'Reddedildi' ELSE N'Diğer' END Durum,COUNT(*) Adet FROM dbo.SatinAlmaTalepleri GROUP BY TalepDurumID ORDER BY Adet DESC;
  SELECT TOP 7 F.FirmaAdi,COUNT(S.SiparisID) SiparisSayisi,SUM(T.TeklifTutari) ToplamTutar FROM dbo.SatinAlmaSiparisleri S JOIN dbo.Teklifler T ON T.TeklifID=S.TeklifID JOIN dbo.Tedarikciler TD ON TD.TedarikciID=T.TedarikciID JOIN dbo.Firmalar F ON F.FirmaID=TD.FirmaID GROUP BY F.FirmaAdi ORDER BY ToplamTutar DESC;
  SELECT COUNT(TK.TeslimatID) Tamamlanan,SUM(CASE WHEN TK.TeslimatID IS NULL AND DATEADD(DAY,T.TeslimSuresiGun,S.SiparisTarihi)<GETDATE() THEN 1 ELSE 0 END) Geciken,CAST(CASE WHEN COUNT(TK.TeslimatID)=0 THEN 0 ELSE 100.0*SUM(CASE WHEN TK.GercekTeslimTarihi<=DATEADD(DAY,T.TeslimSuresiGun,S.SiparisTarihi) THEN 1 ELSE 0 END)/COUNT(TK.TeslimatID) END AS decimal(5,2)) ZamanindaOrani,CAST(CASE WHEN COALESCE(SUM(TK.TeslimEdilenMiktar),0)=0 THEN 0 ELSE 100.0*SUM(TK.KusurluMiktar)/SUM(TK.TeslimEdilenMiktar) END AS decimal(5,2)) KusurOrani FROM dbo.SatinAlmaSiparisleri S JOIN dbo.Teklifler T ON T.TeklifID=S.TeklifID LEFT JOIN dbo.TeslimatKayitlari TK ON TK.SiparisID=S.SiparisID WHERE S.SiparisDurumID<>2;
  """;
  await using var q=new SqlCommand(sql,c);await using var d=await q.ExecuteReaderAsync(ct);
  if(await d.ReadAsync(ct))model.Kpi=new(){ToplamTalep=d.GetInt32("ToplamTalep"),ToplamTeklif=d.GetInt32("ToplamTeklif"),ToplamSiparis=d.GetInt32("ToplamSiparis"),AktifTedarikci=d.GetInt32("AktifTedarikci"),ToplamHarcama=d.GetDecimal(d.GetOrdinal("ToplamHarcama")),OncelikliTalep=d.GetInt32("OncelikliTalep")};
  await d.NextResultAsync(ct);var aylar=new List<RaporGrafikNoktasi>();while(await d.ReadAsync(ct))aylar.Add(new(d.GetString("Ay"),d.GetDecimal(d.GetOrdinal("Tutar"))));model.AylikHarcama=aylar;
  await d.NextResultAsync(ct);var durumlar=new List<RaporGrafikNoktasi>();while(await d.ReadAsync(ct))durumlar.Add(new(d.GetString("Durum"),d.GetInt32("Adet")));model.TalepDurumDagilimi=durumlar;
  await d.NextResultAsync(ct);var firmalar=new List<RaporTedarikciOzeti>();while(await d.ReadAsync(ct))firmalar.Add(new(d.GetString("FirmaAdi"),d.GetInt32("SiparisSayisi"),d.GetDecimal(d.GetOrdinal("ToplamTutar"))));model.EnYuksekHarcamaTedarikcileri=firmalar;
  await d.NextResultAsync(ct);if(await d.ReadAsync(ct))model.Teslimat=new(){Tamamlanan=d.GetInt32("Tamamlanan"),Geciken=d.IsDBNull("Geciken")?0:d.GetInt32("Geciken"),ZamanindaOrani=d.GetDecimal(d.GetOrdinal("ZamanindaOrani")),KusurOrani=d.GetDecimal(d.GetOrdinal("KusurOrani"))};
  return model;
 }
 private static string Metin(object v)=>v switch{DBNull=>"",DateTime x=>x.ToString("dd.MM.yyyy",CultureInfo.GetCultureInfo("tr-TR")),decimal x=>x.ToString("N2",CultureInfo.GetCultureInfo("tr-TR")),_=>Convert.ToString(v,CultureInfo.GetCultureInfo("tr-TR"))??""};
}
