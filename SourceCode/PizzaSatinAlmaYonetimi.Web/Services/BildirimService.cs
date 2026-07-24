using System.Data;using Microsoft.Data.SqlClient;using PizzaSatinAlmaYonetimi.Web.Data;using PizzaSatinAlmaYonetimi.Web.Models;
namespace PizzaSatinAlmaYonetimi.Web.Services;
public sealed class BildirimService(ISqlConnectionFactory factory):IBildirimService
{
public async Task<BildirimViewModel> GetirAsync(int uid, CancellationToken ct)
{
    await TeklifGecerlilikUyarilariniOlusturAsync(ct);
    await using var c = factory.CreateConnection();
    await c.OpenAsync(ct);

    await using var cmd = Komut(c, "dbo.sp_KullaniciBildirimleri");
    cmd.Parameters.Add("@KullaniciID", SqlDbType.Int).Value = uid;

    await using var r = await cmd.ExecuteReaderAsync(ct);

    var l = new List<BildirimSatiri>();

    while (await r.ReadAsync(ct))
    {
        var bildirimId = r.GetInt32(r.GetOrdinal("BildirimID"));
        var baslik = r.GetString(r.GetOrdinal("Baslik"));
        var mesaj = r.GetString(r.GetOrdinal("Mesaj"));
        var okunmaDurumu = r.GetString(r.GetOrdinal("OkunmaDurumu"));
        var olusturmaTarihi = r.GetDateTime(r.GetOrdinal("OlusturmaTarihi"));

        DateTime? okunmaTarihi = null;
        var okunmaTarihiIndex = r.GetOrdinal("OkunmaTarihi");

        if (!r.IsDBNull(okunmaTarihiIndex))
        {
            okunmaTarihi = r.GetDateTime(okunmaTarihiIndex);
        }

        l.Add(new BildirimSatiri(
            bildirimId,
            baslik,
            mesaj,
            okunmaDurumu,
            olusturmaTarihi,
            okunmaTarihi
        ));
    }

    await r.CloseAsync();
    await using(var linkCmd=new SqlCommand("SELECT BildirimID,HedefUrl FROM dbo.Bildirimler WHERE KullaniciID=@KullaniciID",c)){linkCmd.Parameters.Add("@KullaniciID",SqlDbType.Int).Value=uid;await using var linkReader=await linkCmd.ExecuteReaderAsync(ct);var linkler=new Dictionary<int,string?>();while(await linkReader.ReadAsync(ct))linkler[linkReader.GetInt32("BildirimID")]=linkReader.IsDBNull("HedefUrl")?null:linkReader.GetString("HedefUrl");await linkReader.CloseAsync();l=l.Select(x=>linkler.TryGetValue(x.BildirimId,out var url)?x with{HedefUrl=url}:x).ToList();}

    await using var say = Komut(c, "dbo.sp_OkunmamisBildirimSayisi");
    say.Parameters.Add("@KullaniciID", SqlDbType.Int).Value = uid;

    var count = Convert.ToInt32(await say.ExecuteScalarAsync(ct));

    return new()
    {
        Bildirimler = l,
        OkunmamisSayisi = count
    };
}
 public Task OkunduYapAsync(int id,int uid,CancellationToken ct)=>Calistir("dbo.sp_BildirimiOkunduYap",uid,ct,id);public Task TumunuOkunduYapAsync(int uid,CancellationToken ct)=>Calistir("dbo.sp_TumBildirimleriOkunduYap",uid,ct,null);
 public async Task TeklifGecerlilikUyarilariniOlusturAsync(CancellationToken ct){await using var c=factory.CreateConnection();await c.OpenAsync(ct);const string sql="""INSERT dbo.Bildirimler(KullaniciID,Baslik,Mesaj,OkunduMu,OlusturmaTarihi,OkunmaTarihi,HedefUrl) SELECT K.KullaniciID,N'Teklif Geçerlilik Uyarısı',CONCAT(T.TeklifNo,N' numaralı teklifin geçerlilik süresi ',CASE WHEN DATEDIFF(DAY,CAST(GETDATE() AS date),CAST(T.GecerlilikTarihi AS date))=0 THEN N'bugün sona eriyor.' ELSE N'3 gün sonra sona eriyor.' END),0,GETDATE(),NULL,CONCAT(N'/TeklifKarsilastirma?talepNo=',SAT.TalepNo) FROM dbo.Teklifler T JOIN dbo.SatinAlmaTalepleri SAT ON SAT.TalepID=T.TalepID CROSS JOIN dbo.Kullanicilar K WHERE K.RolID=1 AND K.Durum=1 AND T.TeklifDurumID=0 AND T.GecerlilikTarihi IS NOT NULL AND DATEDIFF(DAY,CAST(GETDATE() AS date),CAST(T.GecerlilikTarihi AS date)) IN(0,3) AND NOT EXISTS(SELECT 1 FROM dbo.Bildirimler B WHERE B.KullaniciID=K.KullaniciID AND B.Baslik=N'Teklif Geçerlilik Uyarısı' AND B.Mesaj=CONCAT(T.TeklifNo,N' numaralı teklifin geçerlilik süresi ',CASE WHEN DATEDIFF(DAY,CAST(GETDATE() AS date),CAST(T.GecerlilikTarihi AS date))=0 THEN N'bugün sona eriyor.' ELSE N'3 gün sonra sona eriyor.' END));""";await using var cmd=new SqlCommand(sql,c);await cmd.ExecuteNonQueryAsync(ct);}
 public Task OkunmadiYapAsync(int id,int uid,CancellationToken ct)=>OkunmadiGuncelleAsync(uid,id,ct);
 public Task TumunuOkunmadiYapAsync(int uid,CancellationToken ct)=>OkunmadiGuncelleAsync(uid,null,ct);
 private async Task OkunmadiGuncelleAsync(int uid,int? id,CancellationToken ct){await using var c=factory.CreateConnection();await c.OpenAsync(ct);var sql=id.HasValue?"UPDATE dbo.Bildirimler SET OkunduMu=0,OkunmaTarihi=NULL WHERE BildirimID=@BildirimID AND KullaniciID=@KullaniciID":"UPDATE dbo.Bildirimler SET OkunduMu=0,OkunmaTarihi=NULL WHERE KullaniciID=@KullaniciID";await using var cmd=new SqlCommand(sql,c);if(id.HasValue)cmd.Parameters.Add("@BildirimID",SqlDbType.Int).Value=id.Value;cmd.Parameters.Add("@KullaniciID",SqlDbType.Int).Value=uid;await cmd.ExecuteNonQueryAsync(ct);}
 private async Task Calistir(string ad,int uid,CancellationToken ct,int? id){await using var c=factory.CreateConnection();await c.OpenAsync(ct);await using var cmd=Komut(c,ad);if(id.HasValue)cmd.Parameters.Add("@BildirimID",SqlDbType.Int).Value=id;cmd.Parameters.Add("@KullaniciID",SqlDbType.Int).Value=uid;await cmd.ExecuteNonQueryAsync(ct);}private static SqlCommand Komut(SqlConnection c,string a)=>new(a,c){CommandType=CommandType.StoredProcedure};
}

