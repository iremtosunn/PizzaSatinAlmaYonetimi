using Microsoft.Data.SqlClient;
using PizzaSatinAlmaYonetimi.Web.Data;
using PizzaSatinAlmaYonetimi.Web.Models;
namespace PizzaSatinAlmaYonetimi.Web.Services;
public sealed class TedarikciPuanService(ISqlConnectionFactory factory):ITedarikciPuanService
{
 private const string Sql="""
 SELECT TD.TedarikciID,F.FirmaAdi,COUNT(TK.TeslimatID) TamamlananTeslimat,
        CAST(CASE WHEN COUNT(TK.TeslimatID)=0 THEN 0 ELSE 100.0*SUM(CASE WHEN TK.GercekTeslimTarihi<=DATEADD(DAY,T.TeslimSuresiGun,S.SiparisTarihi) THEN 1 ELSE 0 END)/COUNT(TK.TeslimatID) END AS decimal(5,2)) ZamanindaTeslimOrani,
        CAST(CASE WHEN COALESCE(SUM(TK.TeslimEdilenMiktar),0)=0 THEN 0 ELSE 100.0*(1-COALESCE(SUM(TK.KusurluMiktar),0)/SUM(TK.TeslimEdilenMiktar)) END AS decimal(5,2)) KaliteOrani
 FROM dbo.Tedarikciler TD INNER JOIN dbo.Firmalar F ON F.FirmaID=TD.FirmaID
 LEFT JOIN dbo.Teklifler T ON T.TedarikciID=TD.TedarikciID
 LEFT JOIN dbo.SatinAlmaSiparisleri S ON S.TeklifID=T.TeklifID
 LEFT JOIN dbo.TeslimatKayitlari TK ON TK.SiparisID=S.SiparisID
 GROUP BY TD.TedarikciID,F.FirmaAdi;
 """;
 public async Task<IReadOnlyList<TedarikciPuanBilgisi>>GetirAsync(CancellationToken ct){await using var c=factory.CreateConnection();await c.OpenAsync(ct);await using var cmd=new SqlCommand(Sql,c);await using var r=await cmd.ExecuteReaderAsync(ct);var l=new List<TedarikciPuanBilgisi>();while(await r.ReadAsync(ct)){var adet=r.GetInt32("TamamlananTeslimat");var zaman=r.GetDecimal(r.GetOrdinal("ZamanindaTeslimOrani"));var kalite=r.GetDecimal(r.GetOrdinal("KaliteOrani"));decimal? puan=adet==0?null:Math.Round(zaman*.70m+kalite*.30m,1);l.Add(new(r.GetInt32("TedarikciID"),r.GetString("FirmaAdi"),puan,adet,zaman,kalite));}return l;}
}
