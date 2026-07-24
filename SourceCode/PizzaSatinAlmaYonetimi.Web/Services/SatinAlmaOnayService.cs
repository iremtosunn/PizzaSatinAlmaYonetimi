using System.Data;
using Microsoft.Data.SqlClient;
using PizzaSatinAlmaYonetimi.Web.Data;
using PizzaSatinAlmaYonetimi.Web.Models;
namespace PizzaSatinAlmaYonetimi.Web.Services;
public sealed class SatinAlmaOnayService(ISqlConnectionFactory factory):ISatinAlmaOnayService
{
 public async Task<IReadOnlyList<OnayBekleyenTeklif>>ListeleAsync(CancellationToken ct)
 {
  await using var c=factory.CreateConnection();await c.OpenAsync(ct);
  var liste=new List<OnayBekleyenTeklif>();
  await using(var cmd=Komut(c,"dbo.sp_OnayBekleyenTeklifleriListele"))
  await using(var r=await cmd.ExecuteReaderAsync(ct))
   while(await r.ReadAsync(ct))liste.Add(new(r.GetInt32("TeklifID"),r.GetString("TeklifNo"),r.GetString("TalepNo"),r.GetString("UrunAdi"),r.GetString("TalepEden"),r.GetString("FirmaAdi"),r.GetDecimal(r.GetOrdinal("TeklifTutari")),r.GetString("ParaBirimi"),r.GetInt32("TeslimSuresiGun"),r.GetDateTime("TeklifTarihi"),r.IsDBNull("GecerlilikTarihi")?null:r.GetDateTime("GecerlilikTarihi")));
  const string sql="SELECT TalepNo,ErtelenebilirMi FROM dbo.SatinAlmaTalepleri WHERE TalepNo IN (SELECT DISTINCT TalepNo FROM dbo.SatinAlmaTalepleri)";
  await using var gorusCmd=new SqlCommand(sql,c);await using var gorusReader=await gorusCmd.ExecuteReaderAsync(ct);var gorusler=new Dictionary<string,bool?>();
  while(await gorusReader.ReadAsync(ct))gorusler[gorusReader.GetString("TalepNo")]=gorusReader.IsDBNull("ErtelenebilirMi")?null:gorusReader.GetBoolean("ErtelenebilirMi");
  return liste.Select(x=>gorusler.TryGetValue(x.TalepNo,out var gorus)?x with{ErtelenebilirMi=gorus}:x).ToList();
 }
 public async Task SiparisOlusturAsync(int teklifId,int uid,CancellationToken ct){var bekleyen=await ListeleAsync(ct);var teklif=bekleyen.FirstOrDefault(x=>x.TeklifId==teklifId)??throw new InvalidOperationException("Sipariş oluşturulabilecek seçilmiş teklif bulunamadı.");await using var c=factory.CreateConnection();await c.OpenAsync(ct);await using(var cmd=Komut(c,"dbo.sp_SiparisOlustur")){cmd.Parameters.Add("@TeklifID",SqlDbType.Int).Value=teklifId;cmd.Parameters.Add("@OnaylayanKullaniciID",SqlDbType.Int).Value=uid;await cmd.ExecuteNonQueryAsync(ct);}await using var kontrol=Komut(c,"dbo.sp_SiparisleriListele");await using var r=await kontrol.ExecuteReaderAsync(ct);while(await r.ReadAsync(ct))if(r.GetString("TeklifNo")==teklif.TeklifNo)return;throw new InvalidOperationException("Sipariş oluşturulamadı.");}
 private static SqlCommand Komut(SqlConnection c,string a)=>new(a,c){CommandType=CommandType.StoredProcedure};
}
