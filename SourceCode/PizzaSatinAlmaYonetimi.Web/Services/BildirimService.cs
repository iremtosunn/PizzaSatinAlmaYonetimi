using System.Data;using Microsoft.Data.SqlClient;using PizzaSatinAlmaYonetimi.Web.Data;using PizzaSatinAlmaYonetimi.Web.Models;
namespace PizzaSatinAlmaYonetimi.Web.Services;
public sealed class BildirimService(ISqlConnectionFactory factory):IBildirimService
{
public async Task<BildirimViewModel> GetirAsync(int uid, CancellationToken ct)
{
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
 private async Task Calistir(string ad,int uid,CancellationToken ct,int? id){await using var c=factory.CreateConnection();await c.OpenAsync(ct);await using var cmd=Komut(c,ad);if(id.HasValue)cmd.Parameters.Add("@BildirimID",SqlDbType.Int).Value=id;cmd.Parameters.Add("@KullaniciID",SqlDbType.Int).Value=uid;await cmd.ExecuteNonQueryAsync(ct);}private static SqlCommand Komut(SqlConnection c,string a)=>new(a,c){CommandType=CommandType.StoredProcedure};
}

